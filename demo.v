`define CLKFREQ   12000000

module top(input  CLK,  output TXD,  input  RXD,
	   output LED0, output LED1, output LED2, output LED3, output LED4,
	   output PIN1, input  PIN2  );


   reg 	      send = 0;
   reg [7:0]  tx_char = 8'b0;
   wire	      tx_busy;

   wire [7:0] rx_char;
   wire       rx_ready;

   assign LED2 = tx_busy;
   assign LED4 = rx_ready;
   assign LED1 = send;

   uart_tx uart_tx0(.clk(CLK), .send(send)     , .data(tx_char), .busy(tx_busy), .tx(TXD));
   uart_rx uart_rx0(.clk(CLK), .ready(rx_ready), .data(rx_char),                 .rx(RXD));

   always @(posedge tx_busy or posedge CLK) begin
      if (tx_busy) begin
	 send <= 0;
      end else begin
	 if (rx_ready) begin
	    tx_char <= rx_char ^ 8'h20;
	    send <= 1;
	 end
      end
   end


   reg [23:0] sec_clk = 0;
   reg [1:0]  led = 1;

   assign LED0 = 1;
   //assign LED1 = led[0];
   //assign LED3 = led[1];

   always @(posedge CLK)
     begin
	if (sec_clk == `CLKFREQ) begin
	   sec_clk <= 0;
	   led <= ~led;
	end else
	  sec_clk <= sec_clk + 1;
     end

   assign PIN1 = PIN2;
endmodule
