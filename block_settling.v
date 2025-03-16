`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 05:26:05 PM
// Design Name: 
// Module Name: block_settling
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


module block_settling(
    input x_vga, y_vga,
    input clk, reset,
    input [4:0] y1,y2,y3,y4,
    input [3:0] x1,x2,x3,x4,
    output [11:0] color,
    output reg block_logic_reset
    );
    localparam middle = 12'b1111_0111_0000;
    reg [0:9] matrix [0:20];
    reg [3:0] color_matrix [19:0][9:0];
    
    
    wire [4:0] y1p, y2p, y3p, y4p;
    
    assign y1p = y1 + 5'd1;
    assign y2p = y2 + 5'd1;
    assign y3p = y3 + 5'd1;
    assign y4p = y4 + 5'd1;
    
    
    wire oob = matrix[y1p][x1] | matrix[y2p][x2] | matrix[y3p][x3] | matrix[y4p][x4];
    
    integer i,j;
    
//    initial begin
//        for (i = 0 ; i < 20 ; i = i + 1) begin
//            for (j = 0 ; j < 10 ; j = j + 1) begin
//                color_matrix[i][j] = 0;
//            end
//        end
//    end
    
    always @(posedge clk) begin
        if (reset) begin
            matrix[0] = 0;
            matrix[1] = 0;
            matrix[2] = 0;
            matrix[3] = 0;
            matrix[4] = 0;
            matrix[5] = 0;
            matrix[6] = 0;
            matrix[7] = 0;
            matrix[8] = 0;
            matrix[9] = 0;
            matrix[10] = 0;
            matrix[11] = 0;
            matrix[12] = 0;
            matrix[13] = 0;
            matrix[14] = 0;
            matrix[15] = 0;
            matrix[16] = 0;
            matrix[17] = 0;
            matrix[18] = 0;
            matrix[19] = 0;
            matrix[20] = {10{1'b1}};
            block_logic_reset = 1'b0;
        end
        else begin
            if (oob) begin
                matrix[y1][x1] = 1'b1;
                matrix[y2][x2] = 1'b1;
                matrix[y3][x3] = 1'b1;
                matrix[y4][x4] = 1'b1;
                
                block_logic_reset = 1'b1;
            end
            else block_logic_reset = 1'b0;
        end
      
    end
    
    //assign [11:0] colour_calc = ((x<=(block1_x + 10'd21) && x>=block1_x && y>=block1_y && y<=(block1_y + 10'd21)) || (x<=(block2_x + 10'd21) && x>=block2_x && y>=block2_y && y<=(block2_y + 10'd21)) || (x<=(block3_x + 10'd21) && x>=block3_x && y>=block3_y && y<=(block3_y + 10'd21)) || (x<=(block4_x + 10'd21) && x>=block4_x && y>=block4_y && y<=(block4_y + 10'd21))) ? block_colour : middle;
//    assign color = (matrix[]) ?  : middle;
endmodule
