`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_data_clk_gen ();

    localparam CLK_PERIOD = 50ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, new_edge;

    data_clk_gen DUT (.clk(clk),.n_rst(n_rst),.new_edge(new_edge));

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


    initial begin
        n_rst = 1;
        new_edge = 0;
        reset_dut;
        @(negedge clk);
        new_edge = 1;
        @(negedge clk);
        new_edge = 0;
        repeat(8) @(negedge clk);
        new_edge = 1;
        @(negedge clk);
        new_edge = 0;
        repeat(64) @(negedge clk);
        new_edge = 1;
        @(negedge clk);
        new_edge = 0;
        repeat(8) @(negedge clk);
        new_edge = 1;
        @(negedge clk);
        new_edge = 0;
        repeat(8) @(negedge clk);
        new_edge = 1;
        @(negedge clk);
        new_edge = 0;
        repeat(8) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

