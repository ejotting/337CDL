onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_rx_fsm/DUT/clk
add wave -noupdate /tb_rx_fsm/DUT/n_rst
add wave -noupdate /tb_rx_fsm/DUT/shift_reg_val
add wave -noupdate /tb_rx_fsm/DUT/buffer_occupancy
add wave -noupdate /tb_rx_fsm/DUT/sample_the_data
add wave -noupdate /tb_rx_fsm/DUT/crc5
add wave -noupdate /tb_rx_fsm/DUT/crc16
add wave -noupdate /tb_rx_fsm/DUT/eof
add wave -noupdate /tb_rx_fsm/DUT/valid_bit
add wave -noupdate -divider Outputs
add wave -noupdate /tb_rx_fsm/DUT/flush
add wave -noupdate /tb_rx_fsm/DUT/rx_data_ready
add wave -noupdate -color Magenta /tb_rx_fsm/DUT/store_rx_packet_data
add wave -noupdate /tb_rx_fsm/DUT/rx_packet
add wave -noupdate /tb_rx_fsm/DUT/rx_error
add wave -noupdate /tb_rx_fsm/DUT/rx_transfer_active
add wave -noupdate /tb_rx_fsm/DUT/start16
add wave -noupdate /tb_rx_fsm/DUT/start5
add wave -noupdate -divider Intermediates
add wave -noupdate /tb_rx_fsm/DUT/count_out
add wave -noupdate /tb_rx_fsm/DUT/clear
add wave -noupdate /tb_rx_fsm/DUT/state
add wave -noupdate /tb_rx_fsm/DUT/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1680432 ps} 0}
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
WaveRestoreZoom {671792 ps} {1680432 ps}
