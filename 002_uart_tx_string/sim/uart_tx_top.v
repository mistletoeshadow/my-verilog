`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:05:18 09/02/2021
// Design Name:   uart_tx_top
// Module Name:   E:/FPGA/my.verilog.learn/uart_all/uart_tx_string/sim/tb/uart_tx_top.v
// Project Name:  uart_tx_string
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tx_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_tx_top;

	// Inputs
	reg clk;
	reg rst_n;
	reg key_in0;

	// Outputs
	wire tx;
	wire led;

	// Instantiate the Unit Under Test (UUT)
	uart_tx_top uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.tx(tx), 
		.key_in0(key_in0), 
		.led(led)
	);

	initial clk =1;
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		
		rst_n = 0;
		key_in0 = 1'b1;

		// Wait 100 ns for global reset to finish
		#100;
		rst_n = 1;
		key_in0 = 1'b0;
		#1000000000;
		$stop;
        
	
	end
      
endmodule

