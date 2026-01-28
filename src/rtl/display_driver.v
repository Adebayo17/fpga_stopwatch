`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 17:29:09
// Design Name: 
// Module Name: display_driver
// Project Name: Stopwatch
// Target Devices: Arty Z7-20
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


module display_driver #(
    // Parameter to adjust the refresh rate
    // For 125 MHz, we want to change digits every ~5ms (200 Hz switch rate)
    // 125_000_000 * 0.005 = 625_000 cycles
    parameter REFRESH_COUNT = 625_000
)(
    input   wire        clk,
    input   wire [3:0]  digit_0,        // Units
    input   wire [3:0]  digit_1,        // Tens
    output  reg  [6:0]  segments,       // Cathodes A-G (Active High or Low according to Pmod)
    output  reg         digit_select    // 0 = Left Digit, 1 = Right Digit (or vice-versa)
    );
    
    // === 1. Gererate Refresh ===
    reg [$clog2(REFRESH_COUNT)-1:0] refresh_timer;
    reg refresh_tick;   // Signal to change digit
    
    always @(posedge clk) begin
        if (refresh_timer == REFRESH_COUNT - 1) begin
            refresh_timer   <= 0;
            refresh_tick    <= 1'b1;
        end else begin
            refresh_timer   <= refresh_timer + 1;
            refresh_tick    <= 1'b0;
        end
    end
    
    // === 2. Multiplexing Control ===
    // We switch digit_select on each refresh_tick
    always @(posedge clk) begin
        if (refresh_tick) begin
            digit_select <= ~digit_select;
        end
    end
    
    // === 3. Selecting data to display ===
    reg [3:0] bcd_to_decode;
    always @(*) begin
        case (digit_select)
            1'b0: bcd_to_decode = digit_0;  // If select=0, display Units
            1'b1: bcd_to_decode = digit_1;  // If select=1, display Tens
        endcase
    end 
    
    // === 4. 7-Segment Decode (Look-Up Table) ===
    // Standard Configuration : gfedcba
    // 0 = segment off, 1 = segment on
    always @(*) begin
        case (bcd_to_decode)
            //                   gfedcba
            4'h0 : segments = 7'b0111111; // 0
            4'h1 : segments = 7'b0000110; // 1
            4'h2 : segments = 7'b1011011; // 2
            4'h3 : segments = 7'b1001111; // 3
            4'h4 : segments = 7'b1100110; // 4
            4'h5 : segments = 7'b1101101; // 5
            4'h6 : segments = 7'b1111101; // 6
            4'h7 : segments = 7'b0000111; // 7
            4'h8 : segments = 7'b1111111; // 8
            4'h9 : segments = 7'b1101111; // 9
            default : segments = 7'b0000000; // Eteint si erreur
        endcase
    end
endmodule










