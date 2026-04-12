`timescale 1ns / 10ps

module fsm(
    input logic [2:0] tx_packet,
    input logic [6:0] buffer_occupancy,
    input logic data_done,
    input logic [15:0] crc_out,
    input logic [7:0] tx_packet_data,
    output logic get_tx_packet_data, tx_transfer_active, tx_error, end_of_packet, load_enable,
    output logic [7:0] data_out
);
    //TODO
    typedef enum logic [4:0] {
        IDLE, LOAD_SYNC, SYNC, LOAD_PID, PID, GET_DATA, LOAD_DATA, SEND_DATA,
        LOAD_CRC1, CRC1, LOAD_CRC2, CRC2, LOAD_EOP, EOP, ERROR
    }state_t;

    state_t state, next_state;
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    //next state logic block
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (((tx_packet == 3'd1 || tx_packet == 3'd2) && buffer_occupancy > 0)||(tx_packet == 3'd3 || tx_packet == 3'd4 || tx_packet == 3'd5))
                    next_state = LOAD_SYNC;
                else if ((tx_packet == 3'd1 || tx_packet == 3'd2) && buffer_occupancy == 0)
                    next_state = ERROR;
            end
            LOAD_SYNC: begin
                next_state = SYNC;
            end
            SYNC: begin
                if (data_done)
                    next_state = LOAD_PID;
            end
            LOAD_PID: begin
                next_state = PID;
            end
            PID: begin
                if (data_done && (tx_packet == 3'd1 || tx_packet == 3'd2))
                    next_state = GET_DATA;
                else if (data_done && (tx_packet == 3'd3 || tx_packet == 3'd4 || tx_packet == 3'd5))
                    next_state = LOAD_EOP;
            end
            GET_DATA: begin
                next_state = LOAD_DATA;
            end
            LOAD_DATA: begin
                next_state = SEND_DATA;
            end
            SEND_DATA: begin
                if (data_done)
                    next_state = LOAD_CRC1;
            end
            LOAD_CRC1: begin
                next_state = CRC1;
            end
            CRC1: begin
                if (data_done)
                    next_state = LOAD_CRC2;
            end
            LOAD_CRC2: begin
                next_state = CRC2;
            end
            CRC2: begin
                if (data_done && buffer_occupancy > 0)
                    next_state = GET_DATA;
                else if (data_done && buffer_occupancy == 0)
                    next_state = LOAD_EOP;
            end
            LOAD_EOP: begin
                next_state = EOP;
            end
            EOP: begin
                if (data_done)
                    next_state = IDLE;
            end
            ERROR: begin
                next_state = IDLE;
            end
            
        endcase
        
    end

    //output logic block
    always_comb begin 
        case (state)
            //default
            get_tx_packet_data = 0;
            data_out = '1;
            tx_transfer_active = 0;
            tx_error = 0;
            enable_crc = 0;
            end_of_packet = 0;
            load_enable = 0;

            IDLE: begin
                get_tx_packet_data = 0;
                data_out = '1;
                tx_transfer_active = 0;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_SYNC: begin
                get_tx_packet_data = 0;
                data_out = 8'b00000001;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 1;
            end
            SYNC: begin
                get_tx_packet_data = 0;
                data_out = 8'b00000001;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_PID: begin
                get_tx_packet_data = 0;
                
                case(tx_packet) 
                    3'd1: data_out = 8'b11000011;
                    3'd2: data_out = 8'b01001011;
                    3'd3: data_out = 8'b11010010;
                    3'd4: data_out = 8'b01011010;
                    3'd5: data_out = 8'b00011110;
                endcase

                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 1
            end
            PID: begin
                get_tx_packet_data = 0;
                
                case(tx_packet) 
                    3'd1: data_out = 8'b11000011;
                    3'd2: data_out = 8'b01001011;
                    3'd3: data_out = 8'b11010010;
                    3'd4: data_out = 8'b01011010;
                    3'd5: data_out = 8'b00011110;
                endcase

                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            GET_DATA: begin
                get_tx_packet_data = 1;
                data_out = '1;
                tx_transfer_active = 0;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_DATA: begin
                get_tx_packet_data = 0;
                data_out = tx_packet_data;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 1;
                end_of_packet = 0;
                load_enable = 1;
            end
            SEND_DATA: begin
                get_tx_packet_data = 0;
                data_out = 8'b11111111;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0; //todo DOUBLE CHECK THIS LOGIC FOR THE CRC. 
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_CRC1: begin
                get_tx_packet_data = 0;
                data_out = crc_out[7:0];
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 1;
            end
            CRC1: begin
                get_tx_packet_data = 0;
                data_out = crc_out[7:0];
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_CRC2: begin
                get_tx_packet_data = 0;
                data_out = crc_out[15:8];
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 1;
            end
            CRC2: begin
                get_tx_packet_data = 0;
                data_out = crc_out[15:8];
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
            LOAD_EOP: begin
                get_tx_packet_data = 0;
                data_out = 8'b11111100;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 1;
                load_enable = 1;
            end
            EOP: begin
                get_tx_packet_data = 0;
                data_out = 8'b11111100;
                tx_transfer_active = 1;
                tx_error = 0;
                enable_crc = 0;
                end_of_packet = 1;
                load_enable = 0;
            end
            ERROR: begin
                get_tx_packet_data = 0;
                data_out = 8'b11111111;
                tx_transfer_active = 0; //todo check this?
                tx_error = 1;
                enable_crc = 0;
                end_of_packet = 0;
                load_enable = 0;
            end
        endcase
    end

endmodule