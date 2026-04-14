`timescale 1ns / 10ps

module crc_generate(
    input logic clk, n_rst, data_in, enable_crc, strobe,
    output logic [15:0] crc_out
);
    logic [15:0] shifted, crc;
    logic [15:0] next_crc;

    always_comb begin
        //default
        next_crc = crc;
        shifted = {1'b0, crc[15:1]}; //shift right bc LSB data in TODO
        
        //if new data payload is being sent & data clk is at its edge
        if (enable_crc && strobe) begin 
            if (data_in == crc[0]) begin //if current bit matches LSB TODO (double check this)
                next_crc = shifted; //then shift in a zero
            end
            else begin //perform XOR on polynomial after shift w zero
                next_crc = shifted ^ 16'ha001; //opposite order bc we are shifting data LSB first TODO
            end
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            crc <= 16'hFFFF;
        end
        else begin
            crc <= next_crc;
        end
    end

    assign crc_out = ~crc;
    
endmodule