; locate-back-face.g — find back face of workpiece

var probeOffset = 0.891
var coarseMove = 20
var fineMove = 1.5
var fineProbeCount = 3
var probedSum = 0.0

if exists(param.Y)
    set var.coarseMove = param.Y

G91                                     ; relative mode
G38.2 K1 Y{-var.coarseMove} F200        ; coarse probe
if result != 0
    abort "Didn't find a face (fast)"
G0 Y1                                   ; retract a bit
G90                                     ; back to absolute mode

; --- repeated fine probes ---
while iterations < var.fineProbeCount
    G91                                 ; relative mode
    G38.2 K1 Y{-var.fineMove} F50       ; fine probe
    if result != 0
        abort "Didn't find a face (fine probe)"
    G90                                 ; back to absolute mode
    set var.probedSum = var.probedSum + move.axes[{"0" if axis == "X" else "1"}].machinePosition
    G91                                 ; relative mode
    G0 Y1                               ; retract between fine probes
    G90                                 ; back to absolute mode

; --- move to averaged position ---
G53 G0 Y{var.probedSum / var.fineProbeCount}

; caller will handle positioning
