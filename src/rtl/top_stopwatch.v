`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 17:55:23
// Design Name: 
// Module Name: top_stopwatch
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


module top_stopwatch(
    input   wire        clk,        // Pin H16 (125 MHz) on Arty Z7
    input   wire        btn_rst,    // Reset Button
    input   wire        btn_start,  // Start/Stop Button
    output  wire [6:0]  led_seg,    // Output to Pmod SSD (Segments)
    output  wire        pmod_sel    // Output to Pmod SSD (Select Pin)
    );
    
    // Internal Signals
    wire        tick_10ms;
    wire [3:0]  w_digit_0;
    wire [3:0]  w_digit_1;
    wire        btn_start_clean;
    
    // 0. Debouncer Instance
    debouncer #(
        .CTN_MAX(1_250_000) // 10ms of filtering is usually sufficien
    ) u_debouncer(
        .clk            (clk),
        .rst            (btn_rst),
        .btn_in         (btn_start),
        .btn_out        (btn_start_clean)
    );
    
    // 1. Heartbeat Instance (10 ms = 1_250_000 cycles)
    heartbeat #(
        .MAX_COUNT(1_250_000)
    ) u_heartbeat(
        .clk            (clk),
        .rst            (btn_rst),
        .tick           (tick_10ms)
    );
    
    // 2. Stopwatch Core Instance
    stopwatch_core u_core(
        .clk            (clk),
        .rst            (btn_rst),
        .tick_i         (tick_10ms),
        .start_stop_i   (btn_start_clean),
        .digit_0        (w_digit_0),
        .digit_1        (w_digit_1)
    );
    
    // 3. Display Driver Instance
    display_driver u_display(
        .clk            (clk),
        .digit_0        (w_digit_0),
        .digit_1        (w_digit_1),
        .segments       (led_seg),
        .digit_select   (pmod_sel)
    );
endmodule







