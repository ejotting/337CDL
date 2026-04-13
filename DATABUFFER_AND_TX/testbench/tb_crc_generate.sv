`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_crc_generate ();

    localparam CLK_PERIOD = 2.5ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    //DUT
    logic clk, n_rst, data_in, enable_crc, strobe;
    logic [15:0] crc_out;

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
        data_in = 0;
        enable_crc = 0;
        strobe = 0;
    end
    endtask

    task send_bit(input logic bit_val);
    begin
        data_in = bit_val;
        enable_crc = 1; //this is when we start loading data & sending data (fsm states)
        strobe = 1;
        @(negedge clk); //crc begins to calculate by shifting. remember this only occurs on the data clk
        strobe = 0;
        repeat(2) begin //this replicates when system clk is going but data clk isnt strobed
            @(negedge clk);  
        end 
    end
    endtask

    //DUT instance
    crc_generate DUT (
        .clk(clk),
        .n_rst(n_rst),
        .data_in(data_in),
        .enable_crc(enable_crc),
        .strobe(strobe),
        .crc_out(crc_out)
    );

    initial begin
        n_rst = 1;
        initialize;
        reset_dut;
        @(negedge clk);

        $display("Send in 8'b01100101");
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        enable_crc = 0;
        strobe = 0;
        @(negedge clk);
        //repeat (3) @(negedge clk);

        $display("Send in 8'b10100110");
        send_bit(0);    
        send_bit(1);  
        send_bit(1);
        send_bit(0);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        enable_crc = 0;
        strobe = 0;
        repeat (3) @(negedge clk);


        $display("Strobe low (CRC does not change)");
        data_in = 1;
        enable_crc = 1;
        strobe = 0;
        repeat(3) @(negedge clk);

        $display("Enable low (CRC does not change)");
        data_in = 1;
        enable_crc = 0;
        strobe = 1;
        repeat(3) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

