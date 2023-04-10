`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 10:08:18
// Design Name: 
// Module Name: sqrt_tb
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

module sqrt_tb;

reg [3:0] in = 0;
reg [15:0] as [0:9][0:1]; 
initial begin
    as[0][0] = 1;
    as[0][1] = 1;
    
    as[1][0] = 2;
    as[1][1] = 1;
    
    as[2][0] = 25;
    as[2][1] = 5;
    
    as[3][0] = 9;
    as[3][1] = 3;
    
    as[4][0] = 16;
    as[4][1] = 4;
end

reg clk_reg = 1;
reg rst_reg;
reg [15:0] a;
reg start_i = 0;
wire busy;
wire ready;
wire [7:0] y;

reg signal;
wire [16:0] aw;
wire [16:0] bw;
wire [16:0] sum_res;
wire [16:0] sum_res_for_output;

summator main_summator(
        .signal(signal), 
        .a1(a_sq), .b1(b_sq),
        .a2(aw), .b2(bw), 
        .res1(sum_res_for_output), 
        .res2(sum_res)
    );

sqrt sq(
    .clk_i(clk_reg), .rst_i(rst_reg), .start_i(start_i), 
    .a_bi(a), .ready(ready), .busy_o(busy), .y_bo(y),
     .aw(aw), .bw(bw), .sum_res(sum_res)
);

always
    #10 clk_reg = !clk_reg;

initial begin
   rst_reg = 1;
   a = as[in][0];
end

always @(posedge clk_reg)
    if (ready) begin
        rst_reg = 0;
        start_i = 1;
    end else if (start_i && busy) begin
        start_i = 0;
    end else if(~busy) begin
        if (y == as[in][1]) begin
                $display("%d Correct a=%d res=%d", in, a, y);
            end else begin
                $display("%d Incorrect a=%d res=%d", in, a, y);
            end;
        rst_reg = 1;
        in = in+1;
        if (in > 4) begin
            $finish;
        end;
            
        a = as[in][0];
    end

endmodule