`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:27:01
// Design Name: 
// Module Name: evaluator
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
 
 
module evaluator(
    input clk_i ,
    input rst_i ,
    
    input [7:0] a_bi ,
    input [7:0] b_bi ,
    
    input start_i ,
    
    output ready,
    output busy_o ,
    output reg [7:0] y_bo
    );
    
    localparam IDLE = 2'h0 ;
    localparam WORK_MULT = 2'h1 ;
    localparam WORK_SQRT = 2'h2 ;
    
    reg [1:0] state ;
    
    reg ready_in;
    reg start_mult;
    reg start_sqrt;
    
    reg [15:0] a_res, b_res;
    wire [15:0] a_sq, b_sq;
    
    wire a_busy, b_busy, sqrt_busy;
    wire a_ready, b_ready, sqrt_ready;
    reg [16:0] sum;
    wire [7:0] res;
    
    reg a_rst;
    reg b_rst;
    reg sum_rst;
    
    assign ready = ready_in;
    assign busy_o = state > 0 ;
    
    multer a_square(.clk_i(clk_i), .rst_i(a_rst), .ready(a_ready), 
                    .a_bi(a_bi), .b_bi(a_bi), .start_i(start_mult), 
                    .busy_o(a_busy), .y_bo(a_sq));
                    
    multer b_square(.clk_i(clk_i), .rst_i(b_rst), .ready(b_ready), 
                    .a_bi(b_bi), .b_bi(b_bi), .start_i(start_mult), 
                    .busy_o(b_busy), .y_bo(b_sq));
    
    sqrt sqrt_res(.clk_i(clk_i), .rst_i(sum_rst), .ready(sqrt_ready),
                  .a_bi(sum), .start_i(start_sqrt), 
                  .busy_o(sqrt_busy), .y_bo(res));
    
    
    always @(posedge clk_i)
        if (rst_i) begin
        
            y_bo <= 0 ;
            state <= IDLE ;
            
            a_rst <= 1;
            b_rst <= 1;
            sum_rst <= 1;
            
            start_mult <= 0;
            start_sqrt <= 0;
            
            sum <= 0;
            ready_in <= 1;
            
        end else begin
            case ( state )
                IDLE :
                    if (start_i) begin
                        a_rst <= 0;
                        b_rst <= 0;
                        sum_rst <= 0;
                        
                        state <= WORK_MULT ;
                        ready_in <= 0 ;
                        start_mult <= 1 ;
                    end
                WORK_MULT:
                    begin
                        if (start_mult) begin
                            start_mult <= 0;
                        end else if (!a_busy && !b_busy) begin
                            a_res <= a_sq;
                            b_res <= b_sq;
                            sum <= a_sq + b_sq;
                            start_sqrt <= 1;
                            state <= WORK_SQRT;
                        end
                    end
                WORK_SQRT:
                    begin
                        if (start_sqrt) begin
                            start_sqrt <= 0;
                        end else if (!sqrt_busy) begin
                            y_bo <= res;                           
                            state <= IDLE;
                        end
                    end
            endcase
        end
endmodule