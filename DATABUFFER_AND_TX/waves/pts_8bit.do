onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_pts_8bit/clk
add wave -noupdate /tb_pts_8bit/n_rst
add wave -noupdate -divider input
add wave -noupdate -radix binary /tb_pts_8bit/parallel_in
add wave -noupdate -radix binary /tb_pts_8bit/shift_enable
add wave -noupdate -radix binary /tb_pts_8bit/load_enable
add wave -noupdate -divider output
add wave -noupdate -radix binary /tb_pts_8bit/serial_out
add wave -noupdate -radix binary /tb_pts_8bit/DUT/mySR/parallel_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32135 ps} 0}
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
WaveRestoreZoom {999 ps} {37734 ps}
