var toolNumber = 0

M581 P1 T0 S1 R0    ; Reenable the estop, aka Trigger T0 when stroke protection goes low (S0), trigger at any time (R0) 

G90                 ; back to absolute mode

;G10 L1 P{var.toolNumber} X0 Y0 Z0 ; Reset the axis tool offset 
T T{var.toolNumber} ; Select your tool ()
;G1 X?? Y?? Z?? F3000 ;Move the tool to your starting position 

G91                 ; relative mode
M558 K0 F250
G30 S-2 K0          ; Drive the tool into the endstop or custom input, stop there and apply the new tool offset with the given correction factor 
G0 Z0.6
M558 K0 F20
G30 S-2 K0          ; Drive the tool into the endstop or custom input, stop there and apply the new tool offset with the given correction factor 
G0 Z5

G90                 ; back to absolute mode

M581 P1 T0 S1 R-1    ; Disable the estop again, aka Trigger T0 when stroke protection goes low (S0), trigger at any time (R0) 
