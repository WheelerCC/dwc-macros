M98 P"0:/macros/XYZ-Probe/locate-back-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-back-edge failed"
var backEdgeLeft = move.axes[1].machinePosition-1
var distanceBetweenPoints = 300
G91                      ; relative mode
G0 Y2
G0 X{var.distanceBetweenPoints} ; retract a bit
G90                      ; back to absolute mode

M98 P"0:/macros/XYZ-Probe/locate-back-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-back-edge failed"
var backEdgeRight = move.axes[1].machinePosition-1

G91                      ; relative mode
G0 Y2
G0 X{-var.distanceBetweenPoints} ; retract a bit
G90                      ; back to absolute mode

echo "Left edge is", {var.backEdgeLeft}
echo "Right edge is", {var.backEdgeRight}

; e.g. 
; Left edge is 22.5125
; Right edge is 21.529688
; Distance between measured points is 300.00
; tan0 = opp/adj = (rightEdge-leftEdge)/distanceBetweenPoints
; 0 = atan(opp/adj) = atan((rightEdge-leftEdge)/distanceBetweenPoints) = atan2((rightEdge-leftEdge), 300)
var antiClockwiseRotation = (180/pi)*atan2(var.backEdgeRight-var.backEdgeLeft,var.distanceBetweenPoints)
echo "Measured face is ", var.antiClockwiseRotation, ", current coordinate rotation is set to ", move.rotation.angle
