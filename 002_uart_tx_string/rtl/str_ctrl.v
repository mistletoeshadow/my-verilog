`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:19:20 08/27/2021 
// Design Name: 
// Module Name:    str_ctrl 
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
module str_ctrl(
    input clk,
    input rst_n,
    input key_state,
    input key_flag,
    input tx_done,

    output reg[7:0] data_tx,
    output reg send_en
    
    );

    //想要发送的一串字符为“hello,nuaa!”
    localparam 
        str_0  = "h",
        str_1  = "e",
        str_2  = "l",
        str_3  = "l",
        str_4  = "o",
        str_5  = ",",
        str_6  = "n",
        str_7  = "u",
        str_8  = "a",
        str_9  = "a",

        //回车换行
        str_10 = "\r",
        str_11 = "\n";  

    
    reg [3:0] cnt; 

    //cnt
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 4'd0;     
        else if(tx_done) 
            cnt <= cnt + 4'd1;
        else if(key_flag & !key_state)
            cnt <= 4'd0;
    end   

    //send_en_control
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            send_en <= 1'b0;
        else if(key_flag & !key_state)
            send_en <= 1'b1;
        else if(tx_done & (cnt < 4'd10))
            send_en <= 1'b1;
        else
            send_en <= 1'b0;
    end
            


    //data_tx_control
    always @(*) begin
        
        case (cnt)
            4'd0 : data_tx = str_0;
            4'd1 : data_tx = str_1;
            4'd2 : data_tx = str_2;
            4'd3 : data_tx = str_3;
            4'd4 : data_tx = str_4;
            4'd5 : data_tx = str_5;
            4'd6 : data_tx = str_6;
            4'd7 : data_tx = str_7; 
            4'd8 : data_tx = str_8;
            4'd9 : data_tx = str_9;
            4'd10: data_tx = str_10;
            4'd11: data_tx = str_11;
            default 
                : data_tx = 0;
        endcase
    end

endmodule
