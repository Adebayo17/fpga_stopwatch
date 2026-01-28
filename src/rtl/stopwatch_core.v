`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gaël BOYA
// 
// Create Date: 27.01.2026 16:43:25
// Design Name: 
// Module Name: stopwatch_core
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


module stopwatch_core(
    input   wire        clk,
    input   wire        rst,
    input   wire        tick_i,         // Heartbeat Module Output
    input   wire        start_stop_i,   // Button (supposedly clean for now)
    output  reg [3:0]   digit_0,        // Units (0-9)
    output  reg [3:0]   digit_1         // Tens  (0-9)
    );
    
    // === 1. FSM States ===
    localparam STATE_IDLE   = 1'b0;
    localparam STATE_RUN    = 1'b1;
    
    reg current_state;
    
    // === 2. Edge Detector ===
    reg btn_prev;
    wire btn_rise;  // Will be '1' for 1-cycle clock
    
    always @(posedge clk) begin
        btn_prev <= start_stop_i;
    end
    
    assign btn_rise = start_stop_i && !btn_prev;
    
    // === 3. Sequential Logic (FSM + Counter) ===
    always @(posedge clk) begin
        if (rst) begin
            current_state   <= STATE_IDLE;
            digit_0         <= 4'd0;
            digit_1         <= 4'd0;
        end else begin
            
            // State gestion (Start/Stop)
            if (btn_rise) begin
                current_state <= ~current_state;    // Toggle the state
            end
            
            // Counter management
            if ((current_state == STATE_RUN) && (tick_i == 1'b1)) begin
                if (digit_0 == 4'd9) begin
                    digit_0 <= 4'd0;
                    if (digit_1 == 4'd9) begin
                        digit_1 <= 4'd0;    // Global Reset: 99 -> 00
                    end else begin
                        digit_1 <= digit_1 + 1;
                    end
                end else begin
                    digit_0 <= digit_0 + 1;
                end
            end
        end
    end
endmodule





