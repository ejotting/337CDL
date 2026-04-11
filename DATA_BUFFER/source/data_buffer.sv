`timescale 1ns / 10ps

module data_buffer(
    input logic clk, n_rst, store_tx_data, get_tx_packet_data, clear, flush, store_rx_packet_data, get_rx_data,
    input logic [7:0] tx_data, rx_packet_data,
    output logic [7:0] tx_packet_data, rx_data,
    output logic [6:0] buffer_occupancy
);

    logic [511:0] queue, next_queue;
    logic [6:0] occupancy, next_occupancy;
    logic [8:0] read_ptr, next_read_ptr;
    logic [8:0] write_ptr, next_write_ptr;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            queue <= '0;
            occupancy <= 7'd0;
            read_ptr <= 9'd7;
            write_ptr <= 9'd7;
        end
        else begin
            queue <= next_queue;
            occupancy <= next_occupancy;
            read_ptr <= next_read_ptr;
            write_ptr <= next_write_ptr;
        end
    end

    always_comb begin
        next_queue = queue;
        next_occupancy = occupancy;
        next_read_ptr = read_ptr;
        next_write_ptr = write_ptr;

        tx_packet_data = 8'b0;
        rx_data = 8'b0;
        buffer_occupancy = occupancy;

        if (occupancy > 0) begin //if queue is not empty
            tx_packet_data = queue[read_ptr -: 8];
            rx_data = queue[read_ptr -: 8];
        end

        if (clear || flush) begin
            next_queue = '0;
            next_occupancy = 7'd0;
            next_read_ptr = 9'd7;
            next_write_ptr = 9'd7;
        end
        else begin
            //legal write
            if (store_tx_data && (occupancy < 7'd64)) begin
                next_queue[write_ptr -: 8] = tx_data;
                next_occupancy = occupancy + 1'b1;
                next_write_ptr = write_ptr + 9'd8; //shift write index
            end
            else if (store_rx_packet_data && (occupancy < 7'd64)) begin
                next_queue[write_ptr -: 8] = rx_packet_data;
                next_occupancy = occupancy + 1'b1;
                next_write_ptr = write_ptr + 9'd8;
            end

            //legal read
            if (get_tx_packet_data && (occupancy > 0)) begin
                next_occupancy = occupancy - 1'b1;
                next_read_ptr = read_ptr + 9'd8; //shift read index
            end
            else if (get_rx_data && (occupancy > 0)) begin
                next_occupancy = occupancy - 1'b1;
                next_read_ptr = read_ptr + 9'd8;
            end
        end
    end

endmodule