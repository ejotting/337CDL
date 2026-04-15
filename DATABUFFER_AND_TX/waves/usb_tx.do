onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_usb_tx/clk
add wave -noupdate /tb_usb_tx/n_rst
add wave -noupdate -divider {data clk}
add wave -noupdate -color Yellow -radix binary /tb_usb_tx/DUT/myCounter/strobe
add wave -noupdate -color Khaki -radix unsigned -childformat {{{/tb_usb_tx/DUT/myCounter/count[4]} -radix unsigned} {{/tb_usb_tx/DUT/myCounter/count[3]} -radix unsigned} {{/tb_usb_tx/DUT/myCounter/count[2]} -radix unsigned} {{/tb_usb_tx/DUT/myCounter/count[1]} -radix unsigned} {{/tb_usb_tx/DUT/myCounter/count[0]} -radix unsigned}} -subitemconfig {{/tb_usb_tx/DUT/myCounter/count[4]} {-color Khaki -height 16 -radix unsigned} {/tb_usb_tx/DUT/myCounter/count[3]} {-color Khaki -height 16 -radix unsigned} {/tb_usb_tx/DUT/myCounter/count[2]} {-color Khaki -height 16 -radix unsigned} {/tb_usb_tx/DUT/myCounter/count[1]} {-color Khaki -height 16 -radix unsigned} {/tb_usb_tx/DUT/myCounter/count[0]} {-color Khaki -height 16 -radix unsigned}} /tb_usb_tx/DUT/myCounter/count
add wave -noupdate -color Gold -radix binary /tb_usb_tx/DUT/myCounter/data_done
add wave -noupdate -color Khaki -radix unsigned /tb_usb_tx/DUT/myCounter/dataDoneCounter/count
add wave -noupdate -divider input
add wave -noupdate -color {Blue Violet} -radix unsigned /tb_usb_tx/buffer_occupancy
add wave -noupdate -color {Medium Orchid} -radix binary /tb_usb_tx/tx_packet_data
add wave -noupdate -color {Dark Orchid} -radix unsigned /tb_usb_tx/tx_packet
add wave -noupdate -divider output
add wave -noupdate -color Pink -radix binary /tb_usb_tx/tx_error
add wave -noupdate -color Pink -radix binary /tb_usb_tx/DUT/myNRZI/end_of_packet
add wave -noupdate -color Thistle -radix binary /tb_usb_tx/get_tx_packet_data
add wave -noupdate -color Thistle -label tx_transfer_active -radix binary /tb_usb_tx/tx_transfer_active
add wave -noupdate -color Magenta /tb_usb_tx/DUT/myFSM/state
add wave -noupdate -label {load_enable (up when LOAD)} -radix binary /tb_usb_tx/DUT/myPTS/load_enable
add wave -noupdate -radix binary /tb_usb_tx/DUT/myFSM/data_out
add wave -noupdate -color {Medium Sea Green} -label {parallel_out (pts shifting)} -radix binary /tb_usb_tx/DUT/myPTS/mySR/parallel_out
add wave -noupdate -color {Sea Green} -radix unsigned /tb_usb_tx/DUT/myPTS/serial_out
add wave -noupdate -divider {nrzi output bits}
add wave -noupdate -color {Sky Blue} -radix binary /tb_usb_tx/dp_out
add wave -noupdate -color {Sky Blue} -radix binary /tb_usb_tx/dm_out
add wave -noupdate -divider crc
add wave -noupdate -color Aquamarine -radix binary /tb_usb_tx/DUT/myCRC/enable_crc
add wave -noupdate -color Aquamarine -radix binary /tb_usb_tx/DUT/myCRC/data_in
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_usb_tx/DUT/myCRC/shifted
add wave -noupdate -color Aquamarine /tb_usb_tx/DUT/myCRC/crc
add wave -noupdate -color Cyan /tb_usb_tx/DUT/myCRC/crc_out
add wave -noupdate -divider {bit stuffing}
add wave -noupdate -color Wheat -radix unsigned /tb_usb_tx/DUT/myBS/one_count
add wave -noupdate -color Tan -radix binary /tb_usb_tx/DUT/myBS/serial_in
add wave -noupdate -color Goldenrod -radix binary /tb_usb_tx/DUT/myBS/serial_out
add wave -noupdate -color Coral -radix binary /tb_usb_tx/DUT/myBS/shift_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {156552 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
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
WaveRestoreZoom {0 ps} {4746 ns}
