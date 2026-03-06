; locate-${edge}-edge.g — find ${edge} edge of workpiece
<%
    # axis: X for left/right, Y for front/back
    ax = "X" if edge in ("left", "right") else "Y"
    # prefix: "" for positive probe direction, "-" for negative
    s = "" if edge in ("left", "front") else "-"
    rs = "-" if edge in ("left", "front") else ""    # retract is opposite
    # arithmetic operator matching probe direction
    op = "+" if edge in ("left", "front") else "-"
%>\

var probeOffset = 0.891
var coarseMove = 5
var fineMove = 1.5

if exists(param.Y)
    set var.coarseMove = param.Y

G91                         ; relative mode
G38.2 K1 ${ax}{${s}var.coarseMove} F200
if result != 0
    abort "Didn't find an edge (fast)"
G0 ${ax}${rs}1              ; retract a bit
G38.2 K1 ${ax}{${s}var.fineMove} F50
if result != 0
    abort "Didn't find an edge (slow)"
G0 ${ax}${rs}1              ; retract a bit
G90                         ; back to absolute mode

if exists(param.S)
    ; caller will handle positioning
else
    G53 G0 Z{global.Z_MAX}
    G91                         ; relative mode
    G0 ${ax}{${s}1${op}var.probeOffset} ; move past contact point by offset
    G90                         ; back to absolute mode
