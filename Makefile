export IVERILOG_DUMPER:=lxt2

all:
	yosys -q -p "synth_ice40 -blif build/uart_demo.blif" uart.v demo.v
	arachne-pnr -d 1k -P tq144 -p icestick.pcf -o build/uart_demo.txt build/uart_demo.blif
	icepack build/uart_demo.txt build/uart_demo.bin

flash:
	iceprog build/uart_demo.bin

test:
	iverilog -o build/uart_test_bench -Wall -g1 uart.v test_bench.v
	cd build && ./uart_test_bench

gtkwave:
	gtkwave build/dump.out

clean:
	rm -f build/* *~
