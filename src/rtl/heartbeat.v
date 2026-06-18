`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 16:14:24
// Design Name: 
// Module Name: heartbeat
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


module heartbeat #(
    // Default parameter for 100ms with a 125 MHz Clock
    // 125_000_000 Hz / 100 Hz = 12_500_000 
    parameter integer MAX_COUNT = 12_500_000
)(
    input  wire clk,        // Clock
    input  wire rst,        // Synchronous Reset
    output reg  tick        // Pulse
    );
    
    // Counter Register
    // $clog2 automatically calculates the number of bits needed
    reg [$clog2(MAX_COUNT)-1:0] counter; 
    
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            tick    <= 1'b0;
        end else begin
            if (counter == MAX_COUNT - 1) begin
                // Target hit
                counter <= 0;
                tick    <= 1'b1;    // Pulse generated
            end else begin
                // Counter incremented
                counter <= counter + 1;
                tick    <= 1'b0;
            end
        end
    end 
endmodule
