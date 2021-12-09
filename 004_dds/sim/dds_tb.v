`timescale 1ns / 1ns
`define clk_period 20

module dds_tb;

    reg clk;
    reg rst_n;
    reg [31:0] k;
    //reg [11:0] p;
    reg en;

    wire [7:0] f_out;

    DDS u_dds(
    .clk(clk),
    .rst_n(rst_n),
    .k(k),
    .en(en),
    .f_out(f_out) 
    );

    initial clk =1;
        always#(`clk_period/2) clk = ~clk;
    

    initial begin
        rst_n    = 0;
        k       <= 0;
        //p       = 0;
        en      <= 0; 
        #(`clk_period*20 + 1)
        en      <= 1;
        rst_n   <= 1;


        k       <= 32'd30000;
        #(`clk_period*2000_000)  
        k       <= 32'd60000;
        #(`clk_period*2000_000)        
        k       <= 32'd120000;
        #(`clk_period*2000_000) 

        k       <= 32'd2_147_483_648;
        #(`clk_period*10)       

        $stop;
    end

endmodule
