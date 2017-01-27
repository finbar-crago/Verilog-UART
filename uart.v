`timescale 1ns / 1ps

module uart
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
