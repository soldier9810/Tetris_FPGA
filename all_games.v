`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 11:00:54 PM
// Design Name: 
// Module Name: all_games
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


module all_games(
    input clk_100, resetn, clockwise, anti_clkwise, down, left, right, select, up, main_screen,
    output reg hsync, vsync,
    output reg [11:0] vga,
    output [0:6] disp,
    output [0:7] act,
    input restart, start,
    output reg [1:0] current_game
    );
    wire clk;
    //reg [1:0] current_game;
    reg counter;
    
    always @(posedge clk_100) begin
        if (~resetn) counter <= 0;
        else counter <= counter + 1'b1;
    end
    
    assign clk = (counter == 1'b1);
    
    wire clockwise_db, anti_clkwise_db, down_db, left_db, right_db, select_db, main_screen_db;
    wire clockwise_db_100, anti_clkwise_db_100, down_db_100, left_db_100, right_db_100, select_db_100, main_screen_db_100;
    reg [1:0] next_game; //current_game;
    wire reset = ~resetn;
    wire hsync_breakout, vsync_breakout, hsync_white_screen, vsync_white_screen;
    wire [11:0] vga_breakout, vga_snake, vga_fruit;
    wire [11:0] color_tetris, vga_tetris, vga_white_screen;
    wire [9:0] x_tetris, y_tetris, x_white_screen, y_white_screen;
    wire hsync_tetris, vsync_tetris, hsync_snake, vsync_snake, hsync_fruit, vsync_fruit;
    
    localparam tetris_reg = 2'b00, breakout_reg = 2'b01, snake_reg = 2'b10, fruit_reg = 2'b11;
    localparam start_display = 1'b0, game_on = 1'b1;
    
    reg display_current, display_next;
    
    always @(*) begin
        case (display_current)
            start_display: begin
                vga = vga_white_screen;
                hsync = hsync_white_screen;
                vsync = vsync_white_screen;
                display_next = (select_db) ? game_on : start_display;
            end
            game_on: begin
                case (current_game)
                    tetris_reg: begin
                        vga = vga_tetris;
                        hsync = hsync_tetris;
                        vsync = vsync_tetris;
                    end
                    breakout_reg: begin
                        vga = vga_breakout;
                        hsync = hsync_breakout;
                        vsync = vsync_breakout;
                    end
                    snake_reg: begin
                        vga = vga_snake;
                        hsync = hsync_snake;
                        vsync = vsync_snake;
                    end
                    fruit_reg: begin
                        vga = vga_fruit;
                        hsync = hsync_fruit;
                        vsync = vsync_fruit;
                    end
                endcase
                display_next = (main_screen_db_100) ? start_display : game_on;
            end
        endcase
    end
    
    wire tetris_on = (display_current == game_on) &(current_game == tetris_reg);
    wire breakout_on = (display_current == game_on) &(current_game == breakout_reg);
    wire snake_on = (display_current == game_on) &(current_game == snake_reg);
    wire fruit_on = (display_current == game_on) &(current_game == fruit_reg); //(display_current == game_on) & 
    
    always @(posedge clk_100) begin
        if (reset | main_screen_db_100) display_current <= start_display;
        else display_current <= display_next;
    end
    
    always @(*) begin
        case (current_game)
            tetris_reg: next_game = (down_db_100 & (display_current == start_display)) ? breakout_reg : tetris_reg;
            breakout_reg: next_game = (down_db_100 & (display_current == start_display)) ? snake_reg : breakout_reg;
            snake_reg: next_game = (down_db_100 & (display_current == start_display)) ? fruit_reg : snake_reg;
            fruit_reg: next_game = (down_db_100 & (display_current == start_display)) ? tetris_reg : fruit_reg;
        endcase
    end
    
    always @(posedge clk_100) begin
        if (reset | main_screen_db) current_game <= 2'b00;
        else current_game <= next_game;
    end
    
    wire CLK_100MHz, CLK_40MHz;

    clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(CLK_100MHz),     // output clk_out1
    .clk_out2(CLK_40MHz),     // output clk_out2
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_100)      // input clk_in1
);
    wire game_reset = (display_current == start_display) & select_db_100;
    wire [9:0] x_console, y_console;
    reg [11:0] console_start;
    wire [11:0] another_console;
    VGA tetris_VGA(clk_100, reset, color_tetris, hsync_tetris, vsync_tetris, vga_tetris, x_tetris, y_tetris);
    full_game tetris(clk, clk_100, ~(reset  | game_reset | main_screen_db_100), clockwise_db, anti_clkwise_db, down_db, left_db, right_db, select_db, main_screen_db, x_tetris, y_tetris, color_tetris, tetris_on);
    
    
    top breakout(clk_100, reset | game_reset | main_screen_db_100, left, right, hsync_breakout, vsync_breakout, vga_breakout);
    
    VGA white_screen(clk_100, reset, console_start, hsync_white_screen, vsync_white_screen, vga_white_screen, x_console, y_console);
    //VGA red_screen(clk_100, reset, 12'b0000_0000_1111, hsync_snake, vsync_snake, vga_snake);
    VGA blue_screen(clk_100, reset, 12'b1111_0000_0000, hsync_fruit, vsync_fruit, vga_fruit);

    sf1 snake(CLK_100MHz, CLK_40MHz, reset  | game_reset | main_screen_db_100, restart, start, right, left, down, up, hsync_snake, vsync_snake, vga_snake, disp, act);
    console_start start_screen(reset, clk, y_console, x_console, another_console, display_current == start_display);
    
    always @(*) begin
        case(another_console)
            12'b1111_1111_1110: console_start = (current_game == tetris_reg) ? 12'b0000_1111_1111 : another_console;
            12'b1111_1110_1111: console_start = (current_game == breakout_reg) ? 12'b0000_1111_1111 : another_console;
            12'b1110_1111_1111: console_start = (current_game == snake_reg) ? 12'b0000_1111_1111 : another_console;
            default: console_start = another_console;
        endcase
    end
    
    debouncing_circuit for_clockwise_100 (clk_100, reset, clockwise, clockwise_db_100);
    debouncing_circuit for_anti_clkwise_100 (clk_100, reset, anti_clkwise, anti_clkwise_db_100);
    debouncing_circuit for_down_100 (clk_100, reset, down, down_db_100);
    debouncing_circuit for_left_100 (clk_100, reset, left, left_db_100);
    debouncing_circuit for_right_100 (clk_100, reset, right, right_db_100);
    debouncing_circuit select_pin_100 (clk_100, reset, select, select_db_100);
    debouncing_circuit main_screen_pin_100 (clk_100, reset, main_screen, main_screen_db_100);

    debouncing_circuit for_clockwise (clk, reset, clockwise, clockwise_db);
    debouncing_circuit for_anti_clkwise (clk, reset, anti_clkwise, anti_clkwise_db);
    debouncing_circuit for_down (clk, reset, down, down_db);
    debouncing_circuit for_left (clk, reset, left, left_db);
    debouncing_circuit for_right (clk, reset, right, right_db);
    debouncing_circuit select_pin (clk, reset, select, select_db);
    debouncing_circuit main_screen_pin (clk, reset, main_screen, main_screen_db);
    
    
endmodule
