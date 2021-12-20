`timescale 1ns/1ps

module uart_byte_tx(
	clk,
	rst_n,
	i_TXD_Din,
	i_TXD_En,
	i_TXD_Baud,
	
	o_TXD_Tx,
	o_TXD_Done,
	o_TXD_State
);

	input clk;
	input rst_n;
	input [7:0]i_TXD_Din;
	input i_TXD_En;
	input [2:0]i_TXD_Baud;
	
	output reg o_TXD_Tx;
	output reg o_TXD_Done;
	output reg o_TXD_State;
	
	reg bps_clk;	//波特率时钟
	
	reg [15:0]div_cnt;//分频计数器
	
	reg [15:0]bps_DR;//分频计数最大值
	
	reg [3:0]bps_cnt;//波特率时钟计数器
	
	reg [7:0]r_data_byte;
	
	localparam START_BIT = 1'b0;
	localparam STOP_BIT = 1'b1;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_TXD_State <= 1'b0;
	else if(i_TXD_En)
		o_TXD_State <= 1'b1;
	else if(bps_cnt == 4'd11)
		o_TXD_State <= 1'b0;
	else
		o_TXD_State <= o_TXD_State;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_data_byte <= 8'd0;
	else if(i_TXD_En)
		r_data_byte <= i_TXD_Din;
	else
		r_data_byte <= r_data_byte;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		bps_DR <= 16'd5207;
	else begin
		case(i_TXD_Baud)
			0:bps_DR <= 16'd5207;
			1:bps_DR <= 16'd2603;
			2:bps_DR <= 16'd1301;
			3:bps_DR <= 16'd867;
			4:bps_DR <= 16'd433;
			default:bps_DR <= 16'd5207;			
		endcase
	end	
	
	//counter
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		div_cnt <= 16'd0;
	else if(o_TXD_State)begin
		if(div_cnt == bps_DR)
			div_cnt <= 16'd0;
		else
			div_cnt <= div_cnt + 1'b1;
	end
	else
		div_cnt <= 16'd0;
	
	// bps_clk gen
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		bps_clk <= 1'b0;
	else if(div_cnt == 16'd1)
		bps_clk <= 1'b1;
	else
		bps_clk <= 1'b0;
	
	//bps counter
	always@(posedge clk or negedge rst_n)
	if(!rst_n)	
		bps_cnt <= 4'd0;
	else if(bps_cnt == 4'd11)
		bps_cnt <= 4'd0;
	else if(bps_clk)
		bps_cnt <= bps_cnt + 1'b1;
	else
		bps_cnt <= bps_cnt;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_TXD_Done <= 1'b0;
	else if(bps_cnt == 4'd11)
		o_TXD_Done <= 1'b1;
	else
		o_TXD_Done <= 1'b0;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_TXD_Tx <= 1'b1;
	else begin
		case(bps_cnt)
			0:o_TXD_Tx <= 1'b1;
			1:o_TXD_Tx <= START_BIT;
			2:o_TXD_Tx <= r_data_byte[0];
			3:o_TXD_Tx <= r_data_byte[1];
			4:o_TXD_Tx <= r_data_byte[2];
			5:o_TXD_Tx <= r_data_byte[3];
			6:o_TXD_Tx <= r_data_byte[4];
			7:o_TXD_Tx <= r_data_byte[5];
			8:o_TXD_Tx <= r_data_byte[6];
			9:o_TXD_Tx <= r_data_byte[7];
			10:o_TXD_Tx <= STOP_BIT;
			default:o_TXD_Tx <= 1'b1;
		endcase
	end	

endmodule
