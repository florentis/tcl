# From wiki : https://wiki.tcl-lang.org/page/Drawing+rounded+rectangles
# Original Proc : 867 chars

 proc roundRect-Orig { w x0 y0 x3 y3 radius args } {

    set r [winfo pixels $w $radius]
    set d [expr { 2 * $r }]

    # Make sure that the radius of the curve is less than 3/8
    # size of the box!

    set maxr 0.75

    if { $d > $maxr * ( $x3 - $x0 ) } {
        set d [expr { $maxr * ( $x3 - $x0 ) }]
    }
    if { $d > $maxr * ( $y3 - $y0 ) } {
        set d [expr { $maxr * ( $y3 - $y0 ) }]
    }

    set x1 [expr { $x0 + $d }]
    set x2 [expr { $x3 - $d }]
    set y1 [expr { $y0 + $d }]
    set y2 [expr { $y3 - $d }]

    set cmd [list $w create polygon]
    lappend cmd $x0 $y0
    lappend cmd $x1 $y0
    lappend cmd $x2 $y0
    lappend cmd $x3 $y0
    lappend cmd $x3 $y1
    lappend cmd $x3 $y2
    lappend cmd $x3 $y3
    lappend cmd $x2 $y3
    lappend cmd $x1 $y3
    lappend cmd $x0 $y3
    lappend cmd $x0 $y2
    lappend cmd $x0 $y1
    lappend cmd -smooth 1
    return [eval $cmd $args]
 }

# "Math mode" proc : 477 chars / 390 chars less
proc roundRect-SH {w x0 y0 x3 y3 radius args} {(
    r = [winfo pixels $w $radius];
    d = 2*$r;
    maxr = 0.75;

    [if { $d > $maxr * ($x3 - $x0)} {(d = $maxr * ($x3 -$x0) )}];
    [if { $d > $maxr * ($y3 - $y0) } {(d = $maxr * ($x3 -$x0) )}];

    x1 = $x0+$d;
    x2 = $x3-$d;
    y1 = $y0+$d;
    y2 = $y3 - $d;
    
    Poly = (
	$x0, $y0, $x1, $y0, $x2, $y0,
	$x3, $y0, $x3, $y1, $x3, $y2,
	$x3, $y3, $x2, $y3, $x1, $y3,
	$x0, $y3, $x0, $y2, $x0, $y1 );
    
    [$w create polygon {*}$Poly -smooth 1 {*}$args]
)}


 grid [canvas .c -width 600 -height 300]
 grid [scale .s -orient horizontal \
          -label "Radius" \
          -variable rad -from 0 -to 200 \
          -command doit] \
    -sticky ew

 proc doit { args } {
    global rad

    .c delete rect
    roundRect-SH .c 100 50 500 250 $rad -fill white -outline black -tags rect

 }
    
console show
