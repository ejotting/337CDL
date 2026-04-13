`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_tx ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    //inputs
    logic [6:0] buffer_occupancy;
    logic [7:0] tx_packet_data;
    logic [2:0] tx_packet;
    //outputs
    logic dp_out, dm_out;
    logic get_tx_packet_data;
    logic tx_error;
    logic tx_transfer_active;

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
        buffer_occupancy = '0;
        tx_packet_data = '0;
        tx_packet = '0;
    end
    endtask

    //DUT
    usb_tx DUT(
        .clk(clk),
        .n_rst(n_rst),
        .buffer_occupancy(buffer_occupancy),
        .tx_packet_data(tx_packet_data),
        .tx_packet(tx_packet),
        .dp_out(dp_out),
        .dm_out(dm_out),
        .get_tx_packet_data(get_tx_packet_data),
        .tx_error(tx_error),
        .tx_transfer_active(tx_transfer_active)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;

        //todo complete this
        $display("")

        $finish;
    end
endmodule

/* verilator coverage_on */

