`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:31:58 12/06/2020 
// Design Name: 
// Module Name:    TestBench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TestBench;
parameter SIZE = 14, DEPTH = 1024;

reg clk;
initial begin
  clk = 1;
  forever
	  #5 clk = ~clk;
end

reg rst;
initial begin
  rst = 1;
  repeat (10) @(posedge clk);
  rst <= #1 0;
  repeat (600) @(posedge clk);
  // uncomment the following line to display the content at address 50 in console
  // $display("Content of address 50 is %d.", inst_blram.memory[50]);
  $finish;
end

wire wrEn;
wire [SIZE-1:0] addr_toRAM;
wire [31:0] data_toRAM, data_fromRAM;

VerySimpleCpu inst_VerySimpleCpu(
  .clk(clk),
  .rst(rst),
  .wrEn(wrEn),
  .data_fromRAM(data_fromRAM),
  .addr_toRAM(addr_toRAM),
  .data_toRAM(data_toRAM)
);

blram #(SIZE, DEPTH) inst_blram(
  .clk(clk),
  .rst(rst),
  .i_we(wrEn),
  .i_addr(addr_toRAM),
  .i_ram_data_in(data_toRAM),
  .o_ram_data_out(data_fromRAM)
);

endmodule

module blram(clk, rst, i_we, i_addr, i_ram_data_in, o_ram_data_out);

parameter SIZE = 10, DEPTH = 1024;

input clk;
input rst;
input i_we;
input [SIZE-1:0] i_addr;
input [31:0] i_ram_data_in;
output reg [31:0] o_ram_data_out;

reg [31:0] memory[0:DEPTH-1];

always @(posedge clk) begin
  o_ram_data_out <= #1 memory[i_addr[SIZE-1:0]];
  if (i_we)
		memory[i_addr[SIZE-1:0]] <= #1 i_ram_data_in;
end 

initial begin
//////////////////////////
// write BRAM content here
memory[0] = 32'hc8033;
memory[1] = 32'h80320258;
memory[2] = 32'ha0324257;
memory[3] = 32'h603200c9;
memory[4] = 32'hc06440c8;
memory[5] = 32'ha0960257;
memory[6] = 32'h1095c001;
memory[7] = 32'h80320257;
memory[8] = 32'h703201fe;
memory[9] = 32'hc06480c8;
memory[10] = 32'hd0640001;
memory[11] = 32'h80960258;
memory[200] = 32'h0;
memory[201] = 32'h0;
memory[400] = 32'h0;
memory[401] = 32'h6;
memory[402] = 32'hb;
memory[500] = 32'h5;
memory[501] = 32'h6;
memory[502] = 32'h3;
memory[503] = 32'h2;
memory[504] = 32'hb;
memory[505] = 32'h1;
memory[506] = 32'h4;
memory[507] = 32'h9;
memory[508] = 32'h8;
memory[509] = 32'h7;
memory[599] = 32'h1f5;
memory[600] = 32'h0;
//////////////////////////
end

endmodule