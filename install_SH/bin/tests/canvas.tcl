catch {set w [canvas .c -height 800 -width 1000]}
pack $w
source [file join [file dirname [info script]] typedef.tcl]

proc tcl::mathfunc::line args {
    set Poly [PolyLine new {*}$args]
    list line [join [$Poly coords]]
}

proc tcl::mathfunc::point {text x y} {(
    # define the Point object
    [Point create ::$text $x $y];
    # Draw the intersection
    P1x=$x-20; P1y=$y;
    P1 = [Point new $P1x $P1y];
    P2x=$x+20; P2y=$y;
    P2 = [Point new $P2x $P2y];
    P3x=$x; P3y=$y-20;
    P3 = [Point new $P3x $P3y];
    P4x=$x; P4y=$y+20;
    P4 = [Point new $P4x $P4y];
    # Define the text Position
    Tx = $x+10; Ty = $y-10;
    T = [Point new $Tx $Ty];
    
    [$::w create {*}[(line($P1, $P2) )]
     $::w create {*}[(text($T,$text))]
     list line [list {*}[$P3 coords] {*}[$P4 coords]]]
)}

proc tcl::mathfunc::text {P text} {
    list text [$P coords] -text $text
}
			  

proc tcl::mathfunc::arc {O Rx Ry start extent} {(
    [lassign [$O coords] Ox Oy];
    x1 = $Ox-$Rx;
    x2 = $Ox+$Rx;
    y1 = $Oy-$Ry;
    y2 = $Oy+$Ry;
    [list arc $x1 $y1 $x2 $y2 -start $start -extent $extent]
    )}

proc tcl::mathfunc::circle {O R} {(
    [lassign [$O coords] Ox Oy];
    x1 = $Ox-$R;
    x2 = $Ox+$R;
    y1 = $Oy-$R;
    y2 = $Oy+$R;
    [list oval $x1 $y1 $x2 $y2]
)}

proc tcl::mathfunc::ellipse {O Rx Ry} {(
    [lassign [$O coords] Ox Oy];
    x1 = $Ox - $Rx;
    x2 = $Ox+$Rx;
    y1 = $Oy - $Ry;
    y2 = $Oy+$Ry;
    [list oval $x1 $y1 $x2 $y2]
)}

proc tcl::mathfunc::polygon args {
    
    list polygon $args
}

proc tcl::mathfunc::rectangle {O L H} {(
    [lassign [$O coords] Ox Oy];
    x1 = $Ox - double($L)/2;
    x2 = $Ox + double($L)/2;
    y1 = $Ox - double($H)/2;
    y2 = $Ox + double($H)/2;
    [list rect $x1 $y1 $x2 $y2]
    )}

proc tcl::mathfunc::triangle {A B C} {
    lassign $A Xa Ya
    lassign $B Xb Yb
    lassign $C Xc Yc
    list polygon $Xa $Ya $Xb $Yb $Xc $Yc
 }

proc tcl::mathfunc::roundRect {O L H rx {ry {}}} {(
    [puts [info level 0]];
    [lassign [$O coords] Ox Oy];
    $ry eq {} ? (ry = $rx): "" ;
    # Coordinate of corner of the box
    Ax = $Ox - double($L)/2;     Ay = $Oy - double($H)/2;
    Cx = $Ox + double($L)/2;   Cy = $Oy + double($H)/2;
    # create the Points 
    A=[Point new $Ax $Ay];  B=[Point new $Cx $Ay];
    C=[Point new $Cx $Cy];  D=[Point new $Ax $Cy];
    # coordinates of center of arcs
    O1x = $Ax+$rx; O1y = $Ay+$ry;
    O2x = $Cx-$rx; O2y = $Ay+$ry;
    O3x = $Cx-$rx; O3y = $Cy-$ry;
    O4x = $Ax+$rx; O4y = $Cy-$ry;
    # create the arc center points
    O1=[Point new $O1x $O1y]; O2=[Point new $O2x $O2y];
    O3=[Point new $O3x $O3y]; O4=[Point new $O4x $O4y];
    # create the segment limits (joining the arcs)
    S1=[Point new $O1x $Ay];  S2=[Point new $O2x $Ay];
    S3=[Point new $Cx $O2y];  S4=[Point new $Cx $O3y];
    S5=[Point new $O3x $Cy];  S6=[Point new $O4x $Cy];
    S7=[Point new $Ax $O4y];  S8=[Point new $Ax $O1y];
    
    [# up left
     $::w create {*}[( arc($O1, $rx, $ry, 90, 90))] -style arc
     #up
     $::w create {*}[( line($S1, $S2) )]
     #up right
     $::w create {*}[( arc($O2, $rx, $ry, 0, 90) )] -style arc
     # right
     $::w create {*}[( line($S3, $S4) )]
     #bottom right
     $::w create {*}[( arc($O3, $rx, $ry, 0, -90) )] -style arc
     #bottom
     $::w create {*}[( line($S5, $S6) )]
     # bottom left
     $::w create {*}[( arc($O4, $rx, $ry, -90, -90) )] -style arc
    ]; # left
    line($S7, $S8)
)}
    
# .c create {*}[(point("I", 500, 400))]
# .c create {*}[(roundRect("I", 168, 100, 34))]

.c create {*}[(point("A", 300, 700))]
.c create {*}[(point("B", 800, 600))]
.c create {*}[(point("C", 500, 100))]

.c create {*}[(line("A", "B", "C", "A"))]

.c create {*}[(point("Mab",
    ([lindex [A coords] 0]+[lindex [B coords] 0])/2.0,
    ([lindex [A coords] 1]+[lindex [B coords] 1])/2.0)
)]
.c create {*}[(point("Mac",
    ([lindex [A coords] 0]+[lindex [C coords] 0])/2.0,
    ([lindex [A coords] 1]+[lindex [C coords] 1])/2.0)
)]
.c create {*}[(point("Mbc",
    ([lindex [B coords] 0]+[lindex [C coords] 0])/2.0,
    ([lindex [B coords] 1]+[lindex [C coords] 1])/2.0)
)]
.c create {*}[(line("B","Mac"))]
.c create {*}[(line("A","Mbc"))]
.c create {*}[(line("C","Mab"))]

.c create {*}[(point("G",
    ([lindex [A coords] 0]+[lindex [B coords] 0]+[lindex [C coords] 0])/3.0,
    ([lindex [A coords] 1]+[lindex [B coords] 1]+[lindex [C coords] 1])/3.0)
)]
