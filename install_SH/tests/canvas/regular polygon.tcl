# Adapted from https://wiki.tcl-lang.org/page/Regular+Polygons+2
console show

 proc rp2 {x0 y0 x1 y1 args} {
    
     array set V {-sides 0 -start 90 -extent 360} ;# Default values
     
    foreach {a value} $args {
        if {! [info exists V($a)]} {error "unknown option $a"}
        if {$value == {}} {error "value of \"$a\" missing"}
        set V($a) $value
    }
    if {$V(-extent) == 0} {return {}}
    
     [(	 xm = ($x0+$x1)/2.;
	 ym = ($y0+$y1)/2.; 
	 rx = $xm-$x0;
	 ry = $ym-$y0;
	 n = $V(-sides); )]
     
     if {$n == 0} {(                              
	 # 0 sides => circle
	 n = round(($rx+$ry)*0.5);
	 [if {$n < 2} (n=4)];
     )}
    
     [(
	 # expr mode
	 dir = ($V(-extent) < 0 ? -1 : 1);# Extent can be negative
	 
	 [if {abs($V(-extent)) > 360} {(
	     V(-extent) = $dir * (abs($V(-extent)) % 360)
	     )}];
	 
	 step = $dir * 360.0 / $n;
	 numsteps = 1 + double($V(-extent)) / $step;
	 xy = {};
	 DEG2RAD = 4*atan(1)*2/360;  )]
	 
     for {set i 0} {$i < int($numsteps)} {incr i} {
	 [(  rad=($V(-start) - $i * $step) * $DEG2RAD;
	     x = $rx*cos($rad);
	     y = $ry*sin($rad); )]
	 
	 lappend xy [($xm + $x)] [($ym - $y)]
     }
    # Figure out where last segment should end
     if {$numsteps != int($numsteps)} {(
	 # expr mode
	 # Vector V1 is last drawn vertext (x,y) from above
	 # Vector V2 is the edge of the polygon
	 rad2 = ($V(-start) - int($numsteps) * $step) * $DEG2RAD;
	 x2 = $rx*cos($rad2) - $x; 
	 y2 = $ry*sin($rad2) - $y;
 
	 # Vector V3 is unit vector in direction we end at
	 rad3 = ($V(-start) - $V(-extent)) * $DEG2RAD;
	 x3 = cos($rad3);
	 y3 = sin($rad3);
 
	 # Find where V3 crosses V1+V2 => find j s.t.  V1 + kV2 = jV3
	 j = ($x*$y2 - $x2*$y) / ($x3*$y2 - $x2*$y3);
 
	 [lappend xy [($xm + $j * $x3)] [($ym - $j * $y3)]];
      )}

     return $xy
 }
 
 # Now for code to demonstrate and test it
 proc DrawIt {args} {
    global S
    
     foreach {x0 y0 x1 y1} [.c cget -scrollregion] break
     
     [( bbox = (20, 20, $x1-20, $y1 -20); )]
    
    .c delete poly
     set xy [rp2 {*}$bbox -sides $S(sides) -start $S(start) -extent 360]
    .c create poly $xy -fill {} -outline black -width 2 -dash - -tag poly
     set xy [rp2 {*}$bbox -sides $S(sides) -start $S(start) -extent $S(extent)]
    .c create poly $xy -fill red -outline {} -tag poly
    .c create line $xy -fill red -fill black -width 3 -tag poly
 }
 
 pack [frame .bottom] -side bottom -fill x
 pack [canvas .c -width 500 -height 500 -bd 2 -relief raised] -fill both -expand 1
 bind .c <Configure> {%W config -scrollregion [list 0 0 %w %h] ; DrawIt}
 
 scale .sides -variable S(sides) -orient h -from 0 -to 20 -label Sides -relief ridge
 scale .start -variable S(start) -orient h -from 0 -to 360 -label Start -relief ridge
 scale .extent -variable S(extent) -orient h -from -360 -to 360 -label Extent -relief ridge
 
 pack .sides .start .extent -side left -in .bottom
 array set S {extent 135 sides 4 start 0}
 trace add variable S write DrawIt


 proc rp2-orig {x0 y0 x1 y1 args} {
    
    array set V {-sides 0 -start 90 -extent 360} ;# Default values
    foreach {a value} $args {
        if {! [info exists V($a)]} {error "unknown option $a"}
        if {$value == {}} {error "value of \"$a\" missing"}
        set V($a) $value
    }
    if {$V(-extent) == 0} {return {}}
    
    set xm [expr {($x0+$x1)/2.}]
    set ym [expr {($y0+$y1)/2.}]
    set rx [expr {$xm-$x0}]
    set ry [expr {$ym-$y0}]
 
    set n $V(-sides)
    if {$n == 0} {                              ;# 0 sides => circle
        set n [expr {round(($rx+$ry)*0.5)}]
        if {$n < 2} {set n 4}
    }
    
    set dir [expr {$V(-extent) < 0 ? -1 : 1}]   ;# Extent can be negative
    if {abs($V(-extent)) > 360} {
        set V(-extent) [expr {$dir * (abs($V(-extent)) % 360)}]
    }
    set step [expr {$dir * 360.0 / $n}]
    set numsteps [expr {1 + double($V(-extent)) / $step}]
                              
    set xy {}
    set DEG2RAD [expr {4*atan(1)*2/360}]
                              
    for {set i 0} {$i < int($numsteps)} {incr i} {
        set rad [expr {($V(-start) - $i * $step) * $DEG2RAD}]
        set x [expr {$rx*cos($rad)}]
        set y [expr {$ry*sin($rad)}]
        lappend xy [expr {$xm + $x}] [expr {$ym - $y}]
    }
 
    # Figure out where last segment should end
    if {$numsteps != int($numsteps)} {
        # Vecter V1 is last drawn vertext (x,y) from above
        # Vector V2 is the edge of the polygon
        set rad2 [expr {($V(-start) - int($numsteps) * $step) * $DEG2RAD}]
        set x2 [expr {$rx*cos($rad2) - $x}]
        set y2 [expr {$ry*sin($rad2) - $y}]
 
        # Vector V3 is unit vector in direction we end at
        set rad3 [expr {($V(-start) - $V(-extent)) * $DEG2RAD}]
        set x3 [expr {cos($rad3)}]
        set y3 [expr {sin($rad3)}]
 
        # Find where V3 crosses V1+V2 => find j s.t.  V1 + kV2 = jV3
        set j [expr {($x*$y2 - $x2*$y) / ($x3*$y2 - $x2*$y3)}]
 
        lappend xy [expr {$xm + $j * $x3}] [expr {$ym - $j * $y3}]
    }
    return $xy
 }
