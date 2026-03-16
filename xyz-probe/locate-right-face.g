; locate-right-face.g — find right face of workpiece

var probeOffset = 0.891
var coarseMove = 20
var fineMove = 1.5
var fineProbeCount = 5
var probedSum = 0.0

if exists(param.Y)
    set var.coarseMove = param.Y

G91                                     ; relative mode
G38.2 K1 X{-var.coarseMove} F200        ; coarse probe
if result != 0
    abort "Didn't find a face (fast)"
G0 X0.7                                 ; retract a bit
G90                                     ; back to absolute mode

; --- repeated fine probes ---
while iterations < var.fineProbeCount
    G91                                 ; relative mode
    G38.2 K1 X{-var.fineMove} F30       ; fine probe
    if result != 0
        abort "Didn't find a face (fine probe)"
    G90                                 ; back to absolute mode
    set var.probedSum = var.probedSum + move.axes[0].machinePosition
    G91                                 ; relative mode
    G0 X0.7                             ; retract between fine probes
    G90                                 ; back to absolute mode

; --- move to averaged position ---
G53 G0 X{var.probedSum / var.fineProbeCount}

; caller will handle positioning
