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

    output reg o_DAC_DIN,
    output reg o_DAC_SCLK,
    output reg o_DAC_CS,
    output reg o_DAC_Done 
);

reg  [3:0]  r_CLK_Cnt;              //每处理一位数据内，的系统时钟计数器
reg  [4:0]  r_DAC_CLK_Cnt;          //0~16
reg  [3:0]  r_DAC_Din_Cnt;
wire [15:0] w_DAC_Din;

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
        r_CLK_Cnt <= 4'd0;
    else if(o_DAC_CS == 1'b0)begin
        if(r_CLK_Cnt == CLKS_PER_HALF_BIT*2-1)
            r_CLK_Cnt <= 4'd0;
        else
            r_CLK_Cnt <= r_CLK_Cnt + 4'd1;  
    end
    else
        r_CLK_Cnt <= 4'd0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_DAC_CLK_Cnt <= 5'd0;           
    else if((r_CLK_Cnt == CLKS_PER_HALF_BIT*2-1)&&(o_DAC_CS <= 1'b0))
        r_DAC_CLK_Cnt <= r_DAC_CLK_Cnt + 5'd1;
    else if((r_DAC_CLK_Cnt == 5'd16) && (r_CLK_Cnt == CLKS_PER_HALF_BIT*2-1))
        r_DAC_CLK_Cnt <= 5'd0; 
    else
        r_DAC_CLK_Cnt <= r_DAC_CLK_Cnt; 
end

//SCLK signal
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        o_DAC_SCLK <= 1'b0;
    else if(o_DAC_CS == 1'b0)begin
        o_DAC_SCLK <= 1'b0;
        if((r_CLK_Cnt == CLKS_PER_HALF_BIT - 1) || (r_CLK_Cnt == CLKS_PER_HALF_BIT*2 -1))
            o_DAC_SCLK <= ~o_DAC_SCLK;
    end
    else
        o_DAC_SCLK <= 1'b0;
end

//r_DAC_Din_Cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_DAC_Din_Cnt <= 4'd0;
    else if(o_DAC_CS == 1'b0) begin
        r_DAC_Din_Cnt <= 4'd15;
        if(r_CLK_Cnt == CLKS_PER_HALF_BIT*2-1)
            r_DAC_Din_Cnt <= r_DAC_Din_Cnt - 4'd1;
        else
            r_DAC_Din_Cnt <= r_DAC_Din_Cnt;
    end     
end

always @(*) begin
    if (o_DAC_CS == 1'b0)begin
        if(r_CLK_Cnt == CLKS_PER_HALF_BIT-1)
            o_DAC_DIN <= w_DAC_Din[r_DAC_Din_Cnt];
        else
            o_DAC_DIN <= o_DAC_DIN;
    end
    else
        o_DAC_DIN <= w_DAC_Din[4'd15];      
end

//o_DAC_DONE signal
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        o_DAC_Done <= 1'b0;
    else if((r_DAC_CLK_Cnt == 5'd16) && (r_CLK_Cnt == CLKS_PER_HALF_BIT-1))
        o_DAC_Done <= 1'b1;
    else
        o_DAC_Done <= 1'b0;        
end

endmodule //dac_ctrl