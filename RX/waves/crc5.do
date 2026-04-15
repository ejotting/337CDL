onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_crc5/DUT/clk
add wave -noupdate /tb_crc5/DUT/n_rst
add wave -noupdate /tb_crc5/DUT/start5
add wave -noupdate /tb_crc5/DUT/sample_the_data
add wave -noupdate /tb_crc5/DUT/crc5_in
add wave -noupdate /tb_crc5/DUT/rx_transfer_active
add wave -noupdate -radix binary -radixshowbase 0 /tb_crc5/DUT/crc5_out
add wave -noupdate /tb_crc5/DUT/next_bit_ready
add wave -noupdate /tb_crc5/DUT/bit_ready
add wave -noupdate /tb_crc5/DUT/po
add wave -noupdate /tb_crc5/DUT/polynomial
add wave -noupdate /tb_crc5/DUT/int1
add wave -noupdate /tb_crc5/DUT/int2
add wave -noupdate /tb_crc5/DUT/fb
add wave -noupdate /tb_crc5/DUT/shift
add wave -noupdate /tb_crc5/DUT/next_shift
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {379029 ps} 0}
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
WaveRestoreZoom {0 ps} {504320 ps}
