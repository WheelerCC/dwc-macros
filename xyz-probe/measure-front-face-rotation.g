; Usage: M98 P"0:/macros/XYZ-Probe/measure-front-face-rotation.g" Y{probeY} Xmin{leftX} Xmax{rightX}

; All coordinates in machine coordinates

; --- Parameters ---
; param.Y     = Y coordinate (distance into the part)
; param.XMIN  = left probing X position
; param.XMAX  = right probing X position

if !exists(param.A)
    abort "You must provide A parameters"

M400 ; This macro can be called whilst the commmand buffer is not yet empty, hence the incorrect 'starting coordinates' are recorded. 

var xmin = move.axes[0].machinePosition
var yall = move.axes[1].machinePosition
var xmax = var.xmin+param.A

M98 P"0:/macros/XYZ-Probe/locate-front-edge.g" S1 Y10
echo result
if result != 0
    abort "locate-front-edge failed"
M400 ; Always ensure the command buffer is empty before accessing machine positions, otherwise moves could still be in progress and the machinePosition would report its ACTUAL mid move coordinate
var frontEdgeLeft = move.axes[1].machinePosition+1

G53 G0 X{var.xmin} Y{var.yall}
G53 G0 X{var.xmax} Y{var.yall}

M98 P"0:/macros/XYZ-Probe/locate-front-edge.g" S1 Y10
echo result
if result != 0
    abort "locate-front-edge failed"
M400 ; Always ensure the command buffer is empty before accessing machine positions, otherwise moves could still be in progress and the machinePosition would report its ACTUAL mid move coordinate
var frontEdgeRight = move.axes[1].machinePosition+1

G53 G0 X{var.xmax} Y{var.yall}

; e.g. 
; Left edge is 22.5125
; Right edge is 21.529688
; Distance between measured points is 300.00
; tan0 = opp/adj = (rightEdge-leftEdge)/distanceBetweenPoints
; 0 = atan(opp/adj) = atan((rightEdge-leftEdge)/distanceBetweenPoints) = atan2((rightEdge-leftEdge), 300)
var antiClockwiseRotation = (180/pi)*atan2(var.frontEdgeRight-var.frontEdgeLeft,var.xmax-var.xmin)
echo "Front face is rotated ", var.antiClockwiseRotation, ", current coordinate rotation is set to ", move.rotation.angle
