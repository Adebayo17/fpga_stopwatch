# FPGA Stopwatch Controller

![Projet Overview](docs/diagram/diagram_overview.png)


## Overview
This project implements a precise digital stopwatch on the Arty Z7-20 FPGA development board. The design features a modular architecture written in Verilog, handling asynchronous user inputs and multiplexed 7-segment display control.

![System Block Diagram](docs/diagram/diagram_expanded.png)

![RTL Schematic](docs/diagram/rtl_shematic.png)

## Hardware Specification
* **FPGA Board:** Digilent Arty Z7-20 (Zynq-7000 AP SoC)
* **Display:** Digilent Pmod SSD (Two-digit Seven-segment Display) connected to Port JB.
* **Inputs:** On-board mechanical buttons (BTN0 for Reset, BTN1 for Start/Stop).


## Architecture Details
The design is split into four synchronous modules:

1.  **Debouncer:** Filters mechanical bounce from the push-buttons using a counter-based hysteresis (20ms threshold).
2.  **Heartbeat:** A parametric clock divider generating a 100Hz enable pulse (10ms resolution) from the 125MHz system clock.
3.  **Core Logic:** Contains the Finite State Machine (FSM) for counting states and Binary Coded Decimal (BCD) counters for unit/tens tracking.
4.  **Display Driver:** Performs 7-segment decoding and time-multiplexing to drive the Pmod SSD.


## Verification
All modules were verified using behavioral simulation in Vivado. The verification strategy involved both unit testing (isolated modules) and integration testing (full signal chain).

### 1. Heartbeat Generation
The timing accuracy was verified by simulating the rollover of the clock divider.
![Heartbeat Waveform](docs/waves/heartbeat_waveform.png)

### 2. Debouncer Filter (Unit Test)
The input filter was validated by injecting synthetic noise (glitches) into the signal. The simulation confirms that:
* **Noise Rejection:** Pulses shorter than the defined threshold are ignored.
* **Signal Validation:** Only stable signals (held longer than the threshold) trigger the output.
*(Note: Parameter `CNT_MAX` was reduced to 10 cycles for simulation visibility).*
![Debouncer Waveform](docs/waves/debouncer_waveform.png) 

### 3. Core Logic & Integration
The stopwatch logic was verified in two stages:

* **Stage A: Core Unit Testing (Ideal Inputs)**
    Verified the BCD counting logic and FSM transitions (IDLE <-> RUN) using clean, ideal input signals.
    ![Core Waveform](docs/waves/stopwatch_core_waveform.png)

* **Stage B: Full Integration Testing (Noisy Inputs)**
    Verified the complete signal chain (`Button` -> `Debouncer` -> `Core`). A noisy signal with bouncing was injected to confirm that the Core FSM only triggers once per physical button press, proving the robustness of the system.
    ![Integrated Waveform](docs/waves/stopwatch_integrated_waveform.png)
    


## Pinout Mapping
### Pmod SSD (Connected to Port JB)
The 7-segment display spans JA and JB headers.
Ensure the Pmod is oriented correctly (bottom row aligned, VCC/GND matched).

- **Segments A–D → JA**
- **Segments E–G → JB**
- **Digit Select → JB**

![FPGA Board Assembly](docs/demo/fpga_board_assembly.jpg)

| Segment | Pmod Signal | Arty Port | FPGA Pin | HDL Signal  | Description        |
| :---:   | :---        | :---      | :---     | :---        | :---               |
| A       | AA          | JA[7]     | U18      | led_seg[0]  | Segment A          |
| B       | AB          | JA[8]     | U19      | led_seg[1]  | Segment B          |
| C       | AC          | JA[9]     | W18      | led_seg[2]  | Segment C          |
| D       | AD          | JA[10]    | W19      | led_seg[3]  | Segment D          |
| E       | AE          | JB[7]     | V16      | led_seg[4]  | Segment E          |
| F       | AF          | JB[8]     | W16      | led_seg[5]  | Segment F          |
| G       | AG          | JB[9]     | V12      | led_seg[6]  | Segment G          |
| CAT     | C           | JB[10]    | W13      | pmod_sel    | Digit Select (CAT) |

### System Controls
| Function      | Label on Board | FPGA Pin | Description         |
| :---          | :---           | :---     | :---                |
| **Clock**     | CLK            | H16      | 125 MHz Oscillator  |
| **Reset**     | BTN0           | D19      | Active High Reset   |
| **Start**     | BTN1           | D20      | Start/Stop Trigger  |


## Project Structure
The repository is organized as follows:

```text
fpga_stopwatch/
├── docs/               # Documentation assets (diagrams, waveforms)
├── src/
│   ├── rtl/            # Synthesizable Verilog sources (heartbeat, debouncer, core...)
│   ├── tb/             # Testbench files
│   └── constrs/        # Xilinx Design Constraints (.xdc)
└── README.md           # Project Documentation
```

## How to Run (Vivado)

1. **Create Project**: Open Vivado and create a new RTL project targeting the Arty Z7-20 board.

2. **Add Sources**: Import all files from `src/rtl` and `src/tb`.

3. **Add Constraints**: Import the `.xdc` file from `src/constrs`.

4. **Simulation**: 
    - Set `tb_stopwatch_integrated` as the top module for simulation.
    - Run Behavioral Simulation to verify the debouncing logic.

5. Implementation:
    - Click **Generate Bitstream**.
    - Open **Hardware Manager -> Auto Connect**.
    - Program the device.


## Demo Video

https://github.com/Adebayo17/fpga_stopwatch/tree/master/docs/demo/stopwatch_demo.mp4