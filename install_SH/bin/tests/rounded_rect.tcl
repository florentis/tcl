# From wiki : https://wiki.tcl-lang.org/page/Drawing+rounded+rectangles
# Original Proc : 867 chars

 proc roundRect1-Orig { w x0 y0 x3 y3 radius args } {

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
proc roundRect1-SH {w x0 y0 x3 y3 radius args} {(
    r = [winfo pixels $w $radius];
    d = 2*$r;
    # Make sure that the radius of the curve is less than 3/8
    # size of the box!
    maxr = 0.75;

    [if {$d > $maxr * ($x3 - $x0)} {( d = $maxr * ($x3 -$x0) )}];
    [if {$d > $maxr * ($y3 - $y0) } {( d = $maxr * ($x3 -$x0) )}];

    x1 = $x0+$d;
    x2 = $x3-$d;
    y1 = $y0+$d;
    y2 = $y3 - $d;
    
    [$w create polygon [(
	$x0, $y0, $x1, $y0, $x2, $y0,
	$x3, $y0, $x3, $y1, $x3, $y2,
	$x3, $y3, $x2, $y3, $x1, $y3,
	$x0, $y3, $x0, $y2, $x0, $y1 )]  -smooth 1 {*}$args]
)}

catch {
    grid [canvas .c -width 600 -height 300]
    grid [scale .s -orient horizontal \
	      -label "Radius" \
	      -variable rad -from 0 -to 200 \
	      -command doit] \
	-sticky ew
}
 proc doit { args } {
    global rad

    .c delete rect
    roundRect2-SH .c 100 50 500 250 $rad -fill white -outline black -tags rect

 }
namespace path ::tcl::mathop
proc roundRect2-Orig {c x1 y1 x2 y2 r args} {
   set p [expr {$r * 0.44771525}]; # 1 - (4 * (sqrt(2) - 1) / 3.0)
    $c create polygon \
       [+ $x1 $r] $y1 [+ $x1 $r] $y1 \
       [- $x2 $r] $y1 [- $x2 $r] $y1 \
       [- $x2 $p] $y1 $x2 [+ $y1 $p] \
       $x2 [+ $y1 $r] $x2 [+ $y1 $r] \
       $x2 [- $y2 $r] $x2 [- $y2 $r] \
       $x2 [- $y2 $p] [- $x2 $p] $y2 \
       [- $x2 $r] $y2 [- $x2 $r] $y2 \
       [+ $x1 $r] $y2 [+ $x1 $r] $y2\
       [+ $x1 $p] $y2 $x1 [- $y2 $p] \
       $x1 [- $y2 $r] $x1 [- $y2 $r] \
       $x1 [+ $y1 $r] $x1 [+ $y1 $r] \
       $x1 [+ $y1 $p] [+ $x1 $p] $y1\
       -smooth raw {*}$args
}

proc roundRect2-SH {c x1 y1 x2 y2 r args} {(
    p = $r * 0.44771525;
    Poly = (
	$x1+$r, $y1, $x1+$r, $y1, $x2 - $r , $y1,
	$x2 - $r, $y1, $x2-$p, $y1, $x2, $y1+$p,
	$x2, $y1+$r, $x2, $y1+$r, $x2, $y2-$r,
	$x2, $y2-$r, $x2, $y2-$p, $x2-$p, $y2,
	$x2 - $r, $y2, $x2-$r, $y2, $x1+$r, $y2, 
	$x1+ $r, $y2 , $x1+$p, $y2, $x1, $y2-$p,
	$x1, $y2-$r , $x1, $y2 - $r, $x1, $y1+$r,
	$x1, $y1+$r, $x1, $y1+$p, $x1+$p, $y1);
    
    [$c create polygon $Poly -smooth raw {*}$args]
    )}

proc roundRect2-SH {c x1 y1 x2 y2 r args} {(
    p = $r * 0.44771525;
    [$c create polygon [(
	$x1+$r, $y1, $x1+$r, $y1,
	$x2 - $r , $y1, $x2 - $r, $y1,
	$x2 - $p, $y1, $x2, $y1+$p,
	$x2, $y1+$r, $x2, $y1+$r,
	$x2, $y2-$r, $x2, $y2-$r,
	$x2, $y2-$p, $x2-$p, $y2,
	$x2 - $r, $y2, $x2-$r, $y2,
	$x1+$r, $y2, $x1+ $r, $y2,
	$x1+$p, $y2, $x1, $y2-$p,
	$x1, $y2-$r , $x1, $y2 - $r,
	$x1, $y1+$r, $x1, $y1+$r,
	$x1, $y1+$p, $x1+$p, $y1)]  -smooth raw {*}$args]
    )}

foreach i {1 2} {(
    j=0;
    [foreach v {Orig SH} {
	set proc roundRect${i}-$v
	puts "$proc :"
	puts "length : [set LEN($j) [string length [info body $proc]]]"
	puts "speed : [set TIME($j) [timerate [list $proc .c 100 50 500 250 $rad -fill white -outline black -tags rect]]]"
	incr j
    }];
    [puts "------------------------------"];
    [puts -nonewline "size reduction : [(100 - double($LEN(1))/$LEN(0)*100 )]"; puts " % "; # bug in compile token
    ];
    speed0 = [lindex $TIME(0) 0];
    speed1 = [lindex $TIME(1) 0];
    [puts -nonewline "speed difference : [(100 - double($speed1)/$speed0*100 )]"; puts " % ";  # bug in compile token
    ];
    [puts "--------------------------------"]
)}

set chan [open ./tests/rounded_rect.log w]
puts $chan ------------------------------------
puts $chan roundRect2_Orig
puts $chan ------------------------------------
puts $chan [tcl::unsupported::disassemble proc roundRect2-Orig]
puts $chan ------------------------------------
puts $chan ------------------------------------
puts $chan roundRect2_SH
puts $chan ------------------------------------
puts $chan [tcl::unsupported::disassemble proc roundRect2-SH]
close $chan
console show

set Bx [expr {($Ax + $Cx) / 2.0}]
set By [expr {($Ay + $Cy) / 2.0}]
