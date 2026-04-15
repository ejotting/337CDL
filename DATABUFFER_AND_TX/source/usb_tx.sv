`timescale 1ns / 10ps

module usb_tx(
    input logic clk, n_rst,
    input logic [6:0] buffer_occupancy,
    input logic [7:0] tx_packet_data,
    input logic [2:0] tx_packet,
    output logic dp_out, dm_out, get_tx_packet_data, tx_error, tx_transfer_active
);
    logic bs_shift_enable; //bit stuffing
    logic next_end_of_packet;

    //fsm inputs
    logic strobe, data_done;
    logic [15:0] crc_out;
    //fsm outputs
    logic end_of_packet, load_enable, enable_crc;
    logic [7:0] data_out;
    tx_fsm myFSM(
        .clk(clk),
        .n_rst(n_rst),
        .tx_packet(tx_packet), //
        .buffer_occupancy(buffer_occupancy), //
        .strobe(strobe),
        .data_done(data_done), 
        .crc_out(crc_out), 
        .tx_packet_data(tx_packet_data), //
        .shift_enable(bs_shift_enable), 
        .get_tx_packet_data(get_tx_packet_data), //
        .tx_transfer_active(tx_transfer_active), //
        .tx_error(tx_error), //
        .end_of_packet(next_end_of_packet),
        .load_enable(load_enable),
        .enable_crc(enable_crc),
        .data_out(data_out)
    );

    //serial data that is taken bit-by-bit from the parallel data_out
    //logic serial_data;
    logic pts_serial_out;
    crc_generate myCRC(
        .clk(clk),
        .n_rst(n_rst),
        .data_in(pts_serial_out),
        .enable_crc(enable_crc && bs_shift_enable),  //todobit stuffing enable
        .strobe(strobe),
        .crc_out(crc_out)
    );


    pts_8bit myPTS(
        .clk(clk),
        .n_rst(n_rst),
        .shift_enable(strobe && bs_shift_enable),  //todobit stuffing enable
        .load_enable(load_enable), 
        .parallel_in(data_out),
        .serial_out(pts_serial_out)
    );

    logic bs_serial_out;
    bit_stuff myBS(
        .clk(clk),
        .n_rst(n_rst),
        .strobe(strobe),
        .serial_in(pts_serial_out),
        .serial_out(bs_serial_out),
        .shift_enable(bs_shift_enable)
    );
   
    always_ff @(posedge clk or negedge n_rst) begin
        if(!n_rst) 
            end_of_packet <= 0;
        else if(strobe)
            end_of_packet <= next_end_of_packet;
    end

    nrzi_encoder myNRZI(
        .clk(clk),
        .n_rst(n_rst),
        .serial_in(bs_serial_out),
        .end_of_packet(end_of_packet),
        .strobe(strobe),
        .dp_out(dp_out),
        .dm_out(dm_out)
    );

    //counter output count
    logic [4:0]count;
    counter_889 myCounter(
        .clk(clk),
        .n_rst(n_rst),
        .count_enable(1'b1),
        .clear_889(1'b0), 
        .tx_transfer_active(tx_transfer_active), 
        .bs_shift_enable(bs_shift_enable),
        .count(count),
        .strobe(strobe),
        .data_done(data_done)
    );

    
endmodule