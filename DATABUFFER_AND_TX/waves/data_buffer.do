onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_data_buffer/clk
add wave -noupdate /tb_data_buffer/n_rst
add wave -noupdate -divider input
add wave -noupdate -radix binary /tb_data_buffer/store_tx_data
add wave -noupdate -radix binary /tb_data_buffer/get_tx_packet_data
add wave -noupdate -radix binary /tb_data_buffer/clear
add wave -noupdate -radix binary /tb_data_buffer/flush
add wave -noupdate -radix binary /tb_data_buffer/store_rx_packet_data
add wave -noupdate -radix binary /tb_data_buffer/get_rx_data
add wave -noupdate /tb_data_buffer/tx_data
add wave -noupdate /tb_data_buffer/rx_packet_data
add wave -noupdate -divider output
add wave -noupdate /tb_data_buffer/tx_packet_data
add wave -noupdate /tb_data_buffer/rx_data
add wave -noupdate -radix unsigned /tb_data_buffer/buffer_occupancy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11293 ps} 0}
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
WaveRestoreZoom {129482 ps} {174764 ps}
