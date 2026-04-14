onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_data_clk_gen/DUT/clk
add wave -noupdate /tb_data_clk_gen/DUT/n_rst
add wave -noupdate /tb_data_clk_gen/DUT/new_edge
add wave -noupdate -divider Outputs
add wave -noupdate -color Magenta /tb_data_clk_gen/DUT/data_out
add wave -noupdate -color Goldenrod /tb_data_clk_gen/DUT/sample_the_data
add wave -noupdate -divider Intermediates
add wave -noupdate /tb_data_clk_gen/DUT/ndata_out
add wave -noupdate /tb_data_clk_gen/DUT/nsample_the_data
add wave -noupdate /tb_data_clk_gen/DUT/start_count1
add wave -noupdate /tb_data_clk_gen/DUT/start_count2
add wave -noupdate /tb_data_clk_gen/DUT/count_out1
add wave -noupdate /tb_data_clk_gen/DUT/count_out2
add wave -noupdate /tb_data_clk_gen/DUT/rollover1
add wave -noupdate /tb_data_clk_gen/DUT/rollover2
add wave -noupdate /tb_data_clk_gen/DUT/stay_one
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {880645 ps} 0}
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
