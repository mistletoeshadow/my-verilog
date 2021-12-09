`timescale 1ns / 1ns
module dac_ctrl
    #(parameter CLKS_PER_HALF_BIT = 5)
(
    input         clk,
    input         rst_n,
    input         i_DAC_en,
    input  [11:0] i_DAC_Code,       //News data
    input  [1:0]  i_DAC_RS,         //register-select bits       
    input         i_DAC_SPD,        //1--> fast mode;  0--> slow mode
    input         i_DAC_PWR,        //1--> power down; 0--> normal operation

    output reg    o_DAC_DIN,        //先从MSB发送
    output reg    o_DAC_SCLK,
    output reg    o_DAC_CS,
    output reg    o_DAC_Done 
);

wire [15:0] w_DAC_Din;
reg  [3:0]  r_BIT_cnt;
reg  [5:0]  r_lsm_cnt;

//data format
assign w_DAC_Din = {i_DAC_RS[1],i_DAC_SPD,i_DAC_PWR,i_DAC_RS[0],i_DAC_Code};

//dac_cs signal
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        o_DAC_CS <= 1'b1;
    else if(i_DAC_en)
        o_DAC_CS <= 1'b0;
    else if(o_DAC_Done == 1'b1)
        o_DAC_CS <= 1'b1;
    else
        o_DAC_CS <= o_DAC_CS;       
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_BIT_cnt <= 4'd0;
    else if(o_DAC_CS == 1'b0) begin
        if(r_BIT_cnt == CLKS_PER_HALF_BIT - 1)
            r_BIT_cnt <= 4'd0;
        else
            r_BIT_cnt <= r_BIT_cnt + 1;
    end
    else   
        r_BIT_cnt <= 4'd0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_lsm_cnt <= 6'd0;
    else if(r_BIT_cnt == CLKS_PER_HALF_BIT -1)
        r_lsm_cnt <= r_lsm_cnt + 6'd1;
    else if(o_DAC_CS == 1'b1) 
        r_lsm_cnt <= 6'd0;
    else
        r_lsm_cnt <= r_lsm_cnt;   
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        o_DAC_SCLK <= 1'b0;
        o_DAC_DIN  <= 1'b0;
        o_DAC_Done <= 1'b0;
    end
    else if((r_BIT_cnt == CLKS_PER_HALF_BIT -1) || (r_BIT_cnt == CLKS_PER_HALF_BIT*2 -1))begin
        case (r_lsm_cnt)
            0:begin o_DAC_SCLK <= 1'b0;o_DAC_DIN  <= 1'b0;o_DAC_Done <= 1'b0;end
            1:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[15];end
            2:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[15];end
            3:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[14];end
            4:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[14];end
            5:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[13];end
            6:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[13];end
            7:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[12];end
            8:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[12];end
            9:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[11];end
            10:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[11];end
            11:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[10];end
            12:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[10];end
            13:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[9];end
            14:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[9];end
            15:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[8];end
            16:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[8];end
            17:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[7];end
            18:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[7];end
            19:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[6];end
            20:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[6];end
            21:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[5];end
            22:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[5];end
            23:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[4];end
            24:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[4];end
            25:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[3];end
            26:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[3];end
            27:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[2];end
            28:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[2];end
            29:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[1];end
            30:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[1];end
            31:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[0];end
            32:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= w_DAC_Din[0];end
            33:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_DIN  <= 1'b0;end
            34:begin o_DAC_SCLK <= ~o_DAC_SCLK;o_DAC_Done <= 1'b1;end
        endcase
    end
    else begin
        o_DAC_SCLK <= o_DAC_SCLK;
        o_DAC_DIN  <= o_DAC_DIN;
        o_DAC_Done <= 1'b0;
    end
            
end
endmodule