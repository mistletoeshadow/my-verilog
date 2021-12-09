`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:53:56 08/25/2021 
// Design Name: 
// Module Name:    key_fliter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//当消抖之后，key_flag抬高一个周期，通知外部，可以读取key_state了
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module key_fliter(
    input clk,
    input rst_n,
    input key_in,

    output reg key_state, 
    output reg key_flag
    );

    localparam 
        IDEL        = 4'b0001,    
        key_nedge   = 4'b0010,
        DOWN        = 4'b0100,
        key_pedge   = 4'b1000;

    reg [3:0] state;
    reg key_tmp0,key_tmp1;

    reg [19:0] cnt;
    reg en_cnt;
    reg cnt_full;

    wire pedge,nedge;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            key_tmp0 <= 1'b0;
            key_tmp1 <= 1'b0;
        end
        else begin
            key_tmp0 <= key_in;
            key_tmp1 <= key_tmp0;
        end               
    end

    assign nedge = !key_tmp0 & key_tmp1;
    assign pedge = !key_tmp1 & key_tmp0;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 20'd0;
        else if(en_cnt)
            cnt <= cnt +1'd1;
        else
            cnt <= 20'd0;       
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_full <= 1'b0;
        else if(cnt == 20'd999_999)
            cnt_full <= 1'b1;
        else
            cnt_full <= 1'b0;       
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            state <= IDEL;
            key_flag <= 1'b0;
            en_cnt <= 1'b0;
        end
        else begin
            case (state)
                IDEL : 
                    begin
                        key_flag <= 1'b0;
                        if(nedge)begin
                            state <= key_nedge;
                            en_cnt <= 1'b1;
                        end                            
                        else
                            state <= IDEL;            
                    end

                key_nedge:
                    begin
                        if (cnt_full) begin
                            key_flag <= 1'b1;
                            key_state <= 1'b0;
                            state <= DOWN;
                            en_cnt <=1'b0;
                        end       
                        else if (pedge)begin
                            state <= IDEL;
                            en_cnt <= 1'b0; 
                        end
                        else
                            state <= key_nedge;       
                    end

                DOWN:
                    begin
                        key_flag <= 1'b0;
                        if(pedge)begin
                            state <= key_pedge;
                            en_cnt <= 1'b1;
                        end
                        else
                            state <= DOWN;

                    end

                key_pedge:
                    begin
                        if(cnt_full)begin
                            state <= IDEL;
                            key_flag <= 1'b1;
                            key_state <= 1'b1;
                        end
                        else if(nedge)begin
                            en_cnt <= 1'b0;
                            state <= DOWN;
                        end
                        else
                            state <= key_pedge;       
                    end

                default:
                    begin
                        state <= IDEL;
                        en_cnt <= 1'b0;
                        key_flag <= 1'b0;
                        key_state <= 1'b1;
                    end
                    
            endcase
        end
            
    end

endmodule
