`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 06:31:25 PM
// Design Name: 
// Module Name: full_game
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


module full_game(
    input clk, resetn, clockwise, anti_clkwise, down, left, right, select,
    output hsync, vsync,
    output [11:0] vga    
    );
    
    wire reset = ~resetn;
    wire [1:0] velocity = 2'b00;
    wire [11:0] colour_calc_gs, colour_calc_play, colour_calc_go;
    reg [11:0] colour_calc;
    wire [9:0] x, y;
    reg [1:0] current, next;
    wire clockwise_db, anti_clkwise_db, down_db, left_db, right_db, select_db;
    
    debouncing_circuit for_clockwise (clk, reset, clockwise, clockwise_db);
    debouncing_circuit for_anti_clkwise (clk, reset, anti_clkwise, anti_clkwise_db);
    debouncing_circuit for_down (clk, reset, down, down_db);
    debouncing_circuit for_left (clk, reset, left, left_db);
    debouncing_circuit for_right (clk, reset, right, right_db);
    debouncing_circuit select_pin (clk, reset, select, select_db);
    
    localparam start = 2'b0, play = 2'b01, over = 2'b10;
    
    always @(*) begin
        case (current)
            start: colour_calc = colour_calc_gs;
            play: colour_calc = colour_calc_play;
            over: colour_calc = colour_calc_go;
            default: colour_calc = colour_calc_gs;
        endcase
    end
    
    wire clk_en_ss = (current == 2'b0);
    
    wire clk_en_gs = (current == 2'b01);
    
    wire clk_en_go = (current == 2'b10);
    
    VGA vga_circuit(clk, reset, colour_calc, hsync, vsync, vga, x, y);
    
    game_screen GS (clk, resetn, clockwise_db, anti_clkwise_db, down_db, left_db, right_db, velocity, x, y, colour_calc_play, clk_en_gs);
    level1bmp_rom LR (clk, y, x, colour_calc_gs, clk_en_ss);
    game_over GO (clk, y, x, colour_calc_go, clk_en_go);
    
    
    always @(*) begin
        case (current)
            start: next = (select_db) ? play : start;
            play: next = (select_db) ? over : play;
            over: next = (select_db) ? start : over;
            default: next = start;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) current <= start;
        else current <= next;
    end
    
    
endmodule
