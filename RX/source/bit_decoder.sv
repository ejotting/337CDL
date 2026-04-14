`timescale 1ns / 10ps

module bit_decoder (
    input logic clk, 
    input logic n_rst,
    input logic dm,
    input logic dp,
    output logic new_edge,
    output logic eof
);

logic past_dm, past_dp;

always_ff @(posedge clk or negedge n_rst) begin

    if(!n_rst) begin
        past_dm <= 1'b0;
        past_dp <= 1'b0;
    end else begin
        past_dm <= dm;
        past_dp <= dp;
    end

end

always_comb begin

    if(past_dm != dm && past_dp != dp) new_edge = 1'b1;
    else new_edge = 1'b0;

end

assign eof = !dm && !dp;

endmodule

