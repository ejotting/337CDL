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
    logic next_clear;
    logic [2:0] next_tx_packet;
    logic tx_active_prev;
    logic [15:0] safe_write_data;
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

    assign rx_packet_flag={RX_packet==3'b011,RX_packet==3'b010,RX_packet==3'b110,RX_packet==3'b100,RX_packet==3'b101};
    assign tx_done=(tx_active_prev==1) && (TX_transferactive==0);

    always_comb begin
        next_tx_packet=tx_packet;
        next_clear=clear;
        hready=1;
        hresp=0;
        hrdata='0;
        store_tx_data=0;
        get_rx_data=0;
        next_error_state=0;
        case(hsize_reg) 
            3'b000: safe_write_data={{(DATA_WIDTH*8-8){1'b0}},hwdata[7:0]};
            3'b001: safe_write_data={{(DATA_WIDTH*8-16){1'b0}},hwdata[15:0]};
            3'b010: safe_write_data=hwdata;
            default: safe_write_data=hwdata;
        endcase
        TX_data=safe_write_data[7:0];
        D_mode=TX_transferactive;
        if(error_state==1) begin
            hready=0;
            hresp=1;
            next_error_state=0;
        end else if(hsel_reg && (htrans_reg==NONSEQ || htrans_reg==SEQ)) begin
            if(!hwrite_reg && (haddr_reg==4'h0)&& RX_dataready==0) begin
                hready=0;
                hrdata='0;
            end else if(hwrite_reg) begin
                case (haddr_reg)
                    4'h0: store_tx_data=1;
                    4'hC:next_tx_packet=safe_write_data[2:0];
                    4'hD: next_clear=hwdata[8];
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
                        hrdata[0]=RX_error;
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
                        hrdata[2:0]=tx_packet;
                    end
                    4'hD: begin
                        hrdata[8]=clear;
                    end
                    default: begin
                        hready=1;
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


endmodule

