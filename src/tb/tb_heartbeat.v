`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 16:24:44
// Design Name: 
// Module Name: tb_heartbeat
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


module tb_heartbeat();

    // Internal Signals
    reg  r_clk;
    reg  r_rst;
    wire w_tick;
    
    // DUT Instantiation
    heartbeat #(
        .MAX_COUNT(10)  // Tick every 10 clock
    ) dut (
        .clk(r_clk),
        .rst(r_rst),
        .tick(w_tick)
    ); 
    
    // Clock Generation (Simulate 125 MHz -> 8ns period
    initial begin
        r_clk = 0;
        forever #4 r_clk = ~r_clk;
    end
    
    // Test scenario
    initial begin
        // 1. Initialization
        r_rst = 1;
        #20;
        
        // 2. Launch
        r_rst = 0;
        $display("Reset Released, start of counting...");
        
        // 3. Observation
        // We wait to see some ticks
        #400;
        
        // 4. End
        $display("End of the Simulation.");
        $finish;
    end
endmodule
