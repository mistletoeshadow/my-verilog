`timescale 1ns / 1ns
`define clk_period 5
module dac_ctrl_tb();

    reg         clk;
    reg         rst_n;
    reg         i_DAC_en;
    reg [11:0]  i_DAC_Code;
    reg [1:0]   i_DAC_RS;  
    reg         i_DAC_SPD; 
    reg         i_DAC_PWR; 
    wire        o_DAC_DIN;
    wire        o_DAC_SCLK;
    wire        o_DAC_CS;
    wire        o_DAC_Done;

dac_ctrl dac_ctrl_u(
    .clk(clk),
    .rst_n(rst_n),
    .i_DAC_en(i_DAC_en),
    .i_DAC_Code(i_DAC_Code),
    .i_DAC_RS(i_DAC_RS),  
    .i_DAC_SPD(i_DAC_SPD), 
    .i_DAC_PWR(i_DAC_PWR), 
    .o_DAC_DIN(o_DAC_DIN),
    .o_DAC_SCLK (o_DAC_SCLK),
    .o_DAC_CS(o_DAC_CS),
    .o_DAC_Done(o_DAC_Done)
);

initial clk = 1'b1;
    always#(`clk_period/2) clk = ~clk;

initial begin
    rst_n = 0;
    i_DAC_en = 0;
    i_DAC_Code = 12'd0;
    i_DAC_RS   = 2'b11; 
    i_DAC_SPD  = 1'b1;
    i_DAC_PWR  = 1'b0;
    #(`clk_period);
    rst_n       =  1;
    i_DAC_en    =  1'b1;
    i_DAC_Code  =  12'b1100_1001_1011;
    #(`clk_period*2)
    i_DAC_en    = 1'b0;
    #(`clk_period * 200);
    $stop;
end
endmodule
