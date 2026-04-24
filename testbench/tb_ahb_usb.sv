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
    logic [1:0]htrans;
    logic [2:0] hsize;
    logic [2:0]hburst;
    logic [31:0]hwdata;
    logic [31:0] hrdata;
    logic hready, hresp;
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
    
    task automatic send_ERROR(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);
        send_byte(8'b11100001,dp_in,dm_in);
        send_byte(8'b01100110,dp_in,dm_in);
        send_byte(8'b10010000,dp_in,dm_in);
        dp_in = 0;
        dm_in = 0;
        repeat(16) @(negedge clk);
        dp_in = 1;
        repeat(9) @(negedge clk);
    end

    endtask

    task automatic send_DATA(ref logic dp_in, ref logic dm_in);
    begin
        send_byte(8'b10000000,dp_in,dm_in);//sync
        send_byte(8'b01001011,dp_in,dm_in);//pid
        
        send_byte(8'b01111110,dp_in,dm_in);//FE
        repeat(8) @(negedge clk);
        send_byte(8'b00010000,dp_in,dm_in);//10
        send_byte(8'b01100110,dp_in,dm_in);//66
        send_byte(8'b01000111,dp_in,dm_in);//47
        send_byte(8'b01000110,dp_in,dm_in);
        send_byte(8'b01110110,dp_in,dm_in);

        send_byte(8'b01000111,dp_in,dm_in);
        send_byte(8'b01101100,dp_in,dm_in);
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
    task automatic ahb_burstincr4(input logic iswrite,input logic [3:0] start_addr, input logic [2:0] burst_mode, input logic [15:0] wdata [4],output logic [15:0] rdata [4]);
    begin  
        integer i;
        logic [3:0] current_addr;
        current_addr=start_addr;
       
        @(negedge clk);
        hsel=1; hwrite=iswrite; hsize='0; hburst=burst_mode; htrans=2'b10; haddr=current_addr;
       
        for(i=0;i<4;i++) begin
            @(negedge clk);
            while(!hready) @(negedge clk);
           
            if(iswrite) begin
                
               hwdata=wdata[i];
            end else begin
               rdata[i]=hrdata; // Perfectly timed normal read!
            end
           
            if(i < 3) begin
               htrans=2'b11;
               current_addr=current_addr+1;
               haddr=current_addr;
            end else begin
               htrans='0;
               hsel=0;
            end
        end
        @(negedge clk);
        while(!hready) @(negedge clk);
        @(negedge clk);
       
    end
    endtask
    task automatic ahb_burst_variable_incr(input logic [3:0] start_addr, input integer beats, output logic [31:0] rdata []);
    begin
        
        integer i;
        logic [3:0] current_addr;
        rdata=new[beats];
        current_addr=start_addr;
        @(negedge clk);
        hsel=1;
        hwrite=0;
        hsize=3'b010;
        hburst=3'b001;
        htrans=2'b10;
        haddr=current_addr;
        for(i=0;i<beats;i++) begin
            @(negedge clk);
            while(!hready) @(negedge clk);
            rdata[i]=hrdata;
            if(i<(beats-1))begin
                htrans=2'b11;
                current_addr=current_addr+4'd4;
                haddr=current_addr;
            end else begin
                htrans=2'b00;
                hsel=0;
            end
        end
    end 
    endtask
    task automatic ahb_burstwrap8(input logic [3:0] start_addr, output logic [15:0] rdata [8]);
    begin
        integer i;
        logic [3:0] current_addr;
        current_addr=start_addr;
        @(negedge clk);
        hsel=1;
        hwrite=0;
        hsize=3'b001;
        hburst=3'b100;
        htrans=2'b10;
        haddr=current_addr;
        for(i=0;i<8;i++) begin
            @(negedge clk);
            while(!hready) @(negedge clk);
            rdata[i]=hrdata;
            if(i<7) begin
                htrans=2'b11;
                current_addr=current_addr+4'd2;
                haddr=current_addr;
            end else begin
                htrans='0;
                hsel=0;
            end
        end
            
        
         
    end
    endtask

 
    ahb_usb #() DUT (.clk(clk),.n_rst(n_rst),.hsel(hsel),.haddr(haddr),
    .htrans(htrans),.hsize(hsize),.hburst(hburst),.hwrite(hwrite),.hwdata(hwdata),.hrdata(hrdata),.hready(hready),.hresp(hresp),
    .dp_in(dp_in),.dm_in(dm_in));

    logic [15:0] mtx_data [4];
    logic [15:0] mrx_data [4];
    logic [15:0] mrx_data_wrap[8];
    logic [31:0] incr3[];
    logic [31:0] incr5[];
    integer i;
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

        
        mtx_data[0]=32'h00000011;
        mtx_data[1]=32'h00002200;
        mtx_data[2]=32'h00330000;
        mtx_data[3]=32'h44000000;
        /*mtx_data[4]=32'h00000055;
        mtx_data[5]=32'h00006600;
        mtx_data[6]=32'h00770000;
        mtx_data[7]=32'h88000000;*/
        $display("First INCR4 write");
        ahb_burstincr4(1'b1,4'h0,3'b011,mtx_data[0:3],mrx_data[0:3]);
        /*$display("Second INCR4 write");
        ahb_burst(1'b1,4'h0,3'b011,mtx_data[4:7],mrx_data[4:7]);
        send_DATA(dp_in,dm_in);*/
      
        $display("First INCR4 read");
        ahb_burstincr4(1'b0,4'h0,3'b011,mtx_data[0:3],mrx_data[0:3]);
        @(negedge clk);
        /*$display("Second INCR4 read");
        ahb_burst(1'b0,4'h0,3'b011,mtx_data[4:7],mrx_data[4:7]);*/
        @(negedge clk);
        $display("Verify INCR4 Write");
        for(int i=0;i<4;i++) begin
            if(mrx_data[i]==mtx_data[i]) begin
                $display("Beat %d passed",i);
            end else begin
                $display("Beat %d failed, expected %h got %h",i, mtx_data[i],mrx_data[i]);
            end
        end
        $display("Send good packet");
        send_DATA(dp_in,dm_in);

        ahb_burstwrap8(4'hE, mrx_data_wrap);
        $display("wrap results");
        $display("Beat 0, add 0xE %h ",mrx_data_wrap[0]);
        $display("Beat 1, add 0x0 %h ",mrx_data_wrap[1]);
        $display("Beat 2, add 0x2 %h ",mrx_data_wrap[2]);
        $display("Beat 3, add 0x4 %h ",mrx_data_wrap[3]);
        $display("Beat 4, add 0x6 %h ",mrx_data_wrap[4]);
        $display("Beat 5, add 0x8 %h ",mrx_data_wrap[5]);
        $display("Beat 6, add 0xA %h ",mrx_data_wrap[6]);
        $display("Beat 7, add 0xC %h ",mrx_data_wrap[7]);
        $display("Starting flush");
        hsel=1;
        haddr=4'hD;
        hwrite=1;
        hwdata=32'h00000100;
        htrans=2'b10;
        @(negedge clk);
        while(!hready ) @(negedge clk);
        hsel=0;
        htrans='0;
        @(negedge clk);
        
        htrans=2'b10;
        @(negedge clk);
        while(!hready) @(negedge clk);
        $display("Post flush flush register %h", hrdata);
        @(negedge clk);
        hsel=0;
        htrans=2'b00;
        send_DATA(dp_in,dm_in);
        $display("variable INCR3 starting at 0x4");
        ahb_burst_variable_incr(4'h4,3,incr3);
        $display("variable incr3 results");
        $display("Beat 0, add 0x4 %h ",incr3[0]);
        $display("Beat 1, add 0x8 %h ",incr3[1]);
        $display("Beat 2, add 0xC %h ",incr3[2]);
        $display("Variable incr5, expected two case error state");
        ahb_burst_variable_incr(4'h0,5,incr5);

        /*
        send_IN(dp_in,dm_in);
        send_OUT(dp_in,dm_in);
        send_DATA(dp_in,dm_in);
        send_ACK(dp_in,dm_in);*/
        
//testing TX here 
        //normal test case
        @(negedge clk);
        hsel = 1;
        hwrite = 1;
        hburst = 3'b11; //INCR4 idk 
        hsize = 3'b010; //size 4
        htrans = 2'b10;
        haddr = 4'd0;
        @(negedge clk); //set everything up for hburst INCR4 to transmit with tx

        while (!hready) @(negedge clk); //continue clk until done with transfers
        hwdata = 32'h11; 
        htrans = 2'b11; 
        haddr = 4'd1;
        @(negedge clk);
        while (!hready) @(negedge clk);
        hwdata = 32'h22;  
        htrans = 2'b11; 
        haddr = 4'd2;
        @(negedge clk);
        while (!hready) @(negedge clk);
        hwdata = 32'h33;  
        htrans = 2'b11; 
        haddr = 4'd3;
        @(negedge clk);
        while (!hready) @(negedge clk);
        hwdata = 32'h44; 
        htrans = 2'b0; 
        hsel = 0;
        @(negedge clk);
        while (!hready) @(negedge clk);
        repeat(3) @(negedge clk);
        hsel = 1;
        hwrite = 1;
        hburst = 3'b0;  
        htrans = 2'b10;    
        haddr = 4'hC; //write to C address. this is the only time it enables the TX to output.

        @(negedge clk);
        while (!hready) @(negedge clk);
        hwdata = 32'hC3; //hwdata[7:0]= C3 and tx_packet = 1 (so DATA0)
        htrans = 2'b0;
        hsel = 0;
        repeat(1400) @(negedge clk);

        //induce tx error
        @(negedge clk);
        hsel = 1;
        hwrite = 1;
        hburst = 3'b0; 
        hsize = 3'b0;
        htrans = 2'b10; //nonseq
        haddr = 4'hC;
        @(negedge clk);
        hwdata = 32'h4B; //hwdata[7:0]= C3 and tx_packet = 1 (so DATA0) but data buffer should be empty rn.
        repeat(30) @(negedge clk);

        //returns to idle mode and continues normal operation
        //send ACK packet
        @(negedge clk);
        hsel = 1;
        hwrite = 1;
        hburst = 3'b0; 
        hsize = 3'b0;
        htrans = 2'b10;   
        haddr = 4'hC;
        @(negedge clk);
        while (!hready) @(negedge clk);
        hwdata = 32'hD2;   //D2 means tx_packet =011 (ACK packet)
        htrans = 2'b0;
        hsel = 0;
        @(negedge clk);
        while (!hready) @(negedge clk);
        repeat(300) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

