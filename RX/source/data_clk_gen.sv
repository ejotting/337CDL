`timescale 1ns / 10ps

module data_clk_gen (
    input logic clk, 
    input logic n_rst, 
    input logic new_edge,
    output logic data_out, 
    output logic sample_the_data
);

logic ndata_out, nsample_the_data, rollover1, rollover2, start_count1, start_count2, stay_one;
logic [4:0] count_out2;
logic [2:0] count_out1;

always_ff @(posedge clk or negedge n_rst) begin
    
    if(!n_rst) begin
        data_out <= 1'b1;
        sample_the_data <= 1'b0;
    end else begin
        data_out <= ndata_out;
        sample_the_data <= nsample_the_data;

        if(new_edge) begin start_count1 <= 1'b1; start_count2 <= 1'b0; end
        else if(rollover1) begin start_count1 <= 1'b0; start_count2 <= 1'b1; end
        
        if(rollover2) stay_one <= 1'b1;
        else if(new_edge) stay_one <= 1'b0;
    end
end
/* verilator lint_off PINMISSING */
flex_ctr #(.SIZE(3)) FIRSTSAMPLE (.clk(clk),.n_rst(n_rst),.clear(new_edge),.count_enable(start_count1),
.rollover_val(3'd4),.count_out(count_out1),.rollover_flag(rollover1));

flex_ctr #(.SIZE(5)) EIGHTEIGHTNINE (.clk(clk),.n_rst(n_rst),.clear(new_edge),.count_enable(start_count2),
.rollover_val(5'd25),.count_out(count_out2),.rollover_flag(rollover2));

always_comb begin

    if(count_out1 == 3'd3 || count_out2 == 5'd7 || count_out2 == 5'd15 || count_out2 == 5'd24) nsample_the_data = 1'b1;
    else nsample_the_data = 1'b0;

    if(count_out2 > 5'd5 || stay_one) ndata_out = 1'b1;
    else ndata_out = 1'b0;

end

endmodule

