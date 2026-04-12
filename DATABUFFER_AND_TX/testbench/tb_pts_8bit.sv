`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_pts_8bit ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // DUT portmap signals
    logic clk, n_rst, shift_enable, load_enable, serial_out;
    logic [7:0] parallel_in;

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

    task initialize;
    begin
        shift_enable = 0;
        load_enable = 0;
        parallel_in = '0;
    end
    endtask

    task data_clk_strobes;
    begin
        repeat(2) begin
            //8th system clk
            shift_enable = 0;
            repeat(7) begin
                @(negedge clk);
            end
            shift_enable = 1;
            @(negedge clk);

            //16th system clk
            shift_enable = 0;
            repeat(7) begin
                @(negedge clk);
            end
            shift_enable = 1;
            @(negedge clk);

            //25th system clk
            shift_enable = 0;
            repeat(8) begin
                @(negedge clk);
            end
            shift_enable = 1;
            @(negedge clk);
        end

        shift_enable = 0;
        repeat(7) begin
            @(negedge clk);
        end
        shift_enable = 1;
        @(negedge clk);

        shift_enable = 0;

    end
    endtask

    // DUT instance
    pts_8bit DUT (
        .clk(clk),
        .n_rst(n_rst),
        .shift_enable(shift_enable),
        .load_enable(load_enable),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;
        @(negedge clk);

        $display("Normal 8-bit Bus Load on System Clk");
        load_enable = 1;
        parallel_in = 8'b00110011;
        @(negedge clk); //load parallel_in to DUT & get first serial_out bit
        load_enable = 0;
        shift_enable = 1;
        repeat(7) begin //rest of the 7 serial_out bits
            @(negedge clk);
        end
        shift_enable = 0;

        $display("Normal 8-bit Bus Load on Data Clk");
        load_enable = 1;
        parallel_in = 8'b11101101;
        @(negedge clk); //load
        load_enable = 0;
        data_clk_strobes;
    
        $finish;
    end
endmodule

/* verilator coverage_on */

