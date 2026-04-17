`timescale 1ns / 10ps

module flex_sr #(parameter SIZE = 8, parameter MSB_FIRST = 0) (
    input logic clk, n_rst, shift_enable, load_enable, serial_in,
    input logic [SIZE-1:0] parallel_in,
    output logic serial_out,
    output logic [SIZE-1:0] parallel_out
);

    logic [SIZE-1:0] next_parallel_out;

    always_comb begin
        if (load_enable) begin     
            next_parallel_out = parallel_in;
        end
        else if (shift_enable && !MSB_FIRST) begin //shift right
            next_parallel_out = {serial_in, parallel_out[SIZE-1:1]};
        end
        else if (shift_enable && MSB_FIRST) begin //shift left
            next_parallel_out = {parallel_out[SIZE-2:0], serial_in};
        end
        else begin
            next_parallel_out = parallel_out;
        end
    end

    //assign parallel_out = '1; //starts with all 1
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            parallel_out <= '1;
        end
        else begin
            parallel_out <= next_parallel_out;
        end
    end

    assign serial_out = (MSB_FIRST) ? parallel_out[SIZE-1] : parallel_out[0]; //serial_out should be the LSB/MSB of the current state 
endmodule

