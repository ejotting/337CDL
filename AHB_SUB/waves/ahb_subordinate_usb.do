onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ahb_subordinate_usb/CLK_PERIOD
add wave -noupdate /tb_ahb_subordinate_usb/TIMEOUT
add wave -noupdate /tb_ahb_subordinate_usb/BURST_SINGLE
add wave -noupdate /tb_ahb_subordinate_usb/BURST_INCR
add wave -noupdate /tb_ahb_subordinate_usb/BURST_WRAP4
add wave -noupdate /tb_ahb_subordinate_usb/BURST_INCR4
add wave -noupdate /tb_ahb_subordinate_usb/BURST_WRAP8
add wave -noupdate /tb_ahb_subordinate_usb/BURST_INCR8
add wave -noupdate /tb_ahb_subordinate_usb/BURST_WRAP16
add wave -noupdate /tb_ahb_subordinate_usb/BURST_INCR16
add wave -noupdate /tb_ahb_subordinate_usb/HTRANS_IDLE
add wave -noupdate /tb_ahb_subordinate_usb/HTRANS_BUSY
add wave -noupdate /tb_ahb_subordinate_usb/HTRANS_SEQ
add wave -noupdate /tb_ahb_subordinate_usb/HTRANS_NONSEQ
add wave -noupdate /tb_ahb_subordinate_usb/clk
add wave -noupdate /tb_ahb_subordinate_usb/n_rst
add wave -noupdate -divider input
add wave -noupdate /tb_ahb_subordinate_usb/RX_packet
add wave -noupdate /tb_ahb_subordinate_usb/RX_dataready
add wave -noupdate /tb_ahb_subordinate_usb/RX_transferactive
add wave -noupdate /tb_ahb_subordinate_usb/RX_error
add wave -noupdate /tb_ahb_subordinate_usb/bufferoccupancy
add wave -noupdate /tb_ahb_subordinate_usb/RX_data
add wave -noupdate /tb_ahb_subordinate_usb/TX_transferactive
add wave -noupdate /tb_ahb_subordinate_usb/TX_error
add wave -noupdate -divider {top-level input}
add wave -noupdate /tb_ahb_subordinate_usb/hsel
add wave -noupdate /tb_ahb_subordinate_usb/haddr
add wave -noupdate /tb_ahb_subordinate_usb/htrans
add wave -noupdate /tb_ahb_subordinate_usb/hsize
add wave -noupdate /tb_ahb_subordinate_usb/hwrite
add wave -noupdate /tb_ahb_subordinate_usb/hwdata
add wave -noupdate /tb_ahb_subordinate_usb/hburst
add wave -noupdate -divider burst
add wave -noupdate /tb_ahb_subordinate_usb/DUT/beat_cnt
add wave -noupdate /tb_ahb_subordinate_usb/DUT/next_beat_cnt
add wave -noupdate /tb_ahb_subordinate_usb/DUT/haddr_reg
add wave -noupdate /tb_ahb_subordinate_usb/DUT/next_haddr_reg
add wave -noupdate -divider output
add wave -noupdate /tb_ahb_subordinate_usb/DUT/raw_hazard
add wave -noupdate /tb_ahb_subordinate_usb/DUT/hazard_stall
add wave -noupdate /tb_ahb_subordinate_usb/D_mode
add wave -noupdate /tb_ahb_subordinate_usb/get_rx_data
add wave -noupdate /tb_ahb_subordinate_usb/store_tx_data
add wave -noupdate /tb_ahb_subordinate_usb/TX_data
add wave -noupdate /tb_ahb_subordinate_usb/clear
add wave -noupdate /tb_ahb_subordinate_usb/TX_packet
add wave -noupdate -divider {top-level output}
add wave -noupdate /tb_ahb_subordinate_usb/hrdata
add wave -noupdate /tb_ahb_subordinate_usb/hresp
add wave -noupdate /tb_ahb_subordinate_usb/hready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {696237 ps} 0}
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
WaveRestoreZoom {0 ps} {5250 ns}
