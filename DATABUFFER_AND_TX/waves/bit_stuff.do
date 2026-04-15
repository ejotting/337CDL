onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_bit_stuff/clk
add wave -noupdate /tb_bit_stuff/n_rst
add wave -noupdate -divider input
add wave -noupdate -radix binary /tb_bit_stuff/strobe
add wave -noupdate -radix binary /tb_bit_stuff/serial_in
add wave -noupdate -divider output
add wave -noupdate -radix binary /tb_bit_stuff/serial_out
add wave -noupdate -radix binary /tb_bit_stuff/shift_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95167 ps} 0}
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
WaveRestoreZoom {0 ps} {115500 ps}
