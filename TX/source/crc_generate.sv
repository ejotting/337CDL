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
        shifted = {crc[14:0], 1'b0};
        
        //if new data payload is being sent & data clk is at its edge
        if (enable_crc && strobe) begin 
            if (data_in == crc[15]) begin //if current bit matches MSB
                next_crc = shifted; //then shift in a zero
            end
            else begin //perform XOR on polynomial after shift w zero
                next_crc = shifted ^ 16'b1000000000000101;
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