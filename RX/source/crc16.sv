`timescale 1ns / 10ps

module crc16 #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    input logic start16,
    input logic sample_the_data,
    input logic crc16_in,
    input logic rx_transfer_active,

    output logic [15:0]crc16_out
);

logic next_bit_ready, bit_ready;
logic [15:0]po;
logic [15:0]polynomial;
assign polynomial = 16'b1000000000000101;
logic [15:0]int1, int2;
logic fb, shift, next_shift;

always_ff @(posedge clk or negedge n_rst) begin

    if(!n_rst) begin
        bit_ready <= 1'b0;
        shift <= 1'b0;
        po <= 16'b1111111111111111;
    end else begin
        bit_ready <= next_bit_ready;
        shift <= next_shift;
        if(!rx_transfer_active) po <= 16'b1111111111111111;
        else if(shift) po <= int2;
    end

end



always_comb begin
    next_shift = 0;
    next_bit_ready = 1'b0;
    fb = po[15] ^ crc16_in;
    int1 = {po[14:0], 1'b0};
    int2 = int1;

    if(sample_the_data && start16) next_bit_ready = 1'b1;
        
    if(fb) int2 = int1 ^ polynomial;

    if(bit_ready) begin
        next_shift = 1;
    end

end

assign crc16_out = ~po;

endmodule
