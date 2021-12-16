`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:rui
// descripe: IP基于vivado 2020 版本设置，IP设置详情请参照文件夹“doc/fifo_ip_config”。
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
//scfifo_128x12 your_instance_name (
//  .clk(clk),                // input wire clk
//  .srst(srst),              // input wire srst
//  .din(din),                // input wire [11 : 0] din
//  .wr_en(wr_en),            // input wire wr_en
//  .rd_en(rd_en),            // input wire rd_en
//  .dout(dout),              // output wire [11 : 0] dout
//  .full(full),              // output wire full
//  .empty(empty),            // output wire empty
//  .data_count(data_count)  // output wire [6 : 0] data_count
//);
// INST_TAG_END ------ End INSTANTIATION Template ---------
//////////////////////////////////////////////////////////////////////////////////
module fifo_128x12(
    input  wire         clk,
    input  wire         rst_n,
    input  wire  [11:0] i_FIFO_Din,
    input  wire         i_FIFO_wr_en,
    input  wire         i_FIFO_rd_en,

    output wire  [11:0] o_FIFO_Dout,    
    output wire         o_FIFO_Full,
    output wire         o_FIFO_Empty,
    output wire  [6:0]  o_FIFO_data_cnt
    );

    scfifo_128x12 fifo_128x12_u(
        .clk(clk),       
        .srst(~rst_n),
        .din(i_FIFO_Din), 
        .wr_en(i_FIFO_wr_en),
        .rd_en(i_FIFO_rd_en),
        .dout(o_FIFO_Dout),
        .full(o_FIFO_Full),
        .empty(o_FIFO_Empty),
        .data_count(o_FIFO_data_cnt)
    );

endmodule
