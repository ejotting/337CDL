`timescale 1ns / 10ps

module counter_889(
    input logic clk, n_rst, count_enable, clear_889, tx_transfer_active,
    output logic [4:0]count, 
    output logic strobe, data_done
);
    logic [4:0]next_count;
    logic next_strobe;
    always_comb begin
        next_count = count;
        next_strobe = 1'b0;
        if (clear_889) begin
            next_count = 5'd1;
            next_strobe = 1'b0;
        end
        else if (count_enable) begin
            if ((count + 1) == 5'd8 || (count + 1) == 5'd16 || (count + 1) == 5'd25) begin
                next_count = count + 1'b1;
                next_strobe = 1'b1;
            end
            else if ((count + 1) > 5'd25) begin
                next_count = 5'd1;
                next_strobe = 1'b0;
            end
            else begin
                next_count = count + 1'b1;
                next_strobe = 1'b0;
            end
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            count <= 5'd0; 
            strobe <= 1'b0;
        end
        else begin
            count <= next_count;
            strobe <= next_strobe;
        end
    end

    logic [3:0]data_count;
    flex_counter #(.SIZE(4)) myCounter(
        .clk(clk), 
        .n_rst(n_rst),
        .clear((strobe && ~tx_transfer_active) || clear_889), 
        .count_enable(strobe && tx_transfer_active), 
        .rollover_val(4'd8), //todo
        .count_out(data_count), 
        .rollover_flag()
    );
    assign data_done = strobe && tx_transfer_active && (data_count == 4'd7);

endmodule