`timescale 1ns / 10ps

module usb_tx(
    input logic clk, n_rst,
    input logic [6:0] buffer_occupancy,
    input logic [7:0] tx_packet_data,
    input logic [2:0] tx_packet,
    output logic dp_out, dm_out, get_tx_packet_data, tx_error, tx_transfer_active
);
    //fsm inputs
    logic strobe, data_done;
    logic [15:0] crc_out;
    //fsm outputs
    logic end_of_packet, load_enable, enable_crc;
    logic [7:0] data_out;

    fsm myFSM(
        .tx_packet(tx_packet), //
        .buffer_occupancy(buffer_occupancy), //
        .strobe(strobe),
        .data_done(data_done), 
        .crc_out(crc_out), 
        .tx_packet_data(tx_packet_data), //
        .get_tx_packet_data(get_tx_packet_data), //
        .tx_transfer_active(tx_transfer_active), //
        .tx_error(tx_error), //
        .end_of_packet(end_of_packet),
        .load_enable(load_enable),
        .enable_crc(enable_crc),
        .data_out(data_out)
    );

    //TODO continue to implement top level.

    //serial data that is taken bit-by-bit from the parallel data_out
    logic serial_data;

    crc_generate myCRC(
        .data_in(serial_data),
        .enable_crc(enable_crc),
        .strobe(strobe),
        .crc_out(crc_out)
    );

    pts_8bit myPTS(
        .shift_enable(strobe),
        .load_enable(load_enable),
        .parallel_in(data_out),
        .serial_out(serial_data)
    );

    nrzi_encoder myNRZI(
        .serial_in(serial_data),
        .end_of_packet(end_of_packet),
        .strobe(strobe),
        .dp_out(dp_out),
        .dm_out(dm_out)
    );

    //counter output count
    logic [4:0] count;

    counter_889 myCounter(
        .count_enable(tx_transfer_active), //todo check this again.
        .clear_889(~tx_transfer_active), //todo
        .tx_transfer_active(tx_transfer_active),
        .count(count),
        .strobe(strobe),
        .data_done(data_done)
    );



endmodule