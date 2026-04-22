onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider RX
add wave -noupdate /tb_ahb_usb/DUT/RX/clk
add wave -noupdate /tb_ahb_usb/DUT/RX/n_rst
add wave -noupdate /tb_ahb_usb/DUT/RX/dm_in
add wave -noupdate /tb_ahb_usb/DUT/RX/dp_in
add wave -noupdate /tb_ahb_usb/DUT/RX/buffer_occupancy
add wave -noupdate /tb_ahb_usb/DUT/RX/rx_packet
add wave -noupdate /tb_ahb_usb/DUT/RX/rx_data_ready
add wave -noupdate /tb_ahb_usb/DUT/RX/rx_transfer_active
add wave -noupdate /tb_ahb_usb/DUT/RX/rx_error
add wave -noupdate /tb_ahb_usb/DUT/RX/store_rx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/RX/rx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/RX/flush
add wave -noupdate /tb_ahb_usb/DUT/RX/dm
add wave -noupdate /tb_ahb_usb/DUT/RX/dp
add wave -noupdate /tb_ahb_usb/DUT/RX/new_edge
add wave -noupdate /tb_ahb_usb/DUT/RX/eof
add wave -noupdate /tb_ahb_usb/DUT/RX/data_out
add wave -noupdate /tb_ahb_usb/DUT/RX/sample_the_data
add wave -noupdate /tb_ahb_usb/DUT/RX/valid_bit
add wave -noupdate /tb_ahb_usb/DUT/RX/start5
add wave -noupdate /tb_ahb_usb/DUT/RX/start16
add wave -noupdate /tb_ahb_usb/DUT/RX/error
add wave -noupdate /tb_ahb_usb/DUT/RX/shift_reg_val
add wave -noupdate /tb_ahb_usb/DUT/RX/crc16
add wave -noupdate /tb_ahb_usb/DUT/RX/crc5
add wave -noupdate /tb_ahb_usb/DUT/RX/CTRLOGIC/state
add wave -noupdate -divider TX
add wave -noupdate /tb_ahb_usb/DUT/TX/clk
add wave -noupdate /tb_ahb_usb/DUT/TX/n_rst
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/TX/buffer_occupancy
add wave -noupdate -radix binary /tb_ahb_usb/DUT/TX/tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/TX/tx_packet
add wave -noupdate /tb_ahb_usb/DUT/TX/myPTS/serial_out
add wave -noupdate -color Yellow /tb_ahb_usb/DUT/TX/dp_out
add wave -noupdate -color Yellow /tb_ahb_usb/DUT/TX/dm_out
add wave -noupdate /tb_ahb_usb/DUT/TX/get_tx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/TX/tx_error
add wave -noupdate /tb_ahb_usb/DUT/TX/tx_transfer_active
add wave -noupdate /tb_ahb_usb/DUT/TX/myNRZI/end_of_packet
add wave -noupdate /tb_ahb_usb/DUT/TX/bs_shift_enable
add wave -noupdate /tb_ahb_usb/DUT/TX/next_end_of_packet
add wave -noupdate /tb_ahb_usb/DUT/TX/strobe
add wave -noupdate /tb_ahb_usb/DUT/TX/data_done
add wave -noupdate /tb_ahb_usb/DUT/TX/crc_out
add wave -noupdate /tb_ahb_usb/DUT/TX/end_of_packet
add wave -noupdate /tb_ahb_usb/DUT/TX/load_enable
add wave -noupdate /tb_ahb_usb/DUT/TX/enable_crc
add wave -noupdate /tb_ahb_usb/DUT/TX/data_out
add wave -noupdate /tb_ahb_usb/DUT/TX/pts_serial_out
add wave -noupdate /tb_ahb_usb/DUT/TX/bs_serial_out
add wave -noupdate /tb_ahb_usb/DUT/TX/count
add wave -noupdate /tb_ahb_usb/DUT/TX/myFSM/state
add wave -noupdate -divider AHB
add wave -noupdate /tb_ahb_usb/DUT/ahb/clk
add wave -noupdate /tb_ahb_usb/DUT/ahb/n_rst
add wave -noupdate /tb_ahb_usb/DUT/ahb/hsel
add wave -noupdate /tb_ahb_usb/DUT/ahb/haddr
add wave -noupdate /tb_ahb_usb/DUT/ahb/htrans
add wave -noupdate /tb_ahb_usb/DUT/ahb/hsize
add wave -noupdate /tb_ahb_usb/DUT/ahb/hwrite
add wave -noupdate /tb_ahb_usb/DUT/ahb/hwdata
add wave -noupdate /tb_ahb_usb/DUT/ahb/hburst
add wave -noupdate /tb_ahb_usb/DUT/ahb/hrdata
add wave -noupdate /tb_ahb_usb/DUT/ahb/hresp
add wave -noupdate /tb_ahb_usb/DUT/ahb/hready
add wave -noupdate /tb_ahb_usb/DUT/ahb/TX_error
add wave -noupdate /tb_ahb_usb/DUT/ahb/RX_error
add wave -noupdate /tb_ahb_usb/DUT/ahb/RX_dataready
add wave -noupdate /tb_ahb_usb/DUT/ahb/RX_transferactive
add wave -noupdate /tb_ahb_usb/DUT/ahb/TX_transferactive
add wave -noupdate /tb_ahb_usb/DUT/ahb/RX_packet
add wave -noupdate /tb_ahb_usb/DUT/ahb/RX_data
add wave -noupdate /tb_ahb_usb/DUT/ahb/bufferoccupancy
add wave -noupdate /tb_ahb_usb/DUT/ahb/TX_packet
add wave -noupdate /tb_ahb_usb/DUT/ahb/TX_data
add wave -noupdate /tb_ahb_usb/DUT/ahb/clear
add wave -noupdate /tb_ahb_usb/DUT/ahb/get_rx_data
add wave -noupdate /tb_ahb_usb/DUT/ahb/store_tx_data
add wave -noupdate /tb_ahb_usb/DUT/ahb/D_mode
add wave -noupdate /tb_ahb_usb/DUT/ahb/hsel_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/haddr_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/htrans_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/hsize_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/hburst_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/hwrite_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/rx_packet_flag
add wave -noupdate /tb_ahb_usb/DUT/ahb/error_state
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_error_state
add wave -noupdate /tb_ahb_usb/DUT/ahb/error_state2
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_error_state2
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_clear
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_tx_packet
add wave -noupdate /tb_ahb_usb/DUT/ahb/tx_active_prev
add wave -noupdate /tb_ahb_usb/DUT/ahb/tx_done
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_tx_data
add wave -noupdate /tb_ahb_usb/DUT/ahb/beat_cnt
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_beat_cnt
add wave -noupdate /tb_ahb_usb/DUT/ahb/burst_base_addr
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_burst_base_addr
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_haddr_reg
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_seq_addr
add wave -noupdate /tb_ahb_usb/DUT/ahb/addr_increment
add wave -noupdate /tb_ahb_usb/DUT/ahb/wrap_window
add wave -noupdate /tb_ahb_usb/DUT/ahb/wrap_base
add wave -noupdate /tb_ahb_usb/DUT/ahb/addr_overflow
add wave -noupdate /tb_ahb_usb/DUT/ahb/prev_end_addr
add wave -noupdate /tb_ahb_usb/DUT/ahb/current_end_addr
add wave -noupdate /tb_ahb_usb/DUT/ahb/raw_hazard
add wave -noupdate /tb_ahb_usb/DUT/ahb/hazard_stall
add wave -noupdate /tb_ahb_usb/DUT/ahb/state
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_state
add wave -noupdate /tb_ahb_usb/DUT/ahb/buffer
add wave -noupdate /tb_ahb_usb/DUT/ahb/next_buffer
add wave -noupdate -divider {Data Buffer}
add wave -noupdate /tb_ahb_usb/DUT/DB/clk
add wave -noupdate /tb_ahb_usb/DUT/DB/n_rst
add wave -noupdate /tb_ahb_usb/DUT/DB/store_tx_data
add wave -noupdate /tb_ahb_usb/DUT/DB/get_tx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/DB/clear
add wave -noupdate /tb_ahb_usb/DUT/DB/flush
add wave -noupdate /tb_ahb_usb/DUT/DB/store_rx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/DB/get_rx_data
add wave -noupdate /tb_ahb_usb/DUT/DB/tx_data
add wave -noupdate /tb_ahb_usb/DUT/DB/rx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/DB/tx_packet_data
add wave -noupdate /tb_ahb_usb/DUT/DB/rx_data
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/DB/buffer_occupancy
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/DB/occupancy
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/DB/read_ptr
add wave -noupdate -radix unsigned /tb_ahb_usb/DUT/DB/write_ptr
add wave -noupdate /tb_ahb_usb/DUT/DB/queue
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1365000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {30650 ps} {12903650 ps}
