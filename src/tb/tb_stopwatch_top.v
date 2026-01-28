`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 17:07:16
// Design Name: 
// Module Name: tb_stopwatch_top
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


module tb_stopwatch_top();

    // Internal Signals
    reg clk, rst, btn_start;
    wire tick_connection;
    wire [3:0] d0, d1;
    
    // 1. Heartbeat instantiation
    heartbeat #(
        .MAX_COUNT(5)
    ) u_heartbeat (
        .clk(clk),
        .rst(rst),
        .tick(tick_connection)
    );
    
    // 2. Stopwatch core instantiation
    stopwatch_core u_core (
        .clk(clk),
        .rst(rst),
        .tick_i(tick_connection),
        .start_stop_i(btn_start),
        .digit_0(d0),
        .digit_1(d1)
    );
    
    // Clock Generation
    initial begin
        clk = 0;
        forever #4 clk = ~clk;
    end
    
    // Scenario
    initial begin
        // Initialization
        rst = 1; btn_start = 0;
        #20;
        rst = 0;
        
        // Wait a little in the IDLE state (nothing should happen)
        #50;
        
        // START Button pressed
        $display("[TB_STOPWATCH_TOP] Press START");
        btn_start = 1;
        #20 btn_start = 0; // Release button
        
        // We let the timer run for 15 ticks
        // Since MAX_COUNT=5, 1 tick = 5 cycles. 15 ticks = 75 cycles.
        // 1 cycle = 8ns, 75 cycles = 75*8 = 600
        #600;
        
        // Press STOP
         $display("[TB_STOPWATCH_TOP] Press STOP");
        btn_start = 1;
        #20 btn_start = 0; // Release button
        
        #100;
        
        $display("[TB_STOPWATCH_TOP] Units: %d, Tens: %d", d0, d1);
        $display("[TB_STOPWATCH_TOP] Number: %d%d", d1, d0);
        $finish;
    end
endmodule





