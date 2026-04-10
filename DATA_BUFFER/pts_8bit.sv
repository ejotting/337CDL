`timescale 1ns / 10ps

module pts_8bit(
    input logic clk, n_rst, shift_enable, load_enable,
    input logic [7:0] parallel_in,
    output logic serial_out
);
    flex_sr #(.SIZE(8), .MSB_FIRST(0)) mySR(
        .clk(clk),
        .n_rst(n_rst),
        .shift_enable(shift_enable),
        .load_enable(load_enable),
        .serial_in(1'b1),
        .parallel_in(parallel_in),
        .serial_out(serial_out),
        .parallel_out()
    );
endmodule