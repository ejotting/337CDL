`timescale 1ns / 10ps

module ahb_subordinate_usb #(
    parameter DATA_WIDTH=2,
    parameter ADDR_WIDTH=4

) (
    input logic clk, n_rst,
    //AHB
    input logic hsel,
    input logic [ADDR_WIDTH-1:0] haddr,
    input logic [1:0] hsize, htrans,
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
    logic [1:0] hsize_reg, htrans_reg;
    logic [2:0] hburst_reg;
    logic hwrite_reg;
    logic [4:0] rx_packet_flag;
    logic error_state, next_error_state;
    logic error_state2, next_error_state2;
    logic next_clear;
    logic [2:0] next_tx_packet;
    logic tx_active_prev;
    logic [(DATA_WIDTH*8)-1:0] safe_write_data;
    logic tx_done;
    

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

    logic addr_overflow, addr_overflow_reg;
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
        next_tx_packet=TX_packet;
        next_clear=clear;
        hready=1;
        hresp=0;
        hrdata='0;
        store_tx_data=0;
        get_rx_data=0;
        next_error_state=0;
        next_error_state2=0;
        case(hsize_reg) 
            2'b00: safe_write_data={{(DATA_WIDTH*8-8){1'b0}},hwdata[7:0]};
            2'b01: safe_write_data={{(DATA_WIDTH*8-16){1'b0}},hwdata[15:0]};
            2'b10: safe_write_data=hwdata;
            default: safe_write_data=hwdata;
        endcase
        TX_data=safe_write_data[7:0];
        D_mode=TX_transferactive;
        if(error_state2) begin
            hready=1;
            hresp=1;
            next_error_state=0;
        end else if(error_state) begin
            hready=0;
            hresp=1;
            next_error_state=0;
            next_error_state2=1;
        end else if (addr_overflow_reg) begin
            hready=0;
            hresp=1;
            next_error_state2=1;
        
        end else if (addr_overflow && htrans_reg==SEQ) begin
            hready=0;
            hresp=1;
            next_error_state=1;
        
        end else if(hsel_reg && (htrans_reg==NONSEQ || htrans_reg==SEQ)) begin
            if(!hwrite_reg && (haddr_reg==4'h0)&& RX_dataready==0) begin
                hready=0;
                hrdata='0;
            end else if(hwrite_reg) begin
                case (haddr_reg)
                    4'h0: store_tx_data=1;
                    4'hC:next_tx_packet=safe_write_data[2:0];
                    4'hD: begin
                        if(safe_write_data[0]) begin
                            next_clear=1;
                        end
                    end
                    default: begin
                        hready=0;
                        hresp=1;
                        next_error_state=1;
                    end
                endcase
            end else begin
                case(haddr_reg) 
                    4'h0: begin
                        get_rx_data=1;
                        hrdata[7:0]=RX_data;
                    end
                    4'h4: begin
                        hrdata[0]=RX_dataready;
                        hrdata[5:1]=rx_packet_flag;
                        hrdata[8]=RX_transferactive;
                        hrdata[9]=TX_transferactive;
                        
                    end
                    4'h6: begin
                        hrdata[0]=RX_error;
                        hrdata[8]=TX_error;
                    end
                    4'h8: begin
                        hrdata[6:0]=bufferoccupancy;
                    end
                    4'hC: begin
                        hrdata[2:0]=TX_packet;
                    end
                    4'hD: begin
                        hrdata[0]=clear;
                    end
                    default: begin
                        hready=0;
                        hresp=1;
                        next_error_state=1;
                    end
                endcase
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
            addr_overflow_reg<='0;
            TX_packet<='0;
            clear<='0;
            tx_active_prev<='0;
            beat_cnt<='0;
            burst_base_addr<='0;
        end else begin
            hsel_reg<=hsel;
            haddr_reg<=next_haddr_reg;
            hsize_reg<=hsize;
            htrans_reg<=htrans;
            hburst_reg<=hburst;
            hwrite_reg<=hwrite;
            error_state<=next_error_state;
            error_state2<=next_error_state2;
            addr_overflow_reg<=addr_overflow;
            TX_packet<=next_tx_packet;
            clear<=next_clear;
            tx_active_prev<=TX_transferactive;
            beat_cnt<=next_beat_cnt;
            burst_base_addr<=next_burst_base_addr;
        end
    end
endmodule

