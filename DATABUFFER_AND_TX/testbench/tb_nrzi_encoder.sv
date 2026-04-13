`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_nrzi_encoder ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    //DUT
    logic clk, n_rst;
    logic serial_in, end_of_packet, strobe;
    logic dp_out, dm_out;

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
        serial_in = 0;
        end_of_packet = 0;
        strobe = 0;
    end
    endtask

    //DUT instance
    nrzi_encoder DUT (
        .clk(clk),
        .n_rst(n_rst),
        .serial_in(serial_in),
        .end_of_packet(end_of_packet),
        .strobe(strobe),
        .dp_out(dp_out),
        .dm_out(dm_out)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;

        $display("Strobe = 0 (data clk); nothing changes");
        serial_in = 1'b0;
        end_of_packet = 1'b0;
        strobe = 1'b0;
        @(negedge clk);

        $display("Strobe = 1; normal encoding");
        serial_in = 1'b1;
        end_of_packet = 1'b0;
        strobe = 1'b1;
        @(negedge clk); //1
        serial_in = 1'b0;
        end_of_packet = 1'b0;
        strobe = 1'b1;
        @(negedge clk); //0
        serial_in = 1'b0;
        end_of_packet = 1'b0;
        strobe = 1'b1;
        @(negedge clk); //0
        serial_in = 1'b1;
        end_of_packet = 1'b0;
        strobe = 1'b1;
        @(negedge clk); //1

        $display("EOP encoding");
        serial_in = 1'b0;
        end_of_packet = 1'b1;
        strobe = 1'b1;
        @(negedge clk); //0
        serial_in = 1'b0;
        end_of_packet = 1'b1;
        strobe = 1'b1;
        @(negedge clk); //0
        serial_in = 1'b1;
        end_of_packet = 1'b1;
        strobe = 1'b1;
        @(negedge clk); //1
        serial_in = 1'b1;
        end_of_packet = 1'b1;
        strobe = 1'b1;
        @(negedge clk); //1

        $finish;
    end
endmodule

/* verilator coverage_on */

