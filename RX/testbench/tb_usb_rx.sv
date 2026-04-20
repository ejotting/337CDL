`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_rx ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    string testname;
    string testcase1 = "IN Packet";
    string testcase2 = "OUT Packet";
    string testcase3 = "ACK Packet";
    string testcase4 = "DATA0 Packet";
    string testcase5 = "DATA1 Packet";
    string testcase6 = "Unknown PID";
    string testcase7 = "Unknown Address";
    string testcase8 = "Incorrect CRC";
    string testcase9 = "No Bit Stuff RX";
    string testcase10 = "Bit Stuff RX";
    string testcase11 = "Full data buffer";

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    logic [6:0]buffer_occupancy;
    logic dp_in, dm_in;

    task automatic send_byte(logic [7:0]in, ref logic dp_in, ref logic dm_in);
    begin
        
        for(int i = 0; i < 8; i++) begin
            if(in[i] == 0) begin
                dp_in = ~dp_in;
                dm_in = ~dm_in;
            end
            repeat(8) @(negedge clk);
            if(i == 2 || i == 5) @(negedge clk);
        end
    end
    endtask

    task automatic send_IN(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01101001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
    end
    endtask

    task automatic send_OUT(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
    end
    endtask

    task automatic send_DATA(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11000011,dp_in,dm_in);
        
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b01010011,dp_in,dm_in);
        send_byte(8'b11000111,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
    end
    endtask

    task automatic send_ACK(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11010010,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
    end
    endtask

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

    usb_rx DUT (.clk(clk),.n_rst(n_rst),.buffer_occupancy(buffer_occupancy),
    .dp_in(dp_in),.dm_in(dm_in));

    initial begin
        n_rst = 1;
        buffer_occupancy = 7'd0;
        dp_in = 1;
        dm_in = 0;
        reset_dut;
        testname = testcase1;
        //IN
        @(negedge clk);
        send_IN(dp_in,dm_in);

        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01101001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase2;
        //OUT
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase3;
        //ACK
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11010010,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase4;
        //DATA0
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11000011,dp_in,dm_in);
        
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b01010011,dp_in,dm_in);
        send_byte(8'b11000111,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);

        testname = testcase5;
        //DATA1
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01001011,dp_in,dm_in);
        
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b01010011,dp_in,dm_in);
        send_byte(8'b11000111,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase9;
        //Illegal bit stuff
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01001011,dp_in,dm_in);
        
        send_byte(8'b01111111,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b01010011,dp_in,dm_in);
        send_byte(8'b11000111,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase10;
        //Legal bit stuff
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01001011,dp_in,dm_in);
        
        send_byte(8'b01111110,dp_in,dm_in);
        repeat(8) @(negedge clk);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b10100100,dp_in,dm_in);
        send_byte(8'b01000110,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase7;
        //Wrong address/endpoint
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100001,dp_in,dm_in);
        send_byte(8'b01101110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase6;
        //Wrong PID
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100101,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        testname = testcase8;
        //Incorrect CRC
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b01010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);

        //Data buffer full
        testname = testcase11;
        buffer_occupancy = 7'd64;
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b01001011,dp_in,dm_in);
        
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b00010000,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);

        send_byte(8'b01010011,dp_in,dm_in);
        send_byte(8'b11000111,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
        $finish;
    end
endmodule

/* verilator coverage_on */

