`timescale 1ns / 1ns

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:25 08/26/2021 
// Design Name: 
// Module Name:    key_model 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module key_model(key);
    
    output reg key;

    reg [15:0] myrand;

    initial begin
		key = 1'b1;
		press_key;
		#10000;
		press_key;
		#10000;
		press_key;
		#10000;
		press_key;
		$stop;
	end

	task press_key;
		begin
			repeat (50)begin
				myrand = {$random}%65536; 	//0到65535之间
				#myrand key = ~key;
			end
			key = 0;
			#50000000;
			repeat (50)begin
				myrand = {$random}%65536; 	//0到65535之间
				#myrand key = ~key;
			end
			key = 1;
			#50000000;
		end
	endtask

endmodule
