## Clock Signal
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=SYSCLK
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];#set

## Buttons: Reset and Start/Stop
set_property -dict { PACKAGE_PIN D19    IOSTANDARD LVCMOS33 } [get_ports { btn_rst }]; #IO_L4P_T0_35 Sch=BTN0
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports { btn_start }]; #IO_L4N_T0_35 Sch=BTN1


## Pmod Header JB: Pmod SSD 7-Segment Display
# Mapping : Segments A, B, C, D, E, F, G -> JB[1..4] et JB[7..9]
# Mapping : Select -> JB[10]
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { led_seg[0] }]; #IO_L8P_T1_34 Sch=JB1_P (Pin 1)
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { led_seg[1] }]; #IO_L8N_T1_34 Sch=JB1_N (Pin 2)
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { led_seg[2] }]; #IO_L1P_T0_34 Sch=JB2_P (Pin 3)
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led_seg[3] }]; #IO_L1N_T0_34 Sch=JB2_N (Pin 4)
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { led_seg[4] }]; #IO_L18P_T2_34 Sch=JB3_P (Pin 7)
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { led_seg[5] }]; #IO_L18N_T2_34 Sch=JB3_N (Pin 8)
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { led_seg[6] }]; #IO_L4P_T0_34 Sch=JB4_P (Pin 9)
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { pmod_sel }]; #IO_L4N_T0_34 Sch=JB4_N (Pin 10)

