`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_crc5 ();

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

    task automatic pulse(int n, ref logic sample_the_data);
    begin
        for(int i = 0; i < n; i++) begin
            @(negedge clk);
            sample_the_data = 1;
            @(negedge clk);
            sample_the_data = 0;
            @(negedge clk);
            
        end
    end
    endtask

    logic crc5_in, start5, rx_transfer_active, sample_the_data;

    crc5 #() DUT (.clk(clk),.n_rst(n_rst),.rx_transfer_active(rx_transfer_active),
    .crc5_in(crc5_in),.sample_the_data(sample_the_data),.start5(start5));

    initial begin
        n_rst = 1;
        rx_transfer_active = 0;
        sample_the_data = 0;
        start5 = 0;
        crc5_in = 0;
        reset_dut;
        @(negedge clk);
        rx_transfer_active = 1;
        start5 = 1;
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        crc5_in = 1;
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        crc5_in = 0;
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        crc5_in = 1;
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        crc5_in = 0;
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        pulse(1, sample_the_data);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        
        $finish;
    end
endmodule

/* verilator coverage_on */

