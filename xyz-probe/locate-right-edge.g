; locate-right-edge.g — find right edge of workpiece

var probeOffset = 0.891
var coarseMove = 5
var fineMove = 1.5

if exists(param.Y)
    set var.coarseMove = param.Y

G91                                     ; relative mode
G38.2 K1 X{-var.coarseMove} F200        ; coarse probe
if result != 0
    abort "Didn't find an edge (fast)"
G0 X1                                   ; retract a bit
G38.2 K1 X{-var.fineMove} F50           ; fine probe
if result != 0
    abort "Didn't find an edge (slow)"
G0 X1                                   ; retract a bit
G90                                     ; back to absolute mode

; caller will handle positioning
