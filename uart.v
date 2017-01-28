`timescale 1ns / 1ps

module uart_tx
  #(parameter CLKFREQ=12000000, BAUD=115200)
   (
    input wire 	     clk,

    input wire 	     send,
    input wire [7:0] data,

    output reg 	     tx,
    output wire      busy
    );

   initial tx <= 1'b1;

   reg [6:0] clk_count = 7'b0;
   always @(posedge clk)
     clk_count <= (baud_clk)? 0 : clk_count + 1;

   wire baud_clk = (clk_count == (CLKFREQ/BAUD)-1);

   reg [9:0]   buff = 10'b1111111111;
   reg [3:0]   len = 0;
   assign busy = (len < 10);

   always @(posedge clk)
     begin

	if (!busy && send) begin
	   buff <= { 1'b1, data[7:0], 1'b0 };

	   len = 4'd0;
	   tx <= 1;
	end

	else if (busy && baud_clk) begin
	   tx <= buff[len];
	   len = len + 1;
	end

     end
endmodule


module uart_rx
  #(parameter CLKFREQ=12000000, BAUD=115200)
   (
    input wire 	     clk,

    input wire 	     rx,

    output wire      ready,
    output reg [7:0] data
    );

   initial data <= 8'b0;

   reg [6:0] clk_count = 7'b0;
   always @(posedge clk)
     begin
	if (frame)
	  clk_count <= (baud_clk0)? 0 : clk_count + 1;
	else
	  clk_count <= 0;
     end

   wire      baud_clk0 = (clk_count == (CLKFREQ/BAUD)-1);
   wire      baud_clk1 = (clk_count == ((CLKFREQ/BAUD)-1)/2);

   reg 	     frame = 0;
   reg [3:0] i = 4'hf;

   always @(negedge rx)
     begin
	if (!frame) begin
	   data <= 8'b0;
	   i <= 4'hf;
	   frame <= 1;
	end
     end

   always @(posedge baud_clk1)
     begin
	if (frame) begin
	   if (i > 7 && rx == 1)
	     frame <= 0;
	   else begin
	     data[i] <= rx;
	      i <= i+4'b1;
	   end
	end
     end

   assign ready = (i == 8 && rx);

endmodule
