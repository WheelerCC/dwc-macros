; locate-${face}-face.g — find ${face} face of workpiece
<%
    axis         = "X" if face in ("left", "right") else "Y"
    probing_sign = ""  if face in ("left", "front") else "-"
    retract_sign = "-" if face in ("left", "front") else ""
    offset_sign  = "+" if face in ("left", "front") else "-"
%>\

var probeOffset = 0.891
var coarseMove = 20
var fineMove = 1.5
var fineProbeCount = 5
var readings = vector(var.fineProbeCount, 0.0)

if exists(param.Y)
    set var.coarseMove = param.Y

G91 ; relative mode
G38.2 K1 ${axis}{${probing_sign}var.coarseMove} F200 ; coarse probe
if result != 0
    abort "Didn't find a face (fast)"
G0 ${axis}${retract_sign}0.7 ; retract a bit
G90 ; back to absolute mode

; --- repeated fine probes ---
while iterations < var.fineProbeCount
    G91 ; relative mode
    G38.2 K1 ${axis}{${probing_sign}var.fineMove} F30 ; fine probe
    if result != 0
        abort "Didn't find a face (fine probe)"
    G90 ; back to absolute mode
    set var.readings[iterations] = move.axes[${"0" if axis == "X" else "1"}].machinePosition
    echo "Probe " ^ iterations ^ ": " ^ var.readings[iterations]
    G91 ; relative mode
    G0 ${axis}${retract_sign}0.7 ; retract between fine probes
    G90 ; back to absolute mode

; --- average after dropping highest and lowest ---
var trimmedSum = (var.readings[0] + var.readings[1] + var.readings[2] + var.readings[3] + var.readings[4]) - min(var.readings) - max(var.readings)
var trimmedAvg = var.trimmedSum / (var.fineProbeCount - 2)

; --- move to averaged position ---
G53 G0 ${axis}{var.trimmedAvg}

## if exists(param.S)
; caller will handle positioning
## else
##     G53 G0 Z{global.Z_MAX} ; raise Z clear
##     G91 ; relative mode
##     G0 ${axis}{${probing_sign}1${offset_sign}var.probeOffset} ; move to face + probe offset
##     G90 ; back to absolute mode
