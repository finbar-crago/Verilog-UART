`timescale 1 s / 1 ns

module uart__tb;
   reg        clk = 0;

   reg        send = 0;
   reg [7:0]  char = 8'd42;
   wire       busy;
   wire       tx;

   wire       ready;
   wire [7:0] data;
   reg 	      rx;

   initial begin
      $dumpfile("dump.out");
      $dumpvars(0, uart__tb);

      #0 send = 1;
      #0.0005 $finish;
   end

   always #(1/(1.2e+8)/2) clk = ~clk;

   uart_tx uart_tx0(.clk(clk),  .send(send) , .data(char), .busy(busy), .tx(tx));
   uart_rx uart_rx0(.clk(clk), .ready(ready), .data(data), .rx(tx));
endmodule   
