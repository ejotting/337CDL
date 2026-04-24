`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_subordinate_usb ();

    localparam CLK_PERIOD = 10ns;
    localparam TIMEOUT = 1000;

    localparam BURST_SINGLE = 3'd0;
    localparam BURST_INCR   = 3'd1;
    localparam BURST_WRAP4  = 3'd2;
    localparam BURST_INCR4  = 3'd3;
    localparam BURST_WRAP8  = 3'd4;
    localparam BURST_INCR8  = 3'd5;
    localparam BURST_WRAP16 = 3'd6;
    localparam BURST_INCR16 = 3'd7;

    localparam HTRANS_IDLE=2'd0;
    localparam HTRANS_BUSY=2'd1;
    localparam HTRANS_SEQ=2'd2;
    localparam HTRANS_NONSEQ=2'd3;

    initial begin
        $dumpfile("waveform.fst");
        $dumpvars;
    end

    logic clk, n_rst;

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
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    logic hsel;
    logic [4:0] haddr;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic [1:0] htrans;
    logic hwrite;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic hresp;
    logic hready;

    logic TX_error,RX_error,RX_dataready;
    logic RX_transferactive, TX_transferactive;
    logic [2:0] RX_packet, TX_packet;
    logic [7:0] RX_data,TX_data;
    logic [6:0] bufferoccupancy;
    logic clear, get_rx_data, store_tx_data,D_mode;

    //usb sub
    ahb_subordinate_usb #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(4)
    ) DUT(
        .clk(clk),
        .n_rst(n_rst),
        .hsel(hsel),
        .haddr(haddr[3:0]),
        .hsize(hsize),
        .htrans(htrans),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hburst(hburst),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready),
        .TX_error(TX_error),
        .RX_error(RX_error),
        .RX_dataready(RX_dataready),
        .RX_transferactive(RX_transferactive),
        .TX_transferactive(TX_transferactive),
        .RX_packet(RX_packet),
        .RX_data(RX_data),
        .bufferoccupancy(bufferoccupancy),
        .TX_packet(TX_packet),
        .TX_data(TX_data),
        .clear(clear),
        .get_rx_data(get_rx_data),
        .store_tx_data(store_tx_data),
        .D_mode(D_mode)
    );
    // bus model connections
    ahb_model_updated #(
        .ADDR_WIDTH(5),
        .DATA_WIDTH(4)
    ) BFM ( .clk(clk),
        // AHB-Subordinate Side
        .hsel(hsel),
        .haddr(haddr),
        .hsize(hsize),
        .htrans(htrans),
        .hburst(hburst),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready)
    );

    // Supporting Tasks
    task reset_model;
        BFM.reset_model();
    endtask

    // Read from a register without checking the value
    task enqueue_poll ( input logic [3:0] addr, input logic [1:0] size );
    logic [31:0] data [];
        begin
            data = new [1];
            data[0] = {32'hXXXX};
            //              Fields: hsel,  R/W, addr, data, exp err,         size, burst, chk prdata or not
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data,    1'b0, {1'b0, size},  3'b0,            1'b0);
        end
    endtask

    // Read from a register until a requested value is observed
    task poll_until ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] data);
        int iters;
        begin
            for (iters = 0; iters < TIMEOUT; iters++) begin
                enqueue_poll(addr, size);
                execute_transactions(1);
                if(BFM.get_last_read() == data) break;
            end
            if(iters >= TIMEOUT) begin
                $error("Bus polling timeout hit.");
            end
        end
    endtask

    // Read Transaction, verifying a specific value is read
    task enqueue_read ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] exp_read );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = exp_read;
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b1);
        end
    endtask

    // Write Transaction
    task enqueue_write ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] wdata );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b1, 1'b1, addr, data, 1'b0, {2'b0, size}, 3'b0, 1'b0);
        end
    endtask
    
    // Write Transaction Intended for a different subordinate from yours
    task enqueue_fakewrite ( input logic [3:0] addr, input logic [1:0] size, input logic [31:0] wdata );
        logic [31:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b0, 1'b1, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Create a burst read of size based on the burst type.
    // If INCR, burst size dependent on dynamic array size
    task enqueue_burst_read ( input logic [3:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [31:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b0, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Create a burst write of size based on the burst type.
    task enqueue_burst_write ( input logic [3:0] base_addr, input logic [1:0] size, input logic [2:0] burst, input logic [31:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b1, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Run n transactions, where a k-beat burst counts as k transactions.
    task execute_transactions (input int num_transactions);
        BFM.run_transactions(num_transactions);
    endtask

    // Finish the current transaction
    task finish_transactions();
        BFM.wait_done();
    endtask

    logic [31:0] data [];

    initial begin
        n_rst = 1;
        TX_error=0;
        RX_error=0;
        RX_dataready=1;
        RX_transferactive=0;
        TX_transferactive=0;
        RX_packet='0;
        RX_data='0;
        bufferoccupancy='0;
        reset_model();
        reset_dut();
        
        /*$display("RX pop");
        RX_dataready=1;
        RX_data=8'hA5;
        enqueue_read(4'h0,2'b00,32'h000000A5);
        execute_transactions(1);
        
        $display("RX stall");
        RX_dataready=0;
        RX_data=8'hBB;
        enqueue_read(4'h0,2'b00,32'h000000BB);
        RX_dataready<=#(CLK_PERIOD*3) 1'b1;
        execute_transactions(1);
        finish_transactions();
        $display("TX push");
        enqueue_write(4'h0,2'b00,32'h0000005a);
        execute_transactions(1);
        finish_transactions();
        #(CLK_PERIOD*2);
        $display("Read status");
        RX_dataready=1;
        RX_packet=3'b001; //in token
        TX_transferactive=1;
        enqueue_read(4'h4,2'b10,32'h00000203);
        execute_transactions(1);
        finish_transactions();
        
        //write to a read only register
        $display("write to a status register, hresp should go high");
        enqueue_write(4'h4,2'b10,32'hFFFFFFFF);
        execute_transactions(1);
        finish_transactions();
        enqueue_read(4'h4,2'b10,32'h00000203);
        execute_transactions(1);
        finish_transactions();
        TX_transferactive=0;
        RX_packet='0;
        RX_dataready=0;*/
        //RAW hazard check reads something right ater a write
        $display("Raw hazard check, reads something right after a write");
        RX_dataready=1;
        RX_data=8'hBB;
        bufferoccupancy=7'd1;
        enqueue_write(4'h0,2'b01,16'hCCAA);
        enqueue_read(4'h1,2'b00,8'hBB);
        execute_transactions(2);
        
        
     
        finish_transactions();
        //write one byte to one register, 
        /*$display("Write to 0x2");
        enqueue_write(4'h2,2'b00,8'hFF);
        execute_transactions(1);
        finish_transactions();
        $display("fake write, hsel low");
        enqueue_fakewrite(4'h0,2'b10,32'hAABBCCDD);
        execute_transactions(1);
        finish_transactions();
        $display("Read error");
        TX_error=1;
        RX_error=1;
        @(negedge clk);
        enqueue_read(4'h6,2'b01,32'h00000101);
        
        execute_transactions(1);
        #(1);
        finish_transactions();

        #(CLK_PERIOD);
        RX_error=0;
        TX_error=0;
        
        $display("Read buffer occupancy");
        bufferoccupancy=7'd64;
        enqueue_read(4'h8,2'b10,32'h00000040);
        execute_transactions(1);
        finish_transactions();
        $display("read write TX packet");
        enqueue_write(4'hC,2'b00,32'h0000004B); //DATA0
        execute_transactions(1);
        finish_transactions();
        enqueue_read(4'hC, 2'b00,32'h00000002);
        execute_transactions(1);
        finish_transactions();
       
        $display("flush read/write");
        // Change size to 2'b00 (Byte) and use 32'h100
        enqueue_write(4'hD, 2'b00, 32'h00000001);
        execute_transactions(1);
        finish_transactions();


        // Read immediately (size 2'b00)
        enqueue_read(4'hD, 2'b00, 32'h00000100);
        execute_transactions(1);
        finish_transactions();


        #(CLK_PERIOD);
        // Read again to prove it cleared (size 2'b00)
        enqueue_read(4'hD, 2'b00, 32'h00000000);
        execute_transactions(1);
        finish_transactions();

        
        //Multibyte
        $display("Multibyte write");
        enqueue_write(4'h0,2'b10,32'hAABBCCDD);
        execute_transactions(1);
        finish_transactions();

        $display("Multibyte read");
        RX_dataready=1;
        RX_data=8'h77;
        enqueue_read(4'b0,2'b10,32'h77777777);
        execute_transactions(1);
        finish_transactions();

        $display("INCR8 test");
        RX_dataready=1;
        RX_data=8'hA5;
        bufferoccupancy=7'd64;
        RX_packet=3'b001;
        TX_transferactive=1;
        RX_transferactive=0;
        data=new[8];
        data[0]=32'hA5a5a5a5;
        data[1]=32'h00000203;
        data[2]=32'h00000040;
        data[3]=32'h00000002;
        //overflow
        data[4]='0;
        data[5]='0;
        data[6]='0;
        data[7]='0;
        enqueue_burst_read(4'h0,2'b10,BURST_INCR8,data);
        execute_transactions(8);
        
        finish_transactions();

        $display("WRAP8 read");
        RX_dataready=1;
        RX_data=8'hA5;
        bufferoccupancy=7'd64;
        RX_packet=3'b001;
        TX_transferactive=1;
        RX_transferactive=0;
        data=new[8];
        
        data[0]=32'h00000040;
        data[1]=32'h00000002;
        data[2]=32'ha5a5a5a5;
        data[3]=32'h00000203;
        data[4]=32'h00000040;
        data[5]=32'h00000002;
        data[6]=32'ha5a5a5a5;
        data[7]=32'h00000203;
        enqueue_burst_read(4'h8,2'b10,BURST_WRAP8,data);
        execute_transactions(8);
        finish_transactions();

        $display("variable INCR (3)");
        RX_dataready=1;
        RX_data=8'ha5;
        data=new[3];
        data[0]=32'ha5a5a5a5;
        data[1]=32'h00000203;
        data[2]=32'h00000040;
        enqueue_burst_read(4'h0,2'b10,BURST_INCR,data);
        execute_transactions(3);
        finish_transactions();*/
        $finish;


    end
endmodule

/* verilator coverage_on */


