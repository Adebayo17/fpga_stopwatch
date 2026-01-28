`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 28.01.2026 09:58:16
// Design Name: 
// Module Name: tb_stopwatch_integrated
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


module tb_stopwatch_integrated();
    
    // Internal signals
    reg clk, rst;
    reg btn_start_noisy;
    
    wire btn_start_clean;
    wire tick_connection;
    wire [3:0] d0, d1;
    
    // === Instanciations ===
    // A. Heartbeat (Simu case : 1 tick every 5 cycles)
    heartbeat #(
        .MAX_COUNT(5)
    ) u_heartbeat (
        .clk(clk), 
        .rst(rst), 
        .tick(tick_connection)
    );

    // B. Debouncer (Simu case :  10 cycles filtering)
    debouncer #(
        .CTN_MAX(10)
    ) u_debouncer (
        .clk(clk), 
        .rst(rst), 
        .btn_in(btn_start_noisy), 
        .btn_out(btn_start_clean)
    );

    // C. Core
    stopwatch_core u_core (
        .clk(clk), 
        .rst(rst),
        .tick_i(tick_connection),
        .start_stop_i(btn_start_clean),     // Clean Signal
        .digit_0(d0), 
        .digit_1(d1)
    );
    
    // === Clock Generation ===
    initial begin
        clk = 0;
        forever #4 clk = ~clk;
    end 
    
    // === Scenario ===
    initial begin
        $timeformat(-9, 2, " ns", 20); // Time Display Format
        
        // Init
        rst = 1; 
        btn_start_noisy = 0;
        #20 rst = 0;
        #50;

        // SCENARIO : "Noisy" press on Start (Rebonds)
        $display("[TB_STOPWATCH_INTEGRATED] Attempted start with bounces");
        
        // Rebond 1 (Short - should be ignored)
        btn_start_noisy = 1; #10; 
        btn_start_noisy = 0; #10;
        
        // Rebond 2 (Short - should be ignored)
        btn_start_noisy = 1; #20; 
        btn_start_noisy = 0; #20;
        
        // True Push (Long and Stable)
        $display("[TB_STOPWATCH_INTEGRATED] Hold the Button (Stable Press)");
        btn_start_noisy = 1; 
        
        // We wait for the debouncing to validate (it takes > 10 cycles or > 80ns)
        // We 100ns for safety
        #100;
        
        // Visual check in the console
        if (u_core.current_state == 1) // 1 = RUN
            $display("[TB_STOPWATCH_INTEGRATED][SUCCES] The Core has switched to RUN mode.");
        else
            $display("[TB_STOPWATCH_INTEGRATED][FAIL] The Core is still in IDLE.");

        // Release button
        btn_start_noisy = 0;
        
        // We left the timer run for a while (ex: 500ns)
        #500;
        
        $display("[TB_STOPWATCH_INTEGRATED] Final Value: %d%d", d1, d0);
        $finish;
    end
endmodule
