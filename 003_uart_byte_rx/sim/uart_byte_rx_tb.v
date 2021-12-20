/*
descripe:
该仿真文件思路：
X_reg[7:0] => uart_byte_tx.i_TX_Din;
i_TXD_Din ---> o_TXD_Dout--->
--->i_RX_Din  ---> o_RXD_Dout
*/
`timescale 1ns/1ns			//时间精度
`define clk_period 20		//相当于宏定义

module uart_byte_rx_tb;

	reg clk;
	reg rst_n;
	reg Rs232_Rx;
	
	wire [7:0]o_RXD_Dout;
	wire o_RXD_Done;	
	
	reg [7:0]i_TXD_Din;
	reg i_TXD_En;
	reg [2:0]i_RTX_Baud;
	
	wire o_TXD_Tx;
	wire o_TXD_Done;
	wire o_TXD_State;
	
	uart_byte_rx uart_byte_rx(
		.clk(clk),
		.rst_n(rst_n),
		.i_RXD_Baud(i_RTX_Baud),
		.i_RXD_Rx(o_TXD_Tx),
		
		.o_RXD_Dout(o_RXD_Dout),
		.o_RXD_Done(o_RXD_Done)
	);
	
	uart_byte_tx uart_byte_tx(
		.clk(clk),
		.rst_n(rst_n),
		.i_TXD_Din(i_TXD_Din),
		.i_TXD_En(i_TXD_En),
		.i_TXD_Baud(i_RTX_Baud),
		
		.o_TXD_Tx(o_TXD_Tx),
		.o_TXD_Done(o_TXD_Done),
		.o_TXD_State(o_TXD_State)
	);

	//模拟出50MHz的频率
	initial clk = 1;
	always#(`clk_period/2)clk = ~clk;
	
	initial begin
		
		//初始化
		rst_n = 1'b0;
		i_TXD_Din = 8'd0;
		i_TXD_En = 1'd0;
		i_RTX_Baud = 3'd4;			//115200bps
		#(`clk_period*20 + 1 );		//＋1  用于与系统时钟错位开 
		
		rst_n = 1'b1;
		#(`clk_period*50);
		i_TXD_Din = 8'haa;
		i_TXD_En = 1'd1;
		#`clk_period;
		i_TXD_En = 1'd0;
		
		@(posedge o_TXD_Done)			//等待Tx_Done信号的上升沿
		
		#(`clk_period*5000);
		i_TXD_Din = 8'h55;
		i_TXD_En = 1'd1;
		#`clk_period;
		i_TXD_En = 1'd0;
		@(posedge o_TXD_Done)
		#(`clk_period*5000);
		$stop;	
	end
endmodule


