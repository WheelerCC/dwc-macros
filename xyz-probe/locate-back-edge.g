; locate-back-edge.g — find back edge of workpiece

var probeOffset = 0.891
var coarseMove = 5
var fineMove = 1.5

if exists(param.Y)
    set var.coarseMove = param.Y

G91                                     ; relative mode
G38.2 K1 Y{-var.coarseMove} F200        ; coarse probe
if result != 0
    abort "Didn't find an edge (fast)"
G0 Y1                                   ; retract a bit
G38.2 K1 Y{-var.fineMove} F50           ; fine probe
if result != 0
    abort "Didn't find an edge (slow)"
G0 Y1                                   ; retract a bit
G90                                     ; back to absolute mode

if exists(param.S)
    ; caller will handle positioning
else
    G53 G0 Z{global.Z_MAX}              ; raise Z clear
    G91                                 ; relative mode
    G0 Y{-1-var.probeOffset}            ; move to edge + probe offset
    G90                                 ; back to absolute mode
