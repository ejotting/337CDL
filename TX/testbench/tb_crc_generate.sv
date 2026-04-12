`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_crc_generator();
    //TODO MUST REWRITE
    localparam CLK_PERIOD = 10ns;

    //TODO LOGIC WIRES
    logic clk, n_rst;
    logic shift_strobe, serial_in;
    logic [7:0] packet_data; 
    logic stop_bit;

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
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    task initialize();
    begin
        n_rst = 1;
        shift_strobe = 0;
        serial_in = 0;
        @(posedge clk);
        @(negedge clk);
    end
    endtask

    task check_out(
        logic [7:0]expected_packet_data, expected_stop_bit
    );
    begin
        //TODO
        if(expected_packet_data != packet_data)
            $display("Error: packet_data is %b instead of %b", packet_data, expected_packet_data);
        if(expected_stop_bit != stop_bit)
            $display("Error: stop_bit %b instead of %b", stop_bit, expected_stop_bit);
    end
    endtask

    //TODO DUT INSTANTIATION
    
    initial begin
        n_rst = 1;
        reset_dut();
        initialize();

        //TODO
        $finish;
    end
endmodule

/* verilator coverage_on */

