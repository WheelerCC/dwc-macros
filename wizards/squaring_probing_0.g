; squaring_probing_0.g — Squaring probing sequence
;
; Parameters (all required):
;   A  — A0 X position (approach for probe 0, back face)
;   B  — A0 Y position
;   C  — A1 X position (approach for probe 1, back face)
;   D  — A1 Y position
;   E  — A2 X position (approach for probe 2, right face)
;   F  — A2 Y position
;   H  — A3 X position (approach for probe 3, right face)
;   I  — A3 Y position
;   S  — safe Z height (travel height)
;   Z  — probing Z height (height at which to probe)
;
; Results are stored in globals:
;   global.b0_x, global.b0_y
;   global.b1_x, global.b1_y
;   global.b2_x, global.b2_y
;   global.b3_x, global.b3_y

; --- Validate parameters ---
if !exists(param.A) || !exists(param.B)
    abort "squaring_probing_0: missing param.A / param.B (A0 X/Y)"
if !exists(param.C) || !exists(param.D)
    abort "squaring_probing_0: missing param.C / param.D (A1 X/Y)"
if !exists(param.E) || !exists(param.F)
    abort "squaring_probing_0: missing param.E / param.F (A2 X/Y)"
if !exists(param.H) || !exists(param.I)
    abort "squaring_probing_0: missing param.H / param.I (A3 X/Y)"
if !exists(param.S)
    abort "squaring_probing_0: missing param.S (safe Z)"
if !exists(param.Z)
    abort "squaring_probing_0: missing param.Z (probing Z)"

; --- Declare result globals ---
global b0_x = 0.0
global b0_y = 0.0
global b1_x = 0.0
global b1_y = 0.0
global b2_x = 0.0
global b2_y = 0.0
global b3_x = 0.0
global b3_y = 0.0

G90                                     ; absolute mode
G21                                     ; mm units

; ============================================================
; B0 — probe back face at A0
; ============================================================
G0 Z{param.S}                           ; rise to safe Z
G0 X{param.A} Y{param.B}               ; move to A0 XY
G0 Z{param.Z}                           ; descend to probing Z
M98 P"xyz-probe/locate-back-face.g"    ; probe back face
set global.b0_x = move.axes[0].machinePosition
set global.b0_y = move.axes[1].machinePosition

; ============================================================
; B1 — probe back face at A1
; ============================================================
G0 Z{param.S}                           ; rise to safe Z
G0 X{param.C} Y{param.D}               ; move to A1 XY
G0 Z{param.Z}                           ; descend to probing Z
M98 P"xyz-probe/locate-back-face.g"    ; probe back face
set global.b1_x = move.axes[0].machinePosition
set global.b1_y = move.axes[1].machinePosition

; ============================================================
; B2 — probe right face at A2
; ============================================================
G0 Z{param.S}                           ; rise to safe Z
G0 X{param.E} Y{param.F}               ; move to A2 XY
G0 Z{param.Z}                           ; descend to probing Z
M98 P"xyz-probe/locate-right-face.g"   ; probe right face
set global.b2_x = move.axes[0].machinePosition
set global.b2_y = move.axes[1].machinePosition

; ============================================================
; B3 — probe right face at A3
; ============================================================
G0 Z{param.S}                           ; rise to safe Z
G0 X{param.H} Y{param.I}               ; move to A3 XY
G0 Z{param.Z}                           ; descend to probing Z
M98 P"xyz-probe/locate-right-face.g"   ; probe right face
set global.b3_x = move.axes[0].machinePosition
set global.b3_y = move.axes[1].machinePosition

; ============================================================
; Return to safe Z then back to A0
; ============================================================
G0 Z{param.S}                           ; rise to safe Z
G0 X{param.A} Y{param.B}               ; return to A0 XY

echo "squaring_probing_0 complete"
echo "B0: (" ^ global.b0_x ^ ", " ^ global.b0_y ^ ")"
echo "B1: (" ^ global.b1_x ^ ", " ^ global.b1_y ^ ")"
echo "B2: (" ^ global.b2_x ^ ", " ^ global.b2_y ^ ")"
echo "B3: (" ^ global.b3_x ^ ", " ^ global.b3_y ^ ")"
