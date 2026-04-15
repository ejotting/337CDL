`timescale 1ns / 10ps

module bit_stuff_checker #(
    // parameters
) (
    input logic clk, 
    input logic n_rst,
    input logic sample_the_data,
    input logic eof,
    input logic data_in,
    input logic rx_transfer_active,

    output logic error,
    output logic valid_bit
);

    logic [6:0]po;

/* verilator lint_off PINMISSING */

flex_sr #(.SIZE(7),.MSB_FIRST(1)) SHIFTR (.clk(clk),.n_rst(n_rst),.shift_enable(sample_the_data && !eof),
.serial_in(data_in),.parallel_out(po),.load_enable(1'b0));

always_comb begin
    
    if(po[5:0] == 6'b111111 && rx_transfer_active) valid_bit = 0;
    else valid_bit = 1;

    if(po == 7'b1111111 && rx_transfer_active) error = 1;
    else error = 0;

end

endmodule

