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

input clk,
input rst,
input start,

input [15:0] a,
input [15:0] b,

output wire busy,
output wire ready,
output reg [15:0] res

    );
    
    reg ready_in;
    assign ready = ready_in;
    
    reg wait_i;
    assign busy = wait_i;
    
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    reg state;
    
    always @(posedge clk)
        if (rst) begin 
            state <= IDLE;
            ready_in <= 1;
            res <= 0;
            wait_i <= 1;
        end else begin
            case(state)
                IDLE:
                    if (ready && start) begin
                        state <= WORK;
                        ready_in <= 0;
                    end
                WORK:
                    begin
                        res <= a + b;
                        state <= IDLE;
                        wait_i <= 0;
                    end
             endcase
        end
    
endmodule
