///////////////////////////////////////////////////////////////////////////////
// Description: ADC128S052_Diver
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
module adc_ctrl 
    #(parameter CLKS_PER_HALF_BIT = 5)
(
    input               clk,
    input               rst_n,
    input  [2:0]        i_ADC_addr,
    input               i_ADC_Dout,
    input               i_ADC_En,

    output reg          o_ADC_SCLK,
    output reg          o_ADC_CS,
    output reg          o_ADC_Din,
    output reg [11:0]   o_ADC_Dout,
    output reg          w_ADC_Dout,     //引出用于仿真
    output reg          o_ADC_Done
);

reg  [5:0]  r_ADC_Cnt;
reg  [3:0]  r_ADC_bit_Cnt;
reg  [11:0] r_ADC_Dout;
reg         r_ADC_Dout_flag;

//o_ADC_CS signal
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        o_ADC_CS <= 1'b1;
    else if(i_ADC_En == 1'b1)
        o_ADC_CS <= 1'b0;
    else if((r_ADC_Cnt == 6'd34)&&(r_ADC_bit_Cnt == CLKS_PER_HALF_BIT-1))
        o_ADC_CS <= 1'b1;
    else
        o_ADC_CS <= o_ADC_CS;    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_ADC_bit_Cnt <= 4'd0;
    else if(o_ADC_CS == 1'b0) begin
        if(r_ADC_bit_Cnt == CLKS_PER_HALF_BIT*2-1)
            r_ADC_bit_Cnt <= 4'd0;
        else
            r_ADC_bit_Cnt <= r_ADC_bit_Cnt + 4'd1;
    end 
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_ADC_Cnt <= 6'd0;
    else if((r_ADC_bit_Cnt == CLKS_PER_HALF_BIT*2-1) || (r_ADC_bit_Cnt == CLKS_PER_HALF_BIT-1))
        r_ADC_Cnt <= r_ADC_Cnt + 6'd1;
    else if((r_ADC_Cnt == 6'd34)&&(r_ADC_bit_Cnt == CLKS_PER_HALF_BIT*2-2))
        r_ADC_Cnt <= 6'd0;
    else
        r_ADC_Cnt <= r_ADC_Cnt;           
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        r_ADC_Cnt  <= 6'd0;
        o_ADC_Dout <= 12'd0;
    end
    else begin
//        o_ADC_SCLK <= 1'b1;
        case (r_ADC_Cnt)
            0: begin o_ADC_SCLK <= 1'b1; w_ADC_Dout = 1'b0;end
            2: o_ADC_SCLK <= 1'b0;
            3: o_ADC_SCLK <= 1'b1;
            4: o_ADC_SCLK <= 1'b0;
            5: o_ADC_SCLK <= 1'b1;
            6: begin o_ADC_SCLK <= 1'b0; o_ADC_Din <= i_ADC_addr[2]; end
            7: o_ADC_SCLK <= 1'b1;
            8: begin o_ADC_SCLK <= 1'b0; o_ADC_Din <= i_ADC_addr[1]; end
            9: o_ADC_SCLK <= 1'b1;
            10: begin o_ADC_SCLK <= 1'b0; o_ADC_Din <= i_ADC_addr[0]; 
                      w_ADC_Dout = 1'b1;
                end
            11: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[11] <= i_ADC_Dout;end
            12: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b1;
                end
            13: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[10] <= i_ADC_Dout;end
            14: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            15: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[9] <= i_ADC_Dout;end
            16: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b1;
                end
            17: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[8] <= i_ADC_Dout;end
            18: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b1;
                end
            19: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[7] <= i_ADC_Dout;end
            20: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            21: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[6] <= i_ADC_Dout;end
            22: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            23: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[5] <= i_ADC_Dout;end
            24: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b1;
                end
            25: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[4] <= i_ADC_Dout;end
            26: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            27: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[3] <= i_ADC_Dout;end
            28: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            29: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[2] <= i_ADC_Dout;end
            30: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b0;
                end
            31: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[1] <= i_ADC_Dout;end
            32: begin o_ADC_SCLK <= 1'b0;
                      w_ADC_Dout = 1'b1;
                end
            33: begin o_ADC_SCLK <= 1'b1;r_ADC_Dout[0] <= i_ADC_Dout;end
            34: o_ADC_SCLK <= 1'b0;
        endcase
    end
end 

    //r_ADC_Dout_flag signal
  always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            r_ADC_Dout_flag <= 1'b0;
        else if((r_ADC_Cnt == 6'd33) && (r_ADC_bit_Cnt == CLKS_PER_HALF_BIT))
            r_ADC_Dout_flag <= 1'b1;
        else
            r_ADC_Dout_flag <=1'b0;        
  end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            o_ADC_Din <= 12'd0;
        else if(r_ADC_Dout_flag == 1'b1)
            o_ADC_Dout <= r_ADC_Dout;   
    end

    //o_ADC_Done signal
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            o_ADC_Done <= 1'b0;
        else if((r_ADC_Cnt == 6'd34)&&(r_ADC_bit_Cnt == 1))
            o_ADC_Done <= 1'b1;
        else
            o_ADC_Done <= 1'b0;    
    end
endmodule