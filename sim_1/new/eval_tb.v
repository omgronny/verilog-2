`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 14:42:02
// Design Name: 
// Module Name: eval_tb
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

module eval_tb;

reg [3:0] in;
reg [7:0] as [0:9][0:2]; 
initial begin
    in = 0;
    as[0][0] = 3;
    as[0][1] = 4;
    as[0][2] = 5;
    
    as[1][0] = 5;
    as[1][1] = 12;
    as[1][2] = 13;
    
    as[2][0] = 8;
    as[2][1] = 15;
    as[2][2] = 17;
    
    as[3][0] = 1;
    as[3][1] = 1;
    as[3][2] = 1;
    
    as[4][0] = 2;
    as[4][1] = 2;
    as[4][2] = 2;
    
    as[5][0] = 1;
    as[5][1] = 5;
    as[5][2] = 5;
    
    as[6][0] = 10;
    as[6][1] = 20;
    as[6][2] = 22;
    
    as[7][0] = 15;
    as[7][1] = 6;
    as[7][2] = 16;
    
    as[8][0] = 55;
    as[8][1] = 55;
    as[8][2] = 77;
    
    as[9][0] = 8;
    as[9][1] = 9;
    as[9][2] = 12;
end

reg clk_reg = 1;
reg rst_reg;

reg [7:0] a;
reg [7:0] b;

reg start;
wire busy;
wire ready;

wire [7:0] y_bo;

evaluator m(
    .clk_i(clk_reg),
    .rst_i(rst_reg),
    .start_i(start),
    .a_bi(a),
    .b_bi(b),
    .ready(ready),
    .busy_o(busy),
    .y_bo(y_bo)
);

 always
   #1 clk_reg = !clk_reg;

initial begin
    rst_reg = 1;
    start = 1;
    a = as[in][0];
    b = as[in][1];
end

always @(posedge clk_reg) begin
    if (ready) begin
        rst_reg = 0;
        start = 1;
    end else if (start && busy) begin
        start = 0;
    end else if(!busy) begin
        if (y_bo == as[in][2]) begin
            $display("%d Correct a=%d b=%d res=%d", in, a, b, y_bo);
        end else begin
            $display("%d Incorrect a=%d b=%d res=%d", in, a, b, y_bo);
        end
        rst_reg = 1;
        in = in+1;

        if (in > 9) begin
            $display("%d finish ", in);
            $finish;
        end
        
        a = as[in][0];
        b = as[in][1];
    end
end

endmodule
