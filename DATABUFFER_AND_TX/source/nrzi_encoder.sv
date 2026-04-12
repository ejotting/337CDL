`timescale 1ns / 10ps

module nrzi_encoder(
    input logic clk, n_rst, serial_in, end_of_packet, strobe,
    output logic dp_out, dm_out
);
    logic next_dp_out, next_dm_out;

    always_comb begin 
        //default
        next_dp_out = dp_out;
        next_dm_out = dm_out;

        if(strobe) begin
            if (!end_of_packet && serial_in == 0) begin
                next_dp_out = ~dp_out;
                next_dm_out = ~dm_out;
            end

            //in EOP state, the serial data from data_out is 8'b11111100 in order to pull dp_out and dm_out both LOW for two periods
            else if (end_of_packet && serial_in == 0) begin
                next_dp_out = 0;
                next_dm_out = 0;
            end
            //continuation of EOP data_out (idle bits)
            else if (end_of_packet && serial_in == 1) begin
                next_dp_out = 1;
                next_dm_out = 0;	
            end

            //else if (!end_of_packet && serial_in == 1), then dp & dm stay the same
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if(!n_rst) begin
            dp_out <= 1;
            dm_out <= 0;
        end
        else begin
            dp_out <= next_dp_out;
            dm_out <= next_dm_out;
        end
    end
endmodule