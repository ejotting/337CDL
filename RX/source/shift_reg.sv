`timescale 1ns / 10ps

module shift_reg (
    input logic clk, 
    input logic n_rst,
    input logic data_out,
    input logic sample_the_data,
    input logic valid_bit,

    output logic [15:0]shift_reg_val,
    output logic [7:0]rx_data
);

logic [23:0]po;
/* verilator lint_off PINMISSING */
flex_sr #(.SIZE(24),.MSB_FIRST(0)) SHIFTREG (.clk(clk),.n_rst(n_rst),
.shift_enable(valid_bit && sample_the_data),.serial_in(data_out),.parallel_out(po)); 

assign shift_reg_val = po[23:8];
assign rx_data = po[7:0];

endmodule

