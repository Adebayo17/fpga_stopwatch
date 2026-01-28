`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 28.01.2026 09:16:12
// Design Name: 
// Module Name: debouncer
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


module debouncer #(
    // Parameter : Required Stability Period
    // 125 MHz * 20ms = 125_000_000 * 0.02 = 2_500_000 cycles
    parameter CTN_MAX = 2_500_000
)(
    input   wire clk,
    input   wire rst,
    input   wire btn_in,    // Noisy Input (Physical Button)
    output  reg btn_out     // Clean Output 
    );
    
    reg [31:0] counter;
    reg btn_sync_0, btn_sync_1; // Synchronisation Register
    
    // 1. Synchronisation (To avoid metastability)
    always @(posedge clk) begin
        if (rst) begin
            btn_sync_0  <= 1'b0;
            btn_sync_1  <= 1'b0;
        end else begin
            btn_sync_0  <= btn_in;
            btn_sync_1  <= btn_sync_0;
        end
    end
    
    // 2. Filtering
    always @(posedge clk) begin
        if (rst) begin
            counter     <= 0;
            btn_out     <= 1'b0;
        end else begin
            // If the input changes relative to the current output
            if (btn_sync_1 != btn_out) begin
                counter <= counter + 1;
                // If the counter reaches the threshold, the change is validated
                if (counter >= CTN_MAX) begin
                    btn_out <= btn_sync_1;
                    counter <= 0;
                end 
            end else begin
                // If the input has returned to the same level as the output, the counter is reset 
                // This was therefore a noise/bounce
                counter <= 0;
            end 
        end
    end
endmodule





