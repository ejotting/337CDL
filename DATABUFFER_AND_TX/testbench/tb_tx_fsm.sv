`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_tx_fsm ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    //DUT inputs 
    logic [2:0] tx_packet;
    logic [6:0] buffer_occupancy;
    logic strobe, data_done;
    logic [15:0] crc_out;
    logic [7:0] tx_packet_data;
    //outputs
    logic get_tx_packet_data, tx_transfer_active, tx_error;
    logic end_of_packet, load_enable, enable_crc;
    logic [7:0] data_out;

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
        clk = 0;
        n_rst = 0;
        tx_packet = 3'd0;
        buffer_occupancy = 0;
        strobe = 0;
        data_done = 0;
        crc_out = '0;
        tx_packet_data = '0;
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
    end
    endtask

    task data_strobe;
    begin
        strobe = 1;
        @(negedge clk);
        strobe = 0;
        repeat(2) @(negedge clk);
    end
    endtask

    task data_done_strobe; //used when you send a data and you need data_done to move on to next state
    begin
        repeat(8) begin
            data_strobe; //replicates rest of 7 bits being sent (1st bit was sent when you loaded into pts prior)
        end 
        strobe = 1;
        data_done = 1;
        @(negedge clk);
        strobe = 0;
        data_done = 0;
        repeat(2) @(negedge clk);
    end
    endtask

    //DUT
    tx_fsm DUT(
        .clk(clk),
        .n_rst(n_rst),
        .tx_packet(tx_packet),
        .buffer_occupancy(buffer_occupancy),
        .strobe(strobe),
        .data_done(data_done),
        .crc_out(crc_out),
        .tx_packet_data(tx_packet_data),
        .get_tx_packet_data(get_tx_packet_data),
        .tx_transfer_active(tx_transfer_active),
        .tx_error(tx_error),
        .end_of_packet(end_of_packet),
        .load_enable(load_enable),
        .enable_crc(enable_crc),
        .data_out(data_out)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;

        $display("ERROR path");
        //IDLE
        tx_packet = 3'd1;
        buffer_occupancy = 0;
        data_strobe;
        //ERROR
        data_strobe;

        $display("ACK packet");
        //IDLE
        tx_packet = 3'd3;
        data_strobe;
        //LOAD_SYNC (at this point, one bit from data_out is getting ready to be sent out serially by pts, this is more top-level though)
        data_strobe;
        //SYNC
        data_done_strobe;
        //LOAD_PID
        data_strobe;
        //PID (data_out = 8'b11010010)
        tx_packet = 3'd3;
        data_done_strobe;
        //LOAD_EOP
        data_strobe;
        //EOP
        data_done_strobe;
        //IDLE

        $display("DATA0");
        //IDLE
        tx_packet = 3'd1;
        data_strobe;
        //LOAD_SYNC
        data_strobe;
        //SYNC
        data_strobe;
        //LOAD_PID
        data_strobe;
        //PID
        data_strobe;
        //GET_DATA
        data_strobe;
        //LOAD_DATA
        data_strobe;
        //SEND_DATA
        data_strobe;
        //LOAD_EOP
        data_strobe;
        //EOP
        data_strobe;

        repeat (20) data_strobe;

        $finish;
    end
endmodule

/* verilator coverage_on */

