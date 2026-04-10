`timescale 1ns / 10ps

module counter_889(
    input logic clk, n_rst, count_enable, clear_889, tx_transfer_active,
    output logic count, strobe, data_done
);
    logic phase1, phase2, phase3; 
    logic count889; //strobe goes HIGH on 8, 16, 25
    logic next_count, next_strobe;

    always_comb begin
        //default
        next_count = count;
        next_strobe = strobe;

        phase1 = (count + 1) < 8;
        phase2 = (count + 1) > 8 && (count + 1) < 16;
        phase3 = (count + 1) > 16 && (count + 1) < 25;

        count889 = ((count + 1) == 8) | ((count + 1) == 16) | ((count + 1) == 25); 

        if (clear_889) begin
            next_count = 0;
            next_strobe = 0;
        end
        else if ((phase1 | phase2 | phase3) && count_enable) begin
            next_count = count + 1;
            next_strobe = 0;
        end
        else if (count889 && count_enable) begin
            next_count = count + 1;
            next_strobe = 1;
        end
        else if ((count + 1) > 25 && count_enable) begin
            next_count = 1;
            next_strobe = 0;
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            count <= 0;
            strobe <= 0;
        end
        else begin
            count <= next_count;
            strobe <= next_strobe;
        end
    end

    flex_counter #(.SIZE(4)) dataDoneCounter(
        .clk(clk), 
        .n_rst(n_rst),
        .clear(~tx_transfer_active), 
        .count_enable(count_enable && tx_transfer_active), 
        .rollover_val(4'd8), 
        .count_out(), 
        .rollover_flag(data_done));
endmodule