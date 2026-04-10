`timescale 1ns / 10ps

module data_buffer(
    input logic clk, n_rst, store_tx_data, get_tx_packet_data, clear, store_rx_packet_data, get_rx_data,
    input logic [7:0] tx_data, rx_packet_data,
    output logic [7:0] tx_packet_data, rx_data,
    output logic [6:0] buffer_occupancy
);
    logic [6:0] tx_occupancy, next_tx_occupancy, rx_occupany, next_rx_occupancy;
    logic [511:0] tx, rx, next_tx, next_rx;

    
    //tx comb
    always_comb begin
        next_tx = tx;
        next_tx_occupancy = tx_occupancy;

        if (clear) begin
            next_tx = '0;
            next_tx_occupancy = '0;
        end
        
        //if legal pop
        if (!(tx_occupancy == '0 && get_tx_packet_data)) begin
            next_tx_occupancy = tx_occupancy - 1;
        end

        //if legal push
        if (!(tx_occupancy == 7'd64 && store_tx_data)) begin
            next_tx = {tx[503:0], tx_data};
            next_tx_occupancy = tx_occupancy + 1;
        end
    end

    //rx comb
    always_comb begin
        next_rx = rx;
        next_rx_occupancy = rx_occupancy;

        if (clear) begin
            next_rx = '0;
            next_rx_occupancy = '0;
        end
        
        //if legal pop
        if (!(rx_occupancy == '0 && get_rx_data)) begin
            next_rx_occupancy = rx_occupancy - 1;
        end

        //if legal push
        if (!(rx_occupancy == 7'd64 && store_rx_packet_data)) begin
            next_rx = {rx[503:0], rx_packet_data};
            next_rx_occupancy = rx_occupancy + 1;
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if(!n_rst) begin
            tx <= '0;
            rx <= '0;
            tx_occupancy <= '0;
            rx_occupancy <= '0;
        end
        else begin
            tx <= next_tx;
            rx <= next_rx;
            tx_occupancy <= next_tx_occupancy;
            rx_occupancy <= next_rx_occupancy;
        end
    end

    always_comb begin
        tx_packet_data = '0;

        //legal pop
        if (!(tx_occupancy == 0 && get_tx_packet_data)) begin
            tx_packet_data = tx[tx_occupancy*8 +: 8];
        end

        //legal push
        if (!(tx_occupancy == 64 && store_tx_data)) begin
            tx_packet_data = tx[7:0];
        end
    end

    always_comb begin
        rx_data = '0;

        //legal pop
        if (!(rx_occupancy == 0 && get_rx_data)) begin
            rx_data = rx[rx_occupancy*8 +: 8];
        end

        //legal push
        if (!(rx_occupancy == 64 && store_rx_packet_data)) begin
            rx_data = rx[7:0];
        end
    end

    assign buffer_occupancy = tx_occupancy + rx_occupancy;
endmodule