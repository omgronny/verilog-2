`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:25:52
// Design Name: 
// Module Name: multer
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

module sqrt (
    input clk_i ,
    input rst_i ,
    
    input [16:0] a_bi ,
    
    input start_i ,
    
    output wire ready,
    output busy_o ,
    output reg [7:0] y_bo
);

    localparam IDLE = 1'b0 ;
    localparam WORK = 1'b1 ;
    
    wire [2:0] end_step ;
    
    reg [15:0] a ;
    reg state ;
    reg ready_in ; 
    
    reg [15:0] m ;
    reg [16:0] y_or_m, y ;
    
    reg[16:0] bw, aw, y_temp, yw, mw;
    
    assign busy_o = state ;
    assign end_step = (m == 0) ;
    assign ready = ready_in ;
    
    always @(posedge clk_i)
        if (rst_i) begin
            m <= 1 << 14 ;
            y_bo <= 0 ;
            y <= 0 ;
            state <= IDLE ;
            ready_in <= 1 ;
        end else begin
            case ( state )
                IDLE :
                    if (ready && start_i) begin
                        m <= 1 << 14 ;
                        state <= WORK;
                        a <= a_bi ;
                        ready_in <= 0 ;
                    end
                WORK:
                begin
                    if (end_step) begin
                        state <= IDLE;
                        y_bo <= y ;
                    end else begin
                        y_or_m <= bw;
                        a <= aw;
                        y <= yw;
                        m <= mw;
                    end
                end
            endcase
        end
        
        always @*
            begin
                bw = y | m ;
                aw = a ;
                yw = y >> 1 ;
                if (aw >= bw) begin
                    aw = aw - bw ;
                    yw = yw | m ;
                end
                mw = m >> 2 ;
            end
        
endmodule

