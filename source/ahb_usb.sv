`timescale 1ns / 10ps

module ahb_usb (
    input logic clk,
    input logic n_rst,
    input logic hsel,
    input logic [3:0]haddr,
    input logic [1:0]htrans,
    input logic [1:0]hsize,
    input logic hwrite,
    input logic [31:0]hwdata,
    
    output logic [31:0]hrdata,
    output logic hready,
    output logic hresp,

    input logic dp_in,
    input logic dm_in,
    
    output logic dp_out,
    output logic dm_out,
    output logic d_mode
);

    logic [6:0]buffer_occupancy;
    logic rx_data_ready, rx_transfer_active, rx_error, store_rx_packet_data, flush;
    logic [7:0]rx_packet_data;
    logic [2:0]rx_packet;

    usb_rx RX (.clk(clk),.n_rst(n_rst),.dm_in(dm_in),.dp_in(dp_in),
    .buffer_occupancy(buffer_occupancy),.rx_packet(rx_packet),.rx_data_ready(rx_data_ready),
    .rx_transfer_active(rx_transfer_active),.rx_error(rx_error),
    .store_rx_packet_data(store_rx_packet_data),.rx_packet_data(rx_packet_data),.flush(flush));

endmodule

