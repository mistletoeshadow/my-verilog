`timescale 1ns / 1ns
`define clk_period 20
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:22:15 08/26/2021
// Design Name:   key_fliter
// Module Name:   E:/FPGA/my.verilog.learn/key_fliter/sim/tb/key_fliter_tb.v
// Project Name:  key_fliter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: key_fliter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module key_fliter_tb;

	// Inputs
	reg clk;
	reg rst_n;
	reg key_in;

	// Outputs
	wire key_state;
	wire key_flag;

	// Instantiate the Unit Under Test (UUT)
	key_fliter uut0 (
		.clk(clk), 
		.rst_n(rst_n), 
		.key_in(key_in), 
		.key_state(key_state), 
		.key_flag(key_flag)
	);


	initial clk = 1;
	always #(`clk_period/2) clk = ~clk;

	initial begin
		// Initialize Inputs
		//clk = 0;
		rst_n = 0;
		key_in = 1'b1;
		#(`clk_period * 10) rst_n = 1'b1;
		#(`clk_period * 10 + 1);

		press_key;
		#10000;
		press_key;
		#10000;
		press_key;
		#10000;
		press_key;
		$stop;
	end
	
		reg [15:0] myrand;

		task press_key;
			begin
				repeat (50)begin
					myrand = {$random}%65536; 	//0到65535之间
					#myrand key_in = ~key_in;
				end
				key_in = 0;
				#50000000;

				repeat (50)begin
					myrand = {$random}%65536; 	//0到65535之间
					#myrand key_in = ~key_in;
				end
				key_in = 1;
				#50000000;
			end
		endtask
	
      
endmodule

