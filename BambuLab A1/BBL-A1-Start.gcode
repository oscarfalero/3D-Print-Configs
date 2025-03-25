;===== machine: A1 =========================
;===== date: 20240620 =====================
G392 S0
M9833.2
;M400
;M73 P1.717

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}
M104 S150
M140 S[bed_temperature_initial_layer_single]

;=====start printer sound ===================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18 
;=====start printer sound ===================

;=====avoid end stop =================
G91
M17 Z0.3 ; lower the z-motor current
G380 S2 Z1 F600
G380 S3 Z-0.5 F600 ; avoid hitting top z and noise
G90

;===== reset machine status =================
;M290 X39 Y39 Z8
M204 S6000

M630 S0 P0
G91
M17 Z0.3 ; lower the z-motor current

G90
M17 X0.65 Y1.2 Z0.6 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

M1002 gcode_claim_action : 13

G28 X
G91
G1 Z-5 F600
G90
G0 X128 F30000
G0 Y254 F3000
G91
G1 Z-5 F600

M109 S25 H140

G28 Z P0 T140; home z with low precision,permit 140deg temperature
M104 S{nozzle_temperature_initial_layer[initial_extruder]}

M1002 judge_flag build_plate_detect_flag
M622 S1
  G39.4
  G90
  G1 Z5 F1200
M623

;M400
;M73 P1.717

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24

M400
;G392 S1
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on

G90
G1 X-28.5 F30000
G1 X-48.2 F3000

M620 M ;enable remap
M620 S[initial_no_support_extruder]A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S[nozzle_temperature_initial_layer]
    M104 S250
    M400
    T[initial_no_support_extruder]
    G1 X-48.2 F3000
    M400

    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}
    M109 S250 ;set nozzle to common flush temp
    M106 P1 S0
    G92 E0
    G1 E30 F200
    M400
    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}
M621 S[initial_no_support_extruder]A

M109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300
G92 E0
G1 E30 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S170
G92 E0
G1 E30 F200
M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}
G92 E0
G1 E-0.5 F300


;G392 S0

M400
M106 P1 S0
;===== prepare print temperature and material end =====

;M400
;M73 P1.717

;===== auto extrude cali start =========================
M975 S1
;G392 S1

G90
M83
T1000
G1 X-48.2 Z10 F1200
M400
M1002 set_filament_type:UNKNOWN

M412 S1 ;  ===turn on  filament runout detection===
M400 P10
M620.3 W1; === turn on filament tangle detection===
M400 S2

M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

;M1002 set_flag extrude_cali_flag=1
M1002 judge_flag extrude_cali_flag

M622 J1
    M1002 gcode_claim_action : 8

    M109 S{nozzle_temperature[initial_extruder]}
    G1 E10 F{outer_wall_volumetric_speed/2.4*60}
    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation
	M400
    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation    
        M400
    M623
    
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]
    M400
M623 ; end of "draw extrinsic para cali paint"

;G392 S0
;===== auto extrude cali end ========================
;===== Fix Chay Nhua Start ========================
M106 S150
M109 S180 ; prepare to wipe nozzle
M104 S140
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000 ; soft wipe and shake
G1 X-48.2 F3000
G1 X-38.2 F12000 ; soft wipe and shake
G1 X-48.2 F3000
;===== Fix Chay Nhua End ========================
;M400
;M73 P1.717
;===== mech mode fast check start =====================
; M1002 gcode_claim_action : 3

; G1 X128 Y128 F20000
; G1 Z5 F1200
; M400 P200
; M970.3 Q1 A5 K0 O3
; M974 Q1 S2 P0

; M970.2 Q1 K1 W58 Z0.1
; M974 S2

; G1 X128 Y128 F20000
; G1 Z5 F1200
; M400 P200
; M970.3 Q0 A10 K0 O1
; M974 Q0 S2 P0

; M970.2 Q0 K1 W78 Z0.1
; M974 S2

; M975 S1
; G1 F30000
; G1 X0 Y5
; G28 X ; re-home XY

; G1 Z4 F1200

;===== mech mode fast check end =======================

;M400
;M73 P1.717

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14

M975 S1
M211 S; push soft endstop status
M211 X0 Y0 Z0 ;turn off Z axis endstop
;===== brush material wipe nozzle =====
G90
G1 X30 F30000
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X35 F30000
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200
;===== brush material wipe nozzle end =====
G90
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000
G1 X128
G1 Y261
G0 Z-1.01 F1200      ; stop the nozzle
G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

;===== wipe nozzle end ================================

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

G90
G1 Z5 F1200
G1 X0 Y0 F30000
G29.2 S1 ; turn on ABL

M622 J1
    M1002 gcode_claim_action : 1
    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500 ; save cali data
M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623

;===== home after wipe mouth end =======================

;M400
;M73 P1.717

G1 X80.000 Y-0.500 F30000
G1 Z0.300 F1200
M400
G2814 Z0.32

M104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print

;===== nozzle load line ===============================
;G90
;M83
;G1 Z5 F1200
;G1 X88 Y-0.5 F20000
;G1 Z0.3 F1200

;M109 S{nozzle_temperature_initial_layer[initial_extruder]}

;G1 E2 F300
;G1 X168 E4.989 F6000
;G1 Z1 F1200
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400
    M900 S
    M900 C
    G90
    M83

    M109 S{nozzle_temperature_initial_layer[initial_extruder]}
    G0 X100 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}
    G0 X105 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X110 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X115 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X120 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X125 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400

M900 R

M1002 judge_flag extrude_cali_flag
M622 J1
    ; G90
    ; G1 X130.000 Y-0.500 F30000
    G91
    G1 Z-0.700 F1200
    G90
    M83
    G0 X150 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}
    G0 X155 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X160 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X165 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X170 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X175 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400
M623

G1 Z0.2

;M400
;M73 P1.717

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type}
{if curr_bed_type=="Textured PEI Plate"}
G29.1 Z{-0.02} ; for Textured PEI Plate
{endif}

M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4