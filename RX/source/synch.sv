`timescale 1ns / 10ps

module synch #(RST_VAL = 0) (
    input logic clk,
    input logic n_rst,
    input logic async_in,
    output logic sync_out
);

    logic sync1;
    logic sync2;

    always_ff @(posedge clk or negedge n_rst) begin
        if(!n_rst) begin
            sync1 <= RST_VAL;
        end else begin
            sync1 <= async_in;
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if(!n_rst) begin
            sync2 <= RST_VAL;
        end else begin
            sync2 <= sync1;
        end
    end

    assign sync_out = sync2;
endmodule