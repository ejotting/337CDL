`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_rx_fsm ();

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

    logic [15:0]shift_reg_val;
    logic [6:0]buffer_occupancy;
    logic sample_the_data, eof, valid_bit;
    logic [4:0]crc5;
    logic [15:0]crc16;

    rx_fsm DUT (
    .clk(clk),
    .n_rst(n_rst),
    .shift_reg_val(shift_reg_val),
    .buffer_occupancy(buffer_occupancy),
    .sample_the_data(sample_the_data),
    .crc5(crc5),
    .crc16(crc16),
    .eof(eof),
    .valid_bit(valid_bit));

    initial begin
        n_rst = 1;
        crc5 = 5'b11111;
        crc16 = 16'hFFFF;
        eof = 0;
        valid_bit = 1;
        buffer_occupancy = 7'd0;
        shift_reg_val = 16'd0;
        sample_the_data = 0;
        reset_dut;
        //Valid token packet
        @(negedge clk);
        shift_reg_val = 16'b0000000100000000;
        @(negedge clk);
        shift_reg_val = 16'b0000001000000000;
        pulse(8,sample_the_data);
        shift_reg_val = 16'b1100110000000000;
        pulse(11,sample_the_data);
        shift_reg_val = 16'b1101100000000000;
        crc5 = 5'b11011;
        pulse(5, sample_the_data);
        eof = 1;
        pulse(2, sample_the_data);
        eof = 0;

        //Zero data data packet
        @(negedge clk);
        shift_reg_val = 16'b0000000100000000;
        @(negedge clk);
        shift_reg_val = 16'b0000010000000000;
        pulse(8,sample_the_data);
        shift_reg_val = 16'hFFFF;
        pulse(16,sample_the_data);
        eof = 1;
        pulse(2, sample_the_data);
        eof = 0;

        //Two byte data packet
        @(negedge clk);
        shift_reg_val = 16'b0000000100000000;
        @(negedge clk);
        shift_reg_val = 16'b0000010000000000;
        pulse(8,sample_the_data);
        shift_reg_val = 16'hFFFF;
        pulse(32,sample_the_data);
        eof = 1;
        pulse(2, sample_the_data);
        eof = 0;

        //Valid ACK packet
        @(negedge clk);
        shift_reg_val = 16'b0000000100000000;
        @(negedge clk);
        shift_reg_val = 16'b0000001100000000;
        pulse(8,sample_the_data);
        eof = 1;
        pulse(2, sample_the_data);
        eof = 0;

        //Invalid token packet
        @(negedge clk);
        shift_reg_val = 16'b0000000100000000;
        @(negedge clk);
        shift_reg_val = 16'b0000001000000000;
        pulse(8,sample_the_data);
        shift_reg_val = 16'b1100110000000000;
        pulse(11,sample_the_data);
        shift_reg_val = 16'b1101100000000000;
        crc5 = 5'b11111;
        pulse(5, sample_the_data);
        eof = 1;
        pulse(2, sample_the_data);
        eof = 0;

        

        $finish;
    end
endmodule

/* verilator coverage_on */

