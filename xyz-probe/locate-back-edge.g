; probe-x.g — find left edge of workpiece and set X0

var probeOffset = 0.891         
var coarseMove = 5

if exists(param.Y)
    set var.coarseMove = param.Y

G91                      ; relative mode
G38.2 K1 Y{-var.coarseMove} F200
echo result
if result != 0
    abort "Didn't find an edge (fast)"
;G38.2 K1 X10 F100  ; probe negative X direction
G0 Y1                    ; retract a bit
G38.2 K1 Y{-1.5} F50
if result != 0
    abort "Didn't find an edge (slow)"
G0 Y1                    ; retract a bit
G90                      ; back to absolute mode

if exists(param.S)
    
else
    G53 G0 Z{global.Z_MAX}
    G91                      ; relative mode
    G0 Y{-1-var.probeOffset} ; retract a bit
    G90                      ; back to absolute mode

;G10 L20 P1 X{move.axes[0].machinePosition + var.offset} ; set X0 in G54
;M117 X0 set