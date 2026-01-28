`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 09:36:37
// Design Name: 
// Module Name: tb_debouncer
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


module tb_debouncer();

    // Internal signals
    reg clk;
    reg rst;
    reg btn_noisy;
    wire btn_clean;
    
    // DUT Instance
    debouncer #(
        .CTN_MAX(10) 
    ) u_dut(
        .clk        (clk),
        .rst        (rst),
        .btn_in     (btn_noisy),
        .btn_out    (btn_clean)
    );
    
    // Clock Generation
    initial begin
        clk = 0;
        forever #4 clk = ~clk;
    end 
    
    // Scenario
    initial begin
        // 1. Initialization
        rst = 1;
        btn_noisy = 0;
        #20 rst = 0;
        $display("[TB_DEBOUNCER] Start of the simulation");
        
        // 2. Noise test (glitch)
        // Button at '1' for 40ns (5 cycles) < 10 cycles
        #50;
        $display("[TB_DEBOUNCER] Noise simulation (5 cycles)...");
        btn_noisy = 1;
        #40;
        btn_noisy = 0;
        
        // Wait to see if the output change (it shouldn't)
        #100;
        if (btn_clean == 0) $display("[TB_DEBOUNCER] --> SUCCESS: Noise IGNORED");
        else                $display("[TB_DEBOUNCER] --> FAIL: Noise DETECTED");
        
        // 3. Push Valid Test
        // Button at '1' for 120ns (15 cycles) > 10 cycles
        #50;
        $display("[TB_DEBOUNCER] Valid Push simulation (15 cycles)...");
        btn_noisy = 1;
        
        // Wait to see transition
        wait(btn_clean == 1);
        $display("[TB_DEBOUNCER] --> SUCCESS: Push Detected at %t", $time);
        
        // 4. Release
        #40;
        btn_noisy = 0;
        wait(btn_clean == 0);
        $display("[TB_DEBOUNCER] --> SUCCESS: Release Detected");
        
        #50;
        $finish;
        
    end 
endmodule
