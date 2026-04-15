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

    task set_inputs(
        logic [6:0] bo, //buffer occupancy
        logic [7:0] tpd, //tx packet data
        logic [2:0] tp //tx packet (type)
    );
    begin
        buffer_occupancy = bo;
        tx_packet_data = tpd;
        tx_packet = tp;
    end
    endtask

    task one_data_clk;
    begin
        repeat(8) @(negedge clk);
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
        @(negedge clk);

        $display("Transmit DATA1");
        set_inputs(7'd1, 8'b01100010, 3'd2);
        repeat(260) @(negedge clk);
        set_inputs(7'd0, 8'b10100111, 3'd2);
        repeat(180) @(negedge clk);
        
        $display("Transmit DATA0");
        set_inputs(7'd2, 8'b10101010, 3'd1);
        repeat(260) @(negedge clk);
        set_inputs(7'd1, 8'b10001010, 3'd1);
        repeat(260) @(negedge clk);
        set_inputs(7'd0, 8'b10001010, 3'd1);
        repeat(140) @(negedge clk);
        set_inputs(7'd0, 8'b10001010, 3'd0);
        repeat(40) @(negedge clk);


        $display("Transmit ACK");
        set_inputs(7'd8, 8'b10101010, 3'd3);
        repeat(200) @(negedge clk);

        $display("Transmit NAK");
        set_inputs(7'd0, 8'b10101010, 3'd4);
        repeat(200) @(negedge clk);

        $display("Transmit STALL");
        set_inputs(7'd1, 8'b10101010, 3'd5);
        repeat(200) @(negedge clk);
        set_inputs(7'd0, 8'b10001010, 3'd0);
        repeat(64) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

