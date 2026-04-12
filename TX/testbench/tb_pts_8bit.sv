`timescale 1ns / 10ps
module tb_pts_8bit ();
    // TODO REWRITE!!!
    localparam CLK_PERIOD = 2.5ns;

    //DUT portmap signals
    logic clk, n_rst, shift_enable, load_enable, serial_out;
    logic [3:0] parallel_in;

    //tb task
    logic [3:0] out_4bit;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        shift_enable = 0;
        load_enable = 0;

        n_rst = 0; //this means that all parallel_out values will be set to '1
        
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        n_rst = 1;

        @(posedge clk);
        @(posedge clk);

        out_4bit = '1; //reset
    end
    endtask

    task get_parallel_out;
    begin

        shift_enable = 1;
        load_enable = 0; 

        out_4bit[0] = serial_out; 
        @(negedge clk); #(0.1); 
        out_4bit[1] = serial_out;
        @(negedge clk); #(0.1); 
        out_4bit[2] = serial_out;
        @(negedge clk); #(0.1); 
        out_4bit[3] = serial_out;

    end
    endtask


    //TODO create DUT instance of pts_4bit
    pts_8bit DUT(
        .clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), 
        .load_enable(load_enable), .parallel_in(parallel_in),
        .serial_out(serial_out));

    initial begin
        //RESET
        n_rst = 1;
        reset_dut();
        #(0.1); //wait before first test case

        //TESTCASES
        //TODO required testcases:
        //  - Power-On Reset (Check that all outputs reset to the default value described in A.2.)
        //  - Fill SR with 4'b0000
        //  - Load a non-idle, nonzero constant (e.g. 4'b1010)
        //  - Discontinuous shifting
        //  - Load while shifting to check priority
        $finish;
    end

endmodule

/* verilator coverage_on */

