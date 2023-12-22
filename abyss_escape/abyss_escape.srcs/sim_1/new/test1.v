`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 11:04:48 PM
// Design Name: 
// Module Name: test1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test1();
reg clk;
reg start;
reg restart;
reg vauxp6;
reg vauxn6;
reg vauxp7;
reg vauxn7;
reg vauxp15;
reg vauxn15;
reg vauxp14;
reg vauxn14;

wire h_sync;
wire v_sync;
wire [11:0] rgb;

main m(clk, start, restart, vauxp6, vauxn6, vauxp7, vauxn7, vauxp15, vauxn15, vauxp14, vauxn14, h_sync, v_sync, rgb);
initial
begin
#100 start = 0; restart = 0;
#100 start = 1; restart = 0;
#100 start = 0; restart = 1;
end
endmodule
