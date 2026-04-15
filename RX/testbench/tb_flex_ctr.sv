`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_flex_ctr ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask
    logic clear;
    flex_ctr DUT (.clk(clk),.n_rst(n_rst),.count_enable(1'b1),.clear(clear));

    initial begin
        n_rst = 1;
        clear = 0;
        reset_dut;
        repeat(10) @(negedge clk);
        $finish;
    end
endmodule

/* verilator coverage_on */

