`timescale 1ns / 10ps

module crc5 #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    input logic start5,
    input logic sample_the_data,
    input logic crc5_in,
    input logic rx_transfer_active,

    output logic [4:0]crc5_out
);

logic next_bit_ready, bit_ready;
logic [4:0]po;
logic [4:0]polynomial;
assign polynomial = 5'b00101;
logic [4:0]int1, int2;
logic fb, shift, next_shift;

always_ff @(posedge clk or negedge n_rst) begin

    if(!n_rst) begin
        bit_ready <= 1'b0;
        shift <= 1'b0;
        po <= 5'b11111;
    end else begin
        bit_ready <= next_bit_ready;
        shift <= next_shift;
        if(!rx_transfer_active) po <= 5'b11111;
        else if(shift) po <= int2;
    end

end



always_comb begin
    next_shift = 0;
    next_bit_ready = 1'b0;
    fb = po[4] ^ crc5_in;
    int1 = {po[3:0], 1'b0};
    int2 = int1;

    if(sample_the_data && start5) next_bit_ready = 1'b1;
        
    if(fb) int2 = int1 ^ polynomial;

    if(bit_ready) begin
        next_shift = 1;
    end

end

assign crc5_out = ~po;

endmodule

