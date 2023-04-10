`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:24:17
// Design Name: 
// Module Name: summator
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


module summator(
input [16:0] a1,
input [16:0] b1,
output [16:0] res1
);
    assign res1 = a1 + b1;
endmodule
