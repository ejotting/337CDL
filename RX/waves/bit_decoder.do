onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_bit_decoder/DUT/clk
add wave -noupdate /tb_bit_decoder/DUT/n_rst
add wave -noupdate /tb_bit_decoder/DUT/dm
add wave -noupdate /tb_bit_decoder/DUT/dp
add wave -noupdate -divider Outputs
add wave -noupdate -color Magenta /tb_bit_decoder/DUT/new_edge
add wave -noupdate -color Goldenrod /tb_bit_decoder/DUT/eof
add wave -noupdate -divider Intermediates
add wave -noupdate /tb_bit_decoder/DUT/past_dm
add wave -noupdate /tb_bit_decoder/DUT/past_dp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {443477 ps} 0}
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
WaveRestoreZoom {0 ps} {1008640 ps}
