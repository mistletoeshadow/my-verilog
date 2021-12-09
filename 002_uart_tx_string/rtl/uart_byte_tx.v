`timescale 1ns/1ps

module uart_byte_tx(
	clk,
	rst_n,
	data_byte,
	send_en,
	baud_set,
	
	tx,
	tx_done,
	uart_state
);

	input clk;
	input rst_n;
	input [7:0]data_byte;
	input send_en;
	input [2:0]baud_set;
	
	output reg tx;
	output reg tx_done;
	output reg uart_state;
	
	reg bps_clk;	//波特率时钟
	
	reg [15:0]div_cnt;//分频计数器
	
	reg [15:0]bps_DR;//分频计数最大值
	
	reg [3:0]bps_cnt;//波特率时钟计数器
	
	reg [7:0]r_data_byte;
	
	localparam START_BIT = 1'b0;
	localparam STOP_BIT = 1'b1;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		uart_state <= 1'b0;
	else if(send_en)
		uart_state <= 1'b1;
	else if(bps_cnt == 4'd11)
		uart_state <= 1'b0;
	else
		uart_state <= uart_state;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_data_byte <= 8'd0;
	else if(send_en)
		r_data_byte <= data_byte;
	else
		r_data_byte <= r_data_byte;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		bps_DR <= 16'd5207;
	else begin
		case(baud_set)
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
	else if(uart_state)begin
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
		tx_done <= 1'b0;
	else if(bps_cnt == 4'd11)
		tx_done <= 1'b1;
	else
		tx_done <= 1'b0;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		tx <= 1'b1;
	else begin
		case(bps_cnt)
			0:tx <= 1'b1;
			1:tx <= START_BIT;
			2:tx <= r_data_byte[0];
			3:tx <= r_data_byte[1];
			4:tx <= r_data_byte[2];
			5:tx <= r_data_byte[3];
			6:tx <= r_data_byte[4];
			7:tx <= r_data_byte[5];
			8:tx <= r_data_byte[6];
			9:tx <= r_data_byte[7];
			10:tx <= STOP_BIT;
			default:tx <= 1'b1;
		endcase
	end	

endmodule
