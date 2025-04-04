`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2025 04:24:40 PM
// Design Name: 
// Module Name: top
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


module top(
    input clk, resetn,
    output [11:0] vga,
    output hsync, vsync
    );
    
    wire [11:0] vga_input;
    
    wire reset = ~resetn;
    wire [9:0] x,y;
    wire [11:0] color_data;
    VGA vga_driver(clk, reset, color_data, hsync, vsync, vga_input, x, y);
    
    assign vga = vga_input;
    
    reg [9:0] counter;
    
    

    level1bmp_rom screen(clk, y, x, color_data);


endmodule
