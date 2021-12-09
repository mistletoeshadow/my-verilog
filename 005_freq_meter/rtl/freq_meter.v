`timescale 1ns / 1ns

module freq_meter(
    input clk,              //200MHz~5ns
    input rst_n,
    input clk_test,
    input en,

    output reg [31:0] clk_freq
    );

    parameter CNT_025 = 29'd50_000_000;
    parameter CNT_1s  = 29'd250_000_000;
    parameter CNT_150 = 29'd300_000_000;

    parameter sys_clk_freq = 100_000_000;


    reg gate_s;                 //软件闸门，基于sys_clk;
    reg gate_a;                 //实际闸门，基于clk_test;
    reg [28:0] cnt_gate_s;      //29位即可，计数最大值为300_000_000

    reg [31:0] cnt_clk;         //实际闸门下，对clk进行计数；
    reg [31:0] cnt_clk_test;    //实际闸门下，对clk_test进行计数；

    reg gate_a_s;               //用于产生在系统时钟下的实际闸门下降沿信号
    reg gate_a_t;               //用于产生在测试时钟下的实际闸门下降沿信号
    wire negedge_s;             //系统时钟下的实际闸门下降沿信号
    wire negedge_t;             //测试时钟下的实际闸门下降沿信号

    reg [31:0] cnt_clk_reg;     //用于寄存cnt_clk的计数值；Y
    reg [31:0] cnt_clk_test_reg;//用于寄存cnt_clk_test的计数值；X

    reg clac_flag;              //计算标志信号
    reg [63:0] freq_reg;        //用于存储计算得出的频率值

    reg freq_flag;
 

    //软件闸门计时器
    always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_gate_s <= 29'd0;
    else if(cnt_gate_s <= CNT_150)
        cnt_gate_s <= cnt_gate_s + 1'b1;
    else
        cnt_gate_s <= 29'd0;
        
    end
   
    //生成软件闸门
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            gate_s <= 1'b0;
        else if (en == 1'b1) begin
            if(cnt_gate_s <=CNT_025)
                gate_s <= 1'b0;
            else if((cnt_gate_s >= CNT_025 + 1)&&(cnt_gate_s <= CNT_1s))
                gate_s <= 1'b1;
            else if(cnt_gate_s >= CNT_1s)
                gate_s <= 1'b0;
        end 
        else
            gate_s <= 1'b0;         
    end

    //生成实际闸门
    always @(posedge clk_test or negedge rst_n) begin
    if(!rst_n)
        gate_a <= 1'b0;
    else
        gate_a <= gate_s;
    end

    //在实际闸门下，对clk和clk_test分别进行计数
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_clk <= 32'd0;
        else if(gate_a == 1'b1)
            cnt_clk <= cnt_clk +32'd1;
        else if(clac_flag == 1'b1)
            cnt_clk <= 32'd0;   
    end

    always @(posedge clk_test or negedge rst_n) begin
        if(!rst_n)
            cnt_clk_test <= 32'd0;
        else if(gate_a == 1'b1)
            cnt_clk_test <= cnt_clk_test + 32'd1;
        else if(clac_flag == 1'b1)
            cnt_clk_test <= 32'd0;
        else
            cnt_clk_test <= cnt_clk_test;
    end

    //产生实际闸门在系统时钟下的下降沿信号
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            gate_a_s <= 1'b0;
        else
            gate_a_s <= gate_a;
    end
    assign negedge_s = (~gate_a)&&gate_a_s;

    //产生实际闸门在测试时钟下的下降沿信号
    always @(posedge clk_test or negedge rst_n) begin
        if(!rst_n)
            gate_a_t <= 1'b0;
        else
            gate_a_t <= gate_a;
    end
    assign negedge_t = (~gate_a) && gate_a_t;

    //将整个实际闸门中的cnt_clk计数值寄存到cnt_clk_reg中，并将cnt_clk计数器清零
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin

            cnt_clk_reg <= 32'd0;  
        end
        else if(negedge_s == 1)begin
            cnt_clk_reg <= cnt_clk; 

        end
         
    end

    //将整个实际闸门中的cnt_clk_test计数值寄存到cnt_clk_test_reg中，并将cnt_clk_test计数器清零
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            cnt_clk_test_reg <= 32'd0;  
        end
        else if(negedge_t == 1)begin
            cnt_clk_test_reg <= cnt_clk_test; 
        end         
    end

    //计算标志信号的产生clac_flag 
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clac_flag <= 1'b0;
        else if(cnt_gate_s == CNT_150)
            clac_flag <= 1'b1;
        else 
            clac_flag <= 1'b0;
    end 

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            freq_reg <= 64'd0;
        else if(clac_flag == 1)begin
            freq_reg <= (sys_clk_freq*cnt_clk_test_reg/cnt_clk_reg);
        end    
        else
            freq_reg <= freq_reg;
    end  

    //频率输出标志信号
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            freq_flag <= 1'b0;
        else
            freq_flag <= clac_flag;
    end

    //频率测量值输出
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clk_freq <= 32'd0;
        else if(freq_flag == 1'b1)
            clk_freq <= freq_reg;
        else
            clk_freq <= clk_freq;
    end

endmodule
