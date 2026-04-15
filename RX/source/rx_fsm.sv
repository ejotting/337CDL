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
    input logic valid_bit,

    output logic flush,
    output logic rx_data_ready,
    output logic store_rx_packet_data,
    output logic [2:0]rx_packet,
    output logic rx_error,
    output logic rx_transfer_active,
    output logic start16,
    output logic start5

);

logic [4:0]count_out;
logic clear;

logic enable;

assign enable = sample_the_data && !eof && valid_bit;
/* verilator lint_off PINMISSING */
flex_ctr #(.SIZE(5)) TIMER (.clk(clk),.n_rst(n_rst),.count_enable(1'b1),
.clear(clear),.count_out(count_out));

typedef enum logic [3:0] {IDLE, SYNC, TOKEN, ACK, DATA1, DATA2, CRC_CHECK5, 
CRC_CHECK16, DATA_EOP, EOP1, EOP2, DATA_READY, ERROR} state_t;

state_t state, next_state;

always_ff @(posedge clk or negedge n_rst) begin

    if(!n_rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end

end

always_comb begin

    next_state = IDLE;
    flush = 0;
    rx_data_ready = 0;
    store_rx_packet_data = 0;
    rx_packet = 3'd0;
    rx_error = 0;
    rx_transfer_active = 1;
    clear = 0;
    start16 = 0;
    start5 = 0;

    case(state)
    IDLE: begin
        clear = 1;
        rx_transfer_active = 0;
        if(shift_reg_val[15:8] == 8'd1) begin next_state = SYNC; end
        else next_state = IDLE;
    end
    SYNC: begin
        next_state = SYNC;
        if(count_out == 5'd8) begin
            clear = 1;
            if(shift_reg_val[15:8] == 8'd1 || shift_reg_val[15:8] == 8'd2) next_state = TOKEN;
            else if(shift_reg_val[15:8] == 8'd3) next_state = ACK;
            else if(shift_reg_val[15:8] == 8'd4 || shift_reg_val[15:8] == 8'd5) next_state = DATA1;
            else next_state = ERROR;
        end
    end
    TOKEN: begin
        start5 = 1;
        next_state = TOKEN;
        if(count_out == 5'd11) begin
            clear = 1;
            if(shift_reg_val[15:5] == 11'b11001100000) next_state = CRC_CHECK5;
            else next_state = IDLE;
        end
    end
    ACK: begin
        next_state = EOP1;
    end
    DATA1: begin
        next_state = DATA1;
        if(count_out == 5'd16) begin next_state = DATA2; clear = 1; end
    end
    DATA2: begin
        next_state = DATA2;
        start16 = 1;
        if(count_out == 5'd8 && buffer_occupancy != 64) begin store_rx_packet_data = 1; clear = 1; end
        else if(count_out == 5'd8 && buffer_occupancy == 64) next_state = ERROR;
        if(eof && sample_the_data) next_state = CRC_CHECK16;
    end
    CRC_CHECK5: begin
        next_state = CRC_CHECK5;
        if(count_out == 5'd5) begin
            if(shift_reg_val[15:11] == crc5) next_state = IDLE;
            else next_state = ERROR;
        end
    end
    CRC_CHECK16: begin
        if(shift_reg_val == crc16) next_state = DATA_EOP;
        else next_state = ERROR;
    end
    EOP1: begin

        if(sample_the_data && eof) next_state = EOP2;
        else if(sample_the_data) next_state = ERROR;
    end
    EOP2: begin
        if(sample_the_data && eof) next_state = IDLE;
        else if(sample_the_data) next_state = ERROR;
    end
    DATA_EOP: begin
        next_state = DATA_EOP;
        if(sample_the_data && eof) next_state = DATA_READY;
        else if(sample_the_data) next_state = ERROR;
    end
    DATA_READY: begin
        next_state = IDLE;
        rx_data_ready = 1;
    end
    ERROR: begin
        next_state = IDLE;
        flush = 1;
        rx_error = 1;
    end
    default: begin
        next_state = IDLE;
    end

endcase

end

endmodule

