; SavePoints.g
; Macro to store two XY points after manual positioning

;(x0, y1) +--------------------+ (x1, y1)
;         |                    |
;         |                    |
;         |                    |
;(x0, y0) +--------------------+ (x1, y0)

; --- First point ---
M291 P"Jog the toolhead to the FIRST point, then click OK" S2
M400 ; Always ensure the command buffer is empty before accessing machine positions, otherwise moves could still be in progress and the machinePosition would report the mid-move coordinate
var x0 = move.axes[0].machinePosition
var y0 = move.axes[1].machinePosition
var z = move.axes[2].machinePosition
echo {"First point saved: X" ^ {var.x0} ^ " Y" ^ {var.y0}}

; --- Second point ---
M291 P"Jog the toolhead to the SECOND point, then click OK" S2
M400 ; Always ensure the command buffer is empty before accessing machine positions, otherwise moves could still be in progress and the machinePosition would report the mid-move coordinate
var x1 = move.axes[0].machinePosition
var y1 = move.axes[1].machinePosition
echo {"Second point saved: X" ^ {var.x1} ^ " Y" ^ {var.y1}}

var edgeInset = 5
var probingStartDistance = 10
var distanceBeneathSurface = 1

G53 G0 Z{move.axes[2].max}

G53 G0 X{var.x0+var.edgeInset} Y{var.y0-var.probingStartDistance}
G53 G0 Z{var.z-var.distanceBeneathSurface}
M98 P"0:/macros/XYZ-Probe/measure-front-face-rotation.g" A{var.x1-var.x0-(2*var.edgeInset)}
G53 G0 Z{move.axes[2].max}

G53 G0 X{var.x1+var.probingStartDistance} Y{var.y0+var.edgeInset}
G53 G0 Z{var.z-var.distanceBeneathSurface}
;M98 P"0:/macros/XYZ-Probe/measure-right-face-rotation.g" X{var.x1} YMIN{var.y1} YMAX{var.y2}
G53 G0 Z{move.axes[2].max}

G53 G0 X{var.x1+var.probingStartDistance} Y{var.y0+var.edgeInset}
G53 G0 Z{var.z-var.distanceBeneathSurface}
;M98 P"0:/macros/XYZ-Probe/measure-rear-face-rotation.g" Y{var.y2} XMIN{var.x3} XMAX{var.x2}
G53 G0 Z{move.axes[2].max}

G53 G0 X{var.x1+var.probingStartDistance} Y{var.y0+var.edgeInset}
G53 G0 Z{var.z-var.distanceBeneathSurface}
;M98 P"0:/macros/XYZ-Probe/measure-left-face-rotation.g" X{var.x0} YMIN{var.y0} YMAX{var.y3}
G53 G0 Z{move.axes[2].max}

G53 G0 X{var.x0} Y{var.y0}
G53 G0 Z{var.z}



