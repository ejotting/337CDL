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

    logic dm, dp, new_edge, eof, data_out, sample_the_data;

    sync SYNC (.clk(clk),.n_rst(n_rst),.async_in(dp_in),.sync_out(dp));
    sync SYNC (.clk(clk),.n_rst(n_rst),.async_in(dm_in),.sync_out(dm));

    bit_decoder BITDECODE (.clk(clk),.n_rst(n_rst),.dp(dp),.dm(dm),
    .new_edge(new_edge),.eof(eof));

    data_clk_gen DATACLK (.clk(clk),.n_rst(n_rst),.new_edge(new_edge),
    .data_out(data_out),.sample_the_data(sample_the_data));

    shift_reg SHFTREG (.clk(clk),.sample_the_data(sample_the_data),
    .valid_bit(valid_bit && !eof),.data_out(data_out),.n_rst(n_rst),
    .shift_reg_val(shift_reg_val),.rx_data(rx_data));

    rx_fsm CTRLOGIC (.clk(clk),.n_rst(n_rst),.shift_reg_val(shift_reg_val),
    .buffer_occupancy(buffer_occupancy),.sample_the_data(sample_the_data),
    .crc5(crc5),.crc16(crc16),.eof(eof),.flush(flush),.rx_data_ready(rx_data_ready),
    .store_rx_packet_data(store_rx_packet_data),.rx_packet(rx_packet),.rx_error(rx_error),
    .rx_transfer_active(rx_transfer_active),.valid_bit(valid_bit));

endmodule

