`timescale 1ns/1ps

module uart_tx_top(clk,rst_n,tx,key_in0,led);

	input clk;
	input rst_n;
	input key_in0;
	
	output tx;
	output led;
	
	wire send_en;
	wire [7:0]data_byte;
	wire key_flag0;
	wire key_state0;

	//parameter data = 8'h7a;

	//assign data_byte = data;
	
	//assign send_en = key_flag0 & !key_state0;
	
	uart_byte_tx uart_byte_tx(
		.clk(clk),
		.rst_n(rst_n),
		.data_byte(data_byte),
		.send_en(send_en),
		.baud_set(3'd0),
		
		.tx(tx),
		.tx_done(tx_done),
		.uart_state(led)
	);
	
	key_filter key_filter0(
		.clk(clk),
		.rst_n(rst_n),
		.key_in(key_in0),
		.key_flag(key_flag0),
		.key_state(key_state0)
	);

	str_ctrl u_str_ctrl(
		.clk(clk),
		.rst_n(rst_n),
		.key_state(key_state0),
		.key_flag(key_flag0),
		.tx_done(tx_done),
 		.data_tx(data_byte),
 		.send_en(send_en)

	);
	
//	issp issp(
//		.probe(),
//		.source(data_byte)
//	);
	

endmodule
