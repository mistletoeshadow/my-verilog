`timescale 1ns / 1ps

module DDS(
    input clk,
    input rst_n,
    input [31:0] k,
    //input [11:0] p,
    input en,

    output [7:0] f_out
    );

    reg[31:0] cnt;
    wire [11:0] addr;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 32'd0;
        else if(en == 1)
            cnt <= cnt + k;
        else
            cnt <= 32'd0;
    end

    //assign addr = cnt[ 31:20 ] + p; 
    assign addr = cnt[ 31:20 ]; 

waverom_4096x8 u_waverom_4096x8 (
  .clka(clk),    // input wire clka
  .addra(addr),  // input wire [11 : 0] addra
  .douta(f_out)  // output wire [7 : 0] douta
);


endmodule
