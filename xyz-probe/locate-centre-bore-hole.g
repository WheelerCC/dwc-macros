M98 P"0:/macros/XYZ-Probe/locate-left-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-left-edge failed"
var rightX = move.axes[0].machinePosition+1

M98 P"0:/macros/XYZ-Probe/locate-right-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-right-edge failed"
var leftX = move.axes[0].machinePosition-1

var midX = (var.rightX + var.leftX)/2
G53 G1 X{var.midX} F500

M98 P"0:/macros/XYZ-Probe/locate-front-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-front-edge failed"
var backY = move.axes[1].machinePosition+1

M98 P"0:/macros/XYZ-Probe/locate-back-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-back-edge failed"
var frontY = move.axes[1].machinePosition-1

var midY = (var.backY + var.frontY)/2
G53 G1 Y{var.midY} F500