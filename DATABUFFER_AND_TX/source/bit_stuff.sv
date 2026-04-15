`timescale 1ns / 10ps

module bit_stuff(
    input logic clk, n_rst,
    input logic strobe, serial_in, 
    output logic serial_out, shift_enable
);
    logic[2:0]one_count, next_one_count;
    logic next_serial_out, next_shift_enable; 

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            one_count <= '0;
            serial_out <= 0;
            shift_enable <= 1;

        end
        else begin
            one_count <= next_one_count;
            serial_out <= next_serial_out;
            shift_enable <= next_shift_enable;
        end
    end
/*
    always_comb begin
        if(strobe) begin
            //default
            next_one_count = one_count;
            next_serial_out = serial_in;
            next_shift_enable = 1; //assume things go thru, so just keep shifting pts

            if(serial_in == 0) begin
                next_one_count = 3'd0;
            end
            else if(serial_in == 1 && one_count + 3'd1 == 3'd6)begin
                next_one_count = 3'd0;
                next_serial_out = 0;
                next_shift_enable = 0;
            end
            else if(serial_in == 1 && one_count + 3'd1 < 3'd6) begin //todo changed to +1 so it ahead of time shfit_enable is toggled
                next_one_count = one_count + 3'd1;
            end
        end
    end*/
    always_comb begin

        if(strobe) begin
            //default
            //next_eop_out = eop_in;//todo
            next_one_count = one_count;
            next_serial_out = serial_in;
            next_shift_enable = 1; //assume things go thru, so just keep shifting pts

            if(one_count == 3'd6)begin //...this
                next_one_count = 3'd0;
                next_serial_out = 0;
                next_shift_enable = 1;
            end
            else if(serial_in == 0) begin
                next_one_count = 3'd0;
                next_serial_out = serial_in;
                next_shift_enable = 1;
            end
            else if(serial_in == 1 && one_count + 3'd1 == 3'd6)begin //this will happen before...
                //next_one_count = 3'd0;
                //next_serial_out = 0;
                next_one_count = one_count + 3'd1;
                next_serial_out = serial_in;
                next_shift_enable = 0;
            end
            
            else if(serial_in == 1 && one_count + 3'd1 < 3'd6) begin //todo changed to +1 so it ahead of time shfit_enable is toggled
                next_one_count = one_count + 3'd1;
                next_serial_out = serial_in;
                next_shift_enable = 1;
            end
        end
    end
endmodule

