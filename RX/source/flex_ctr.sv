`timescale 1ns / 10ps

module flex_ctr #(parameter SIZE = 8) (
    input logic clk,
    input logic n_rst,
    input logic clear,
    input logic count_enable,
    input logic [SIZE-1:0]rollover_val,
    output logic [SIZE-1:0]count_out,
    output logic rollover_flag
);

logic [SIZE-1:0]next_count;
logic flag;

always_comb begin

    if(count_out == rollover_val - 1) begin
        flag = 1'b1;
    end else begin
        flag = 1'b0;
    end

    if(clear) begin
        next_count = 0;
        flag = 0;
    end else if(count_enable) begin
        if(count_out >= rollover_val) begin
            next_count = 1;
        end else begin
            next_count = count_out + 1;
        end
    end else begin
        next_count = count_out;
        flag = rollover_flag;
    end
end

always_ff @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        count_out <= 0;
        rollover_flag <= 1'b0;
    end else begin
        count_out <= next_count;
        rollover_flag <= flag;
    end
end



endmodule
