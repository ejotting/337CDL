`timescale 1ns / 10ps

module usb_tx(
    input logic clk, n_rst,
    input logic [6:0] buffer_occupancy,
    input logic [7:0] tx_packet_data,
    input logic [2:0] tx_packet,
    output logic dp_out, dm_out, get_tx_packet_data, tx_error, tx_transfer_active
);
    //fsm inputs
    logic data_done;
    logic [15:0] crc_out;
    //fsm outputs
    logic end_of_packet, load_enable;
    logic [7:0] data_out;

    fsm myFSM(
    .tx_packet          (tx_packet), //
    .buffer_occupancy   (buffer_occupancy), //
    .data_done          (data_done), 
    .crc_out            (crc_out), 
    .tx_packet_data     (tx_packet_data), //
    .get_tx_packet_data (get_tx_packet_data), //
    .tx_transfer_active (tx_transfer_active), //
    .tx_error           (tx_error), //
    .end_of_packet      (end_of_packet),
    .load_enable        (load_enable),
    .data_out           (data_out)

    //TODO continue to implement top level.

);
endmodule