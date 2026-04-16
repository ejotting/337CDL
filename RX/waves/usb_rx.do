onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top Level RX}
add wave -noupdate /tb_usb_rx/DUT/clk
add wave -noupdate /tb_usb_rx/DUT/n_rst
add wave -noupdate /tb_usb_rx/DUT/dm_in
add wave -noupdate /tb_usb_rx/DUT/dp_in
add wave -noupdate /tb_usb_rx/DUT/buffer_occupancy
add wave -noupdate /tb_usb_rx/DUT/rx_packet
add wave -noupdate /tb_usb_rx/DUT/rx_data_ready
add wave -noupdate /tb_usb_rx/DUT/rx_transfer_active
add wave -noupdate /tb_usb_rx/DUT/rx_error
add wave -noupdate /tb_usb_rx/DUT/store_rx_packet_data
add wave -noupdate /tb_usb_rx/DUT/rx_packet_data
add wave -noupdate /tb_usb_rx/DUT/flush
add wave -noupdate /tb_usb_rx/DUT/dm
add wave -noupdate /tb_usb_rx/DUT/dp
add wave -noupdate /tb_usb_rx/DUT/new_edge
add wave -noupdate /tb_usb_rx/DUT/eof
add wave -noupdate /tb_usb_rx/DUT/data_out
add wave -noupdate /tb_usb_rx/DUT/sample_the_data
add wave -noupdate /tb_usb_rx/DUT/valid_bit
add wave -noupdate /tb_usb_rx/DUT/start5
add wave -noupdate /tb_usb_rx/DUT/start16
add wave -noupdate /tb_usb_rx/DUT/error
add wave -noupdate /tb_usb_rx/DUT/shift_reg_val
add wave -noupdate /tb_usb_rx/DUT/crc16
add wave -noupdate -radix binary -radixshowbase 0 /tb_usb_rx/DUT/crc5
add wave -noupdate -divider FSM
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/clk
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/n_rst
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/shift_reg_val
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/buffer_occupancy
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/sample_the_data
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/crc5
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/crc16
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/eof
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/valid_bit
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/error
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/flush
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/rx_data_ready
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/store_rx_packet_data
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/rx_packet
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/rx_error
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/rx_transfer_active
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/start16
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/start5
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/count_out
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/clear
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/enable
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/state
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/next_state
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/packet_type
add wave -noupdate /tb_usb_rx/DUT/CTRLOGIC/next_packet_type
add wave -noupdate -divider {Testcase Name}
add wave -noupdate /tb_usb_rx/testname
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {465000 ps} 0}
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
WaveRestoreZoom {0 ps} {4034560 ps}
