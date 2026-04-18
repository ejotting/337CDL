`timescale 1ns / 10ps

module ahb_usb (
    input logic clk,
    input logic n_rst,
    input logic hsel,
    input logic [3:0]haddr,
    input logic [1:0]htrans,
    input logic [1:0]hsize,
    input logic [2:0] hburst,
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
    logic rx_data_ready, rx_transfer_active, rx_error, store_rx_packet_data, flush, clear, store_tx_data;
    logic get_tx_packet_data, get_rx_data, tx_error, tx_transfer_active;
    logic [7:0]rx_packet_data, rx_data, tx_data, tx_packet_data;
    logic [2:0]rx_packet, tx_packet;

    usb_rx RX (.clk(clk),.n_rst(n_rst),.dm_in(dm_in),.dp_in(dp_in),
    .buffer_occupancy(buffer_occupancy),.rx_packet(rx_packet),.rx_data_ready(rx_data_ready),
    .rx_transfer_active(rx_transfer_active),.rx_error(rx_error),
    .store_rx_packet_data(store_rx_packet_data),.rx_packet_data(rx_packet_data),.flush(flush));

    data_buffer DB (
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

    usb_tx TX(
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
    
    ahb_subordinate_usb #(.ADDR_WIDTH(4),.DATA_WIDTH(4))
        ahb(
            .clk(clk),
            .n_rst(n_rst),
            .hsel(hsel),
            .haddr(haddr),
            .htrans(htrans),
            .hsize(hsize),
            .hwrite(hwrite),
            .hwdata(hwdata),
            .hburst(hburst),
            .hrdata(hrdata),
            .hresp(hresp),
            .hready(hready),
            .TX_error(tx_error),
            .RX_error(rx_error),
            .RX_dataready(rx_data_ready),
            .RX_transferactive(rx_transfer_active),
            .TX_transferactive(tx_transfer_active),
            .RX_packet(rx_packet),
            .RX_data(rx_data),
            .bufferoccupancy(buffer_occupancy),
            .TX_packet(tx_packet),
            .TX_data(tx_data),
            .clear(clear),
            .get_rx_data(get_rx_data),
            .store_tx_data(store_tx_data),
            .D_mode(d_mode)
        );
endmodule

