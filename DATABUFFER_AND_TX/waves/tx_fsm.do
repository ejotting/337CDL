onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_tx_fsm/clk
add wave -noupdate /tb_tx_fsm/n_rst
add wave -noupdate -divider input
add wave -noupdate -color Yellow -radix binary /tb_tx_fsm/strobe
add wave -noupdate -color Gold -radix binary /tb_tx_fsm/data_done
add wave -noupdate -radix unsigned /tb_tx_fsm/tx_packet
add wave -noupdate -radix unsigned /tb_tx_fsm/buffer_occupancy
add wave -noupdate -radix hexadecimal /tb_tx_fsm/crc_out
add wave -noupdate -radix binary /tb_tx_fsm/tx_packet_data
add wave -noupdate -divider output
add wave -noupdate -radix binary /tb_tx_fsm/get_tx_packet_data
add wave -noupdate -radix binary /tb_tx_fsm/tx_transfer_active
add wave -noupdate -radix binary /tb_tx_fsm/tx_error
add wave -noupdate -radix binary /tb_tx_fsm/end_of_packet
add wave -noupdate -radix binary /tb_tx_fsm/load_enable
add wave -noupdate -radix binary /tb_tx_fsm/enable_crc
add wave -noupdate -radix binary /tb_tx_fsm/data_out
add wave -noupdate /tb_tx_fsm/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {182890 ps} 0}
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
WaveRestoreZoom {0 ps} {83984 ps}
