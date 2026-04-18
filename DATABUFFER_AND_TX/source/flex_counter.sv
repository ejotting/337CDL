`timescale 1ns / 10ps

module flex_counter #(parameter SIZE = 8) (
    input logic clk, n_rst, clear, count_enable, 
    input logic [SIZE-1:0] rollover_val,
    output logic [SIZE-1:0] count_out,
    output logic rollover_flag
);
    logic [SIZE-1:0] count, next_count;
    logic flag, next_flag;

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            count <= '0;
            flag <= 0;
        end
        else begin
            count <= next_count;
            flag <= next_flag;
        end
    end

    always_comb begin
        //rollover_flag = 0; //active-high rollover flag. be asserted when counter is at rollover value & cleared with the next increment
        if (clear) begin
            next_count = 0;
            next_flag = 0;
        end
        else if ((count + 1) < rollover_val && count_enable) begin 
            next_count = count + 1;
            next_flag = 0;
        end
        else if ((count + 1) == rollover_val && count_enable) begin //rollover
            next_count = count + 1;
            next_flag = 1;
        end
        else if ((count + 1) > rollover_val && count_enable) begin 
            next_count = 1;
            next_flag = 0;
        end
        else begin // if !count_enable, then everything stays the same
            next_count = count;
            next_flag = flag;
        end
    end

    assign count_out = count;
    assign rollover_flag = flag;

endmodule

