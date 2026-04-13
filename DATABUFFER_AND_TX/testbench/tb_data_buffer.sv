`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_data_buffer ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end


    logic clk, n_rst;

    //DUT input
    logic store_tx_data;
    logic get_tx_packet_data;
    logic clear;
    logic flush;
    logic store_rx_packet_data;
    logic get_rx_data;
    logic [7:0] tx_data;
    logic [7:0] rx_packet_data;
    //DUT output
    logic [7:0] tx_packet_data;
    logic [7:0] rx_data;
    logic [6:0] buffer_occupancy;

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
        store_tx_data = 1'b0;
        get_tx_packet_data = 1'b0;
        store_rx_packet_data = 1'b0;
        get_rx_data = 1'b0;
        tx_data = '0;
        rx_packet_data = '0;
        clear = 1'b0;
        flush = 1'b0;        
    end
    endtask

    //DUT
    data_buffer DUT (
        .clk(clk),
        .n_rst(n_rst),
        .store_tx_data(store_tx_data),
        .get_tx_packet_data(get_tx_packet_data),
        .clear(clear),
        .flush(flush),
        .store_rx_packet_data(store_rx_packet_data),
        .get_rx_data(get_rx_data),
        .tx_data(tx_data),
        .rx_packet_data(rx_packet_data),
        .tx_packet_data(tx_packet_data),
        .rx_data(rx_data),
        .buffer_occupancy(buffer_occupancy)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;

        //todo work on this
        

        $finish;
    end
endmodule

/* verilator coverage_on */

