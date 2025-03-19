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
    input [3:0] x_vga2, 
    input [4:0] y_vga2,
    input clk, reset,
    input [4:0] y1,y2,y3,y4,
    input [3:0] x1,x2,x3,x4,
    input [3:0] block_type,
    output [11:0] color,
    output reg block_logic_reset
    );
    //localparam middle = 12'b1111_0111_0000;
    localparam middle = {12{1'b0}};
    localparam white = {12{1'b1}};
    reg [0:9] matrix [0:20];
    reg [3:0] color_matrix [0:19][0:9];
    
    
    wire [4:0] y1p, y2p, y3p, y4p;
    
    assign y1p = y1 + 5'd1;
    assign y2p = y2 + 5'd1;
    assign y3p = y3 + 5'd1;
    assign y4p = y4 + 5'd1;
    
    
    wire oob = matrix[y1p][x1] | matrix[y2p][x2] | matrix[y3p][x3] | matrix[y4p][x4];
    
    integer i,j;
    
    integer i,j;
    
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
            matrix[10]= 0;
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
                color_matrix[y1][x1] = block_type;
                color_matrix[y2][x2] = block_type;
                color_matrix[y3][x3] = block_type;
                color_matrix[y4][x4] = block_type;
                block_logic_reset = 1'b1;
            end
            else block_logic_reset = 1'b0;
        end
      
    end
    
    localparam yellow = 12'b0000_1111_1111;
    localparam magenta = 12'b1111_0000_1111;
    localparam green = 12'b0000_1111_1000;
    localparam orange = 12'b0000_1000_1111;
    localparam red = 12'b0000_0000_1111;
    localparam blue = 12'b1111_0000_0000;
    localparam light_blue = 12'b1100_0000_0000;
    
    reg [11:0] color_out;
    
    always @(*) begin
        case(color_matrix[y_vga2][x_vga2])
            3'd1: color_out = blue;
            3'd2: color_out = yellow;
            3'd3: color_out = magenta;
            3'd4: color_out = green;
            3'd5: color_out = orange;
            3'd6: color_out = red;
            3'd7: color_out = light_blue;
            default: color_out = middle;
        endcase
    end
    
    //assign [11:0] colour_calc = ((x<=(block1_x + 10'd21) && x>=block1_x && y>=block1_y && y<=(block1_y + 10'd21))d ? block_colour : middle;
    assign color = (matrix[y_vga2][x_vga2]) ? color_out : middle;
endmodule
