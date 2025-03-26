;===================== date: 20240606 =====================
{if !spiral_mode && print_sequence != "by object"}
; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G17
G2 Z{layer_z + 0.4} I0.86 J0.86 P1 F20000 ; spiral lift a little
G1 Z{max_layer_z + 0.4}
G1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400 P300
M971 S11 C11 O0 ; take the timelapse photo
G92 E0
G1 X0 F18000
M623
{endif}
