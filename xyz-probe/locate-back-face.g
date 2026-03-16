; locate-back-face.g — find back face of workpiece

var probeOffset = 0.891
var coarseMove = 20
var fineMove = 1.5
var fineProbeCount = 5
var readings = vector(var.fineProbeCount, 0.0)

if exists(param.Y)
    set var.coarseMove = param.Y

G91                                     ; relative mode
G38.2 K1 Y{-var.coarseMove} F200        ; coarse probe
if result != 0
    abort "Didn't find a face (fast)"
G0 Y0.7                                 ; retract a bit
G90                                     ; back to absolute mode

; --- repeated fine probes ---
while iterations < var.fineProbeCount
    G91                                 ; relative mode
    G38.2 K1 Y{-var.fineMove} F30       ; fine probe
    if result != 0
        abort "Didn't find a face (fine probe)"
    G90                                 ; back to absolute mode
    M400                                ; wait for move to complete
    set var.readings[iterations] = move.axes[1].machinePosition
    echo "Probe " ^ iterations ^ ": " ^ var.readings[iterations]
    G91                                 ; relative mode
    G0 Y0.7                             ; retract between fine probes
    G90                                 ; back to absolute mode

; --- average after dropping highest and lowest ---
var trimmedSum = (var.readings[0] + var.readings[1] + var.readings[2] + var.readings[3] + var.readings[4]) - min(var.readings) - max(var.readings)
var trimmedAvg = var.trimmedSum / (var.fineProbeCount - 2)
echo "Trimmed average: " ^ var.trimmedAvg

; --- store result in global for caller to read ---
if !exists(global.probeResult)
    global probeResult = 0.0
set global.probeResult = var.trimmedAvg

; --- move to averaged position ---
G53 G0 Y{var.trimmedAvg}
M400                                    ; wait for move to complete

; caller will handle positioning
