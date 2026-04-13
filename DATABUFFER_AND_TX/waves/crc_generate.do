onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_crc_generate/clk
add wave -noupdate /tb_crc_generate/n_rst
add wave -noupdate -divider input
add wave -noupdate -radix binary /tb_crc_generate/data_in
add wave -noupdate -radix binary /tb_crc_generate/enable_crc
add wave -noupdate -radix binary /tb_crc_generate/strobe
add wave -noupdate -divider output
add wave -noupdate -radix hexadecimal /tb_crc_generate/crc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66571 ps} 0}
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
WaveRestoreZoom {0 ps} {97125 ps}
