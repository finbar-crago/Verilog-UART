`timescale 1 s / 1 ns

module uart__tb;
   reg        clk = 0;

   reg        send = 0;
   reg [7:0]  char = 8'd40;
   wire       busy;
   wire       tx;

   wire       ready;
   wire [7:0] data;

   wire       ready2;
   wire [7:0] data2;
   reg 	      rx = 1;

   initial begin
      $dumpfile("dump.out");
      $dumpvars(0, uart__tb);

      #(1e-5) send = 1;
      #(1e-5) send = 1;
      #(2e-5) send = 1;

      #(1e-5)   rx = 0;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;

      #(1e-5)   rx = 0;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 0;

      #(8.6e-7) rx = 0;
      #(8.6e-7) rx = 1;

      #(1e-4) $finish;
   end

   always #(1/(1.2e+8)/2) clk = ~clk;

   always @(negedge busy) send <= 0;
   always @(posedge ready)
     char <= char [7:0] + 8'd1;

   uart_tx uart_tx0(.clk(clk),   .send(send) , .data(char), .busy(busy), .tx(tx));
   uart_rx uart_rx0(.clk(clk), .ready(ready),  .data(data),              .rx(tx));

   uart_rx uart_rx1(.clk(clk), .ready(ready2),  .data(data2),             .rx(rx));

endmodule
