M98 P"0:/macros/XYZ-Probe/locate-left-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-left-edge failed"
var leftEdgeFront = move.axes[0].machinePosition+1
var distanceBetweenPoints = 190
G91                      ; relative mode
G0 X-2
G0 Y{var.distanceBetweenPoints} ; retract a bit
G90                      ; back to absolute mode

M98 P"0:/macros/XYZ-Probe/locate-left-edge.g" S1 Y30
echo result
if result != 0
    abort "locate-left-edge failed"
var leftEdgeRear = move.axes[0].machinePosition+1

G91                      ; relative mode
G0 X-2
G0 Y{-var.distanceBetweenPoints} ; retract a bit
G90                      ; back to absolute mode

echo "Front edge is", {var.leftEdgeFront}
echo "Rear edge is", {var.leftEdgeRear}

; e.g. 
; Left edge is 22.5125
; Right edge is 21.529688
; Distance between measured points is 300.00
; tan0 = opp/adj = (rightEdge-leftEdge)/distanceBetweenPoints
; 0 = atan(opp/adj) = atan((rightEdge-leftEdge)/distanceBetweenPoints) = atan2((rightEdge-leftEdge), 300)
var antiClockwiseRotation = (180/pi)*atan2(var.distanceBetweenPoints,var.leftEdgeRear-var.leftEdgeFront)-90
echo "Measured face is ", var.antiClockwiseRotation, ", current coordinate rotation is set to ", move.rotation.angle
