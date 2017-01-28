`define CLKFREQ   12000000

module top(input  CLK,  output TXD,  input  RXD,
	   output LED0, output LED1, output LED2, output LED3, output LED4,
	   output PIN1, input  PIN2  );

   reg [23:0] sec_clk = 0;
   reg [1:0]  led = 1;

   wire       uart_tx;
   wire       uart_rx;

   reg 	      send = 1;
   reg [6:0]  char = 7'h20;
   wire	      tx_busy;

   uart_tx uart_tx0(.clk(CLK), .send(send), .data({1'b0, char}), .busy(tx_busy), .tx(TXD));
 
   always @(posedge CLK) begin
      if (tx_busy) send <= 0;

      if (sec_clk == `CLKFREQ) begin
	 sec_clk <= 0;
	 led <= ~led;

	 if (!tx_busy) begin
	    char <= char + 1;
	    send <= 1;
	 end

      end else sec_clk <= sec_clk + 1;
   end

   assign LED0 = 1;
   assign LED1 = led[0];
   assign LED3 = led[1];

   assign LED2 = 0;
   assign LED4 = 0;
endmodule
