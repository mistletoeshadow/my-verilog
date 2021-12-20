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
		.i_TXD_Din(data_byte),
		.i_TXD_En(send_en),
		.i_TXD_Baud(3'd0),
		
		.o_TXD_Tx(tx),
		.o_TXD_Done(tx_done),
		.o_TXD_State(led)
	);
	
	key_filter key_filter0(
		.clk(clk),
		.rst_n(rst_n),
		.i_Key(key_in0),
		.o_KEY_flag(key_flag0),
		.o_KEY_State(key_state0)
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
