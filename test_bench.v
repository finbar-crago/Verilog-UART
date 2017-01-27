`timescale 1 s / 1 ns

module test;
   reg clk = 0;
   reg send = 0;
   reg [7:0] char = 8'h40;
   wire      busy;
   wire      tx;

   initial begin
      $dumpfile("dump.out");
      $dumpvars(0, test);

      #0 send = 1;
      #0.0005 $finish;
   end

   always #(1/(1.2e+8)/2) clk = ~clk;
   uart uart0(.clk(clk), .send(send), .data(char), .busy(busy), .tx(tx));
endmodule   
