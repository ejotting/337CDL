`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_usb ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, dp_in, dm_in, hsel, hwrite;
    logic [3:0]haddr;
    logic [1:0]htrans, hsize;
    logic [2:0]hburst;
    logic [31:0]hwdata;

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

    ahb_usb #() DUT (.clk(clk),.n_rst(n_rst),.hsel(hsel),.haddr(haddr),
    .htrans(htrans),.hsize(hsize),.hburst(hburst),.hwrite(hwrite),.hwdata(hwdata),
    .dp_in(dp_in),.dm_in(dm_in));

    initial begin
        n_rst = 1;
        hsel = 0;
        haddr = 0;
        htrans = 0;
        hsize = 0;
        hburst = 0;
        hwrite = 0;
        hwdata = 0;
        dp_in = 1;
        dm_in = 0;
        reset_dut;

        @(negedge clk);
        send_IN(dp_in,dm_in);
        send_OUT(dp_in,dm_in);
        send_DATA(dp_in,dm_in);
        send_ACK(dp_in,dm_in);
        $finish;
    end
endmodule

/* verilator coverage_on */

