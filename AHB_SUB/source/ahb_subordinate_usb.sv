`timescale 1ns / 10ps


module ahb_subordinate_usb #(
   parameter DATA_WIDTH=4,
   parameter ADDR_WIDTH=4
) (
   input logic clk, n_rst,
   //AHB
   input logic hsel,
   input logic [ADDR_WIDTH-1:0] haddr,
   input logic [1:0] htrans,
   input logic [2:0] hsize,
   input logic hwrite,
   input logic [(DATA_WIDTH*8)-1:0] hwdata,
   input logic [2:0] hburst,
   output logic [(DATA_WIDTH*8)-1:0] hrdata,
   output logic hresp,
   output logic hready,
   //USB
   input logic TX_error, RX_error, RX_dataready, RX_transferactive, TX_transferactive,
   input logic [2:0] RX_packet,
   input logic [7:0] RX_data,
   input logic [6:0] bufferoccupancy,
   output logic [2:0] TX_packet,
   output logic [7:0] TX_data,
   output logic clear, get_rx_data, store_tx_data, D_mode
);
   logic hsel_reg;
   logic [ADDR_WIDTH-1:0] haddr_reg;
   logic [1:0]  htrans_reg;
   logic [2:0 ] hsize_reg;
   logic [2:0] hburst_reg;
   logic hwrite_reg;
   logic [4:0] rx_packet_flag;
   logic error_state, next_error_state;
   logic error_state2, next_error_state2;
   logic next_clear;
   logic [2:0] next_tx_packet;
   logic tx_active_prev;


   logic tx_done;
   
   
   logic [7:0] next_tx_data;


   //HTRANS
   localparam IDLE=2'b00;
   localparam BUSY=2'b01;
   localparam NONSEQ=2'b10;
   localparam SEQ=2'b11;
   //HBURST
   localparam SINGLE=3'b000;
   localparam INCR=3'b001;
   localparam WRAP4=3'b010;
   localparam INCR4=3'b011;
   localparam WRAP8=3'b100;
   localparam INCR8=3'b101;
   localparam WRAP16=3'b110;
   localparam INCR16=3'b111;
   
   //HBURST
   logic [4:0] beat_cnt,next_beat_cnt;
   logic [ADDR_WIDTH-1:0] burst_base_addr, next_burst_base_addr;
   logic [ADDR_WIDTH-1:0] next_haddr_reg;
   logic [ADDR_WIDTH-1:0] next_seq_addr;
   logic [ADDR_WIDTH-1:0] addr_increment;
   logic [ADDR_WIDTH-1:0] wrap_window, wrap_base;


   logic addr_overflow;
   logic [ADDR_WIDTH-1:0] prev_end_addr, current_end_addr; 
   logic raw_hazard;
   logic hazard_stall;
   
   typedef enum logic [1:0] {
       BYTE1,
       BYTE2,
       BYTE3,
       BYTE4
   } state_t;
   state_t state, next_state;
   logic [23:0] buffer,next_buffer;
   
   assign rx_packet_flag={RX_packet==3'b101,RX_packet==3'b100,RX_packet==3'b011,RX_packet==3'b010,RX_packet==3'b001};
   assign tx_done=(tx_active_prev==1) && (TX_transferactive==0);
  
   //hburst
   always_comb begin
       next_haddr_reg=haddr_reg;
       next_burst_base_addr=burst_base_addr;
       next_beat_cnt=beat_cnt;
       addr_increment=2**hsize;
       next_seq_addr=haddr_reg+addr_increment;
       wrap_base='0;
       wrap_window='0;
       addr_overflow=0;


       if(hsel&&htrans==NONSEQ) begin
           next_haddr_reg=haddr;
           next_burst_base_addr=haddr;
           case(hburst)
               INCR4,WRAP4: next_beat_cnt=5'd3;
               INCR8,WRAP8: next_beat_cnt=5'd7;
               INCR16,WRAP16: next_beat_cnt=5'd15;
               default: next_beat_cnt=5'd0; //single
           endcase
       end else if(hsel &&htrans==SEQ) begin
           case(hburst_reg)
               INCR4, INCR8, INCR16: begin
                   addr_overflow=(haddr_reg+addr_increment>=2**ADDR_WIDTH);
                   if(addr_overflow) begin
                       next_beat_cnt='0;
                   end else begin
                       next_haddr_reg=haddr_reg+addr_increment;
                       if(beat_cnt!='0) begin
                           next_beat_cnt=beat_cnt-1;
                       end
                   end
               end
               WRAP4: begin
                   wrap_window=(4*addr_increment)-1;
                   wrap_base=burst_base_addr & ~wrap_window;
                   if((haddr_reg+addr_increment)>(wrap_base+wrap_window)) begin
                       next_haddr_reg=wrap_base;
                   end else begin
                       next_haddr_reg=haddr_reg+addr_increment;
                   end
                   if(beat_cnt!=0) begin
                       next_beat_cnt=beat_cnt-1;
                   end
               end
               WRAP8: begin
                   wrap_window=(8*addr_increment)-1;
                   wrap_base=burst_base_addr & ~wrap_window;
                   if((haddr_reg+addr_increment)>(wrap_base+wrap_window)) begin
                       next_haddr_reg=wrap_base;
                   end else begin
                       next_haddr_reg=haddr_reg+addr_increment;
                   end
                   if(beat_cnt!=0) begin
                       next_beat_cnt=beat_cnt-1;
                   end
               end
               WRAP16: begin
                   wrap_window=(16*addr_increment)-1;
                   wrap_base=burst_base_addr & ~wrap_window;
                   if((haddr_reg+addr_increment)>(wrap_base+wrap_window)) begin
                       next_haddr_reg=wrap_base;
                   end else begin
                       next_haddr_reg=haddr_reg+addr_increment;
                   end
                   if(beat_cnt!=0) begin
                       next_beat_cnt=beat_cnt-1;
                   end
               end
               INCR: next_haddr_reg=haddr;
           endcase
       end else if(htrans==IDLE||!hsel) begin
           next_beat_cnt='0;
       end
   end
  
   always_comb begin
       // Defaults
       next_tx_packet=TX_packet;
       next_clear=clear;
       hready=1;
       hresp=0;
       hrdata='0;
       store_tx_data=0;
       get_rx_data=0;
       next_error_state=0;
       next_error_state2=0;
       next_tx_data = TX_data;
       next_state = state;
       next_buffer = buffer;
       
       prev_end_addr=haddr_reg+((2**hsize_reg)-1);
       current_end_addr=haddr+((2**hsize)-1);
       raw_hazard=hsel_reg&&hwrite_reg&&hsel&&!hwrite&&(haddr<=prev_end_addr) &&(haddr_reg<=current_end_addr)&&(htrans_reg==NONSEQ||htrans_reg==SEQ) &&(!hazard_stall);
       
       D_mode=TX_transferactive;
       
       // error cases
       if(error_state2) begin
           hready=1;
           hresp=1;
           next_error_state=0;
           next_error_state2=0;
       end else if(error_state) begin
           hready=0;
           hresp=1;
           next_error_state=0;
           next_error_state2=1;
       end else if (addr_overflow) begin
           hready=0;
           hresp=0;  
           next_error_state=1;
       end else if(raw_hazard) begin
           hready=0;
       
       // FSM and Data processing
       end else if(hsel_reg && (htrans_reg==NONSEQ || htrans_reg==SEQ)) begin
           if(haddr_reg[3:2]==2'b00) begin
               case(state)
                   BYTE1: begin
                       if(!hwrite_reg) begin // READ
                           if(bufferoccupancy==0) begin
                               hready=0;
                           end else begin
                               get_rx_data=1;
                               if(hsize_reg>=3'b001) begin
                                   next_buffer[7:0]=RX_data;
                                   hready=0;
                                   next_state=BYTE2;
                               end else begin
                                    case(haddr_reg[1:0]) 
                                        2'b00:hrdata={24'b0,RX_data};
                                        2'b01:hrdata={16'b0,RX_data,8'b0};
                                        2'b10:hrdata={8'b0,RX_data,16'b0};
                                        2'b11:hrdata={RX_data,24'b0};
                                    endcase
                               end
                           end
                       end else begin // WRITE
                           case (hsize_reg)
                               3'b000: begin 
                                   case (haddr_reg[1:0])
                                       2'b00: next_tx_data = hwdata[7:0];
                                       2'b01: next_tx_data = hwdata[15:8];
                                       2'b10: next_tx_data = hwdata[23:16];
                                       2'b11: next_tx_data = hwdata[31:24];
                                   endcase
                                   store_tx_data = 1;
                               end
                               3'b001: begin 
                                   next_tx_data = hwdata[7:0];
                                   store_tx_data = 1;
                                   hready = 0;
                                   next_state = BYTE2;
                               end
                               3'b010: begin 
                                   next_tx_data = hwdata[7:0];
                                   store_tx_data = 1;
                                   hready = 0;
                                   next_state = BYTE2;
                               end
                               default: begin 
                                   next_tx_data = hwdata[7:0];
                                   store_tx_data = 1;
                               end
                           endcase
                       end
                   end
                  
                   BYTE2: begin
                       next_state=BYTE1; 
                       if(!hwrite_reg) begin
                           get_rx_data=1; 
                           if(hsize_reg>=3'b010) begin
                               next_buffer[15:8]=RX_data;
                               hready=0;
                               next_state=BYTE3;
                           end
                           else begin
                               hrdata={16'd0,RX_data,buffer[7:0]};
                           end
                       end
                       else begin
                           next_tx_data=hwdata[15:8];
                           store_tx_data=1;
                           if(hsize_reg>=3'b010) begin
                               hready=0;
                               next_state=BYTE3;
                           end
                       end
                   end
                   
                   BYTE3: begin
                       next_state=BYTE1;
                       if(!hwrite_reg) begin
                           get_rx_data=1; 
                           if(hsize_reg>=3'b010) begin
                               next_buffer[23:16]=RX_data;
                               hready=0;
                               next_state=BYTE4;
                           end
                           else begin
                               hrdata={8'd0,RX_data, buffer[15:0]};
                           end
                       end
                       else begin
                           next_tx_data=hwdata[23:16];
                           store_tx_data=1;
                           if(hsize_reg>=3'b010) begin
                               hready=0;
                               next_state=BYTE4;
                           end
                       end
                   end
                   
                   BYTE4: begin
                       next_state=BYTE1;
                       if(!hwrite_reg) begin
                           get_rx_data=1; 
                           hrdata={RX_data,buffer[23:0]};
                       end else begin
                           next_tx_data=hwdata[31:24];
                           store_tx_data=1;
                       end
                   end
               endcase
               
           end else begin
               //address not 0
               if(hwrite_reg) begin
                   case (haddr_reg)
                       4'hC: begin
                           case(hwdata[7:0]) 
                               8'hC3: next_tx_packet=3'b001;
                               8'h4B: next_tx_packet=3'b010;
                               8'hD2: next_tx_packet=3'b011;
                               8'h5A: next_tx_packet=3'b100;
                               8'h1E: next_tx_packet=3'b101;
                               default: next_tx_packet=3'b111;
                           endcase
                       end
                       4'hD: begin
                           next_clear=hwdata[8];
                       end
                       default: begin
                           hready=0;
                           hresp=0; 
                           next_error_state=1;
                       end
                   endcase
               end else begin
                   case(haddr_reg)
                       4'h4: begin
                           hrdata[0]=RX_dataready;
                           hrdata[5:1]=rx_packet_flag;
                           hrdata[8]=RX_transferactive;
                           hrdata[9]=TX_transferactive;
                       end
                       4'h6: begin
                           hrdata[16]=RX_error;
                           hrdata[24]=TX_error;
                         
                       end
                       4'h8: begin
                           hrdata[6:0]=bufferoccupancy;
                       end
                       4'hC: begin
                           hrdata[2:0]=TX_packet;
                       end
                       4'hD: begin
                           hrdata[8]=clear;
                       end
                       default: begin
                           hready=0;
                           hresp=0;
                           next_error_state=1;
                       end
                   endcase
               end
           end
       end
       
       if(tx_done) begin
           next_tx_packet=3'b000;
       end
       if(clear) begin
           next_clear=0;
       end
   end
   
   always_ff @(posedge clk, negedge n_rst) begin
       if(!n_rst) begin
           hsel_reg<='0;
           haddr_reg<='0;
           hsize_reg<='0;
           htrans_reg<='0;
           hburst_reg<='0;
           hwrite_reg<='0;
           error_state<='0;
           error_state2<='0;
           TX_packet<='0;
           TX_data<='0;
           clear<='0;
           tx_active_prev<='0;
           beat_cnt<='0;
           burst_base_addr<='0;
           hazard_stall<='0;
           state<=BYTE1;
           buffer<='0;
       end else begin
           if(hready) begin
               hsel_reg<=hsel;
               haddr_reg<=next_haddr_reg;
               hsize_reg<=hsize;
               htrans_reg<=htrans;
               hburst_reg<=hburst;
               hwrite_reg<=hwrite;
               beat_cnt<=next_beat_cnt;
               burst_base_addr<=next_burst_base_addr;
           end
           error_state<=next_error_state;
           error_state2<=next_error_state2;
           TX_packet<=next_tx_packet;
           TX_data<=next_tx_data;
           clear<=next_clear;
           tx_active_prev<=TX_transferactive;
           hazard_stall<=raw_hazard;
           state<=next_state;
           buffer<=next_buffer;
       end
   end
endmodule



