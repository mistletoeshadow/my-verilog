`timescale 1ns / 1ns
`define clk_period 5
module adc_ctrl_tb ();

reg         clk;
reg         rst_n;
reg [2:0]   i_ADC_addr;
reg         i_ADC_Dout;
reg         i_ADC_En;
wire        o_ADC_SCLK;
wire        o_ADC_CS;
wire        o_ADC_Din;
wire [11:0] o_ADC_Dout;
wire        o_ADC_Done;
wire        w_ADC_Dout;

adc_ctrl adc_ctrl_u(
    .clk(clk),
    .rst_n(rst_n),
    .i_ADC_addr(i_ADC_addr),
    .i_ADC_Dout(w_ADC_Dout),
    .i_ADC_En(i_ADC_En),
    .o_ADC_SCLK(o_ADC_SCLK),
    .o_ADC_CS(o_ADC_CS),
    .o_ADC_Din(o_ADC_Din),
    .o_ADC_Dout(o_ADC_Dout),
    .w_ADC_Dout(w_ADC_Dout),
    .o_ADC_Done(o_ADC_Done)
);

initial clk = 1'b1;
    always#(`clk_period/2) clk = ~clk;

    initial begin
    rst_n = 0;
    i_ADC_addr = 3'b101;
    i_ADC_Dout = 12'd0;
    i_ADC_En   = 1'b0;
//    i_ADC_Dout = 12'b1101_1001_0011;
    #(`clk_period);
    rst_n       =  1;
    #(`clk_period);
    i_ADC_En   = 1'b1;
    #(`clk_period);
    i_ADC_En   = 1'b0;
    #(`clk_period * 2000);
    $stop;
end

endmodule //adc_ctrl_tb