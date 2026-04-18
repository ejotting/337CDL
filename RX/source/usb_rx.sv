`timescale 1ns / 10ps

module usb_rx #(
    // parameters
) (
    input logic clk,
    input logic n_rst,
    input logic dm_in,
    input logic dp_in,
    input logic [6:0]buffer_occupancy,

    output logic [2:0]rx_packet, //Done
    output logic rx_data_ready, //Done
    output logic rx_transfer_active, //Done
    output logic rx_error, //Done
    output logic store_rx_packet_data, //Done
    output logic [7:0]rx_packet_data, //Done
    output logic flush //Done
);

    logic dm, dp, new_edge, eof, data_out, sample_the_data, valid_bit, start5, start16,error;
    logic [15:0]shift_reg_val, crc16;
    logic [4:0]crc5;

    sync SYNC1 (.clk(clk),.n_rst(n_rst),.async_in(dp_in),.sync_out(dp));
    sync SYNC2 (.clk(clk),.n_rst(n_rst),.async_in(dm_in),.sync_out(dm));

    bit_decoder BITDECODE (.clk(clk),.n_rst(n_rst),.dp(dp),.dm(dm),
    .new_edge(new_edge),.eof(eof));

    data_clk_gen DATACLK (.clk(clk),.n_rst(n_rst),.new_edge(new_edge),
    .data_out(data_out),.sample_the_data(sample_the_data));

    shift_reg SHFTREG (.clk(clk),.sample_the_data(sample_the_data),
    .valid_bit(valid_bit && !eof),.data_out(data_out),.n_rst(n_rst),
    .shift_reg_val(shift_reg_val),.rx_data(rx_packet_data));

    rx_fsm CTRLOGIC (.clk(clk),.n_rst(n_rst),.shift_reg_val(shift_reg_val),
    .buffer_occupancy(buffer_occupancy),.sample_the_data(sample_the_data),.error(error),
    .crc5(crc5),.crc16(crc16),.eof(eof),.flush(flush),.rx_data_ready(rx_data_ready),
    .store_rx_packet_data(store_rx_packet_data),.rx_packet(rx_packet),.rx_error(rx_error),
    .rx_transfer_active(rx_transfer_active),.valid_bit(valid_bit),.start5(start5),.start16(start16));

    crc5 CRC5 (.clk(clk),.n_rst(n_rst),.start5(start5),.crc5_out(crc5),
    .crc5_in(data_out),.sample_the_data(sample_the_data),.rx_transfer_active(rx_transfer_active));

    crc16 CRC16 (.clk(clk),.n_rst(n_rst),.start16(start16),.crc16_out(crc16),
    .crc16_in(rx_packet_data[7]),.sample_the_data(sample_the_data),.rx_transfer_active(rx_transfer_active));

    bit_stuff_checker BSC (.clk(clk),.n_rst(n_rst),.data_in(data_out),
    .sample_the_data(sample_the_data),.valid_bit(valid_bit),.error(error),
    .eof(eof),.rx_transfer_active(rx_transfer_active));



endmodule

