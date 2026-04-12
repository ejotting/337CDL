onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_counter_889/clk
add wave -noupdate /tb_counter_889/n_rst
add wave -noupdate -divider input
add wave -noupdate -radix binary /tb_counter_889/count_enable
add wave -noupdate -radix binary /tb_counter_889/clear_889
add wave -noupdate -radix binary /tb_counter_889/tx_transfer_active
add wave -noupdate -radix unsigned /tb_counter_889/count
add wave -noupdate -divider output
add wave -noupdate -radix binary /tb_counter_889/strobe
add wave -noupdate -radix binary /tb_counter_889/data_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95576 ps} 0}
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
WaveRestoreZoom {28720 ps} {143605 ps}
