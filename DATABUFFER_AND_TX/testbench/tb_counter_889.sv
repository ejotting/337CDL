`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_counter_889 ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    //DUT
    logic clk, n_rst, count_enable, clear_889, tx_transfer_active;
    logic [4:0] count;
    logic strobe, data_done;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    task initialize;
    begin
        count_enable = 1'b0;
        clear_889 = 1'b0;
        tx_transfer_active = 1'b0;
    end
    endtask

    // DUT instance
    counter_889 DUT (
        .clk(clk),
        .n_rst(n_rst),
        .count_enable(count_enable),
        .clear_889(clear_889),
        .tx_transfer_active(tx_transfer_active),
        .count(count),
        .strobe(strobe),
        .data_done(data_done)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;

        $display("Run multiple system clocks");
        count_enable = 1;
        repeat(26) begin
            @(negedge clk);
        end

        $display("Hold idle (no counting)");
        count_enable = 0;
        repeat(8) begin
            @(negedge clk);
        end

        $display("Clear counter");
        count_enable = 1;
        clear_889 = 1;
        repeat (2) begin
            @(negedge clk);
        end

        $display("Check data_done counter (when transferring data)");
        count_enable = 1;
        clear_889 = 0;
        tx_transfer_active = 1;
        repeat(210) begin
            @(negedge clk);
        end

        $display("Check data_done cleared (when not transferring data)");
        count_enable = 1;
        tx_transfer_active = 0;
        repeat(2) begin
            @(negedge clk);
        end

        $finish;
    end
endmodule

/* verilator coverage_on */

