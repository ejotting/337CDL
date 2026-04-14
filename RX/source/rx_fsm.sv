`timescale 1ns / 10ps

module rx_fsm #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    input logic [15:0]shift_reg_val,
    input logic [6:0]buffer_occupancy,
    input logic sample_the_data,
    input logic [4:0]crc5,
    input logic [15:0]crc16,
    input logic eof,

    output logic flush,
    output logic rx_data_ready,
    output logic store_rx_packet_data,
    output logic [2:0]rx_packet,
    output logic [7:0]packet_data,
    output logic rx_error,
    output logic rx_transfer_active

);

logic [3:0]count_out;
logic clear;

flex_ctr #(.SIZE(4)) TIMER (.clk(clk),.n_rst(n_rst),.count_enable(sample_the_data),
.clear(clear),.count_out(count_out));

typedef enum logic [3:0] {IDLE, SYNC, TOKEN, ACK, DATA, CRC_CHECK5, 
CRC_CHECK16, EOP1, EOP2, DATA_READY, ERROR} state_t;

state_t state, next_state;

always_comb begin

    next_state = IDLE;
    flush = 0;
    rx_data_ready = 0;
    store_rx_packet_data = 0;
    rx_packet = 3'd0;
    packet_data = 8'd0;
    rx_error = 0;
    rx_transfer_active = 1;
    clear = 0;

    case(state)
    IDLE: begin
        rx_transfer_active = 0;
        if(shift_reg_val == 8'd1) begin next_state = SYNC; clear = 1; end
        else next_state = IDLE;
    end
    SYNC: begin
        next_state = SYNC;
        if(count_out == 4'd8) begin
            clear = 1;
            if(shift_reg_val == 8'd1 || shift_reg_val == 8'd2) next_state = TOKEN;
            else if(shift_reg_val == 8'd3) next_state = ACK;
            else if(shift_reg_val == 8'd4 || shift_reg_val == 8'd5) next_state = DATA;
            else next_state = ERROR;
        end
    end
    TOKEN: begin
        next_state = TOKEN;
        if(count_out == 4'd11) begin
            clear = 1;
            if(shift_reg_val[15:5] == 11'b11001100000) next_state = CRC_CHECK5;
            else next_state = IDLE;
        end
    end
    ACK: begin
        next_state = EOP1;
    end
    DATA: begin
        next_state = DATA;
         
    end
    CRC_CHECK5: begin
        next_state = CRC_CHECK5;
        if(count_out == 4'd5) begin
            if(shift_reg_val[15:11] == crc5) next_state = IDLE;
            else next_state = ERROR;
        end
    end
    CRC_CHECK16: begin
        if(shift_reg_val == crc16) next_state = IDLE;
        else next_state = ERROR;
    end
    EOP1: begin

    end
    EOP2: begin

    end
    DATA_READY: begin

    end
    ERROR: begin

    end
    default: begin
        next_state = IDLE;
    end

endcase

end

endmodule

