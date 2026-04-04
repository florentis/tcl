set PWD [file dirname [info script]]
source [file join $PWD affine.tcl]


catch {
    canvas .c
    pack .c -expand 1 -fill both
}

oo::class create Rectangle {
    variable Ax Ay Cx Cy index canvas
    constructor {ax ay cx cy {can .c}} {
	lassign [($ax, $ay, $cx, $cy, $can)] Ax Ay Cx Cy canvas
	set index [$can create rectangle $Ax $Ay $Cx $Cy]
	
    }
    method translate {dx dy} {
	set Coords [list]
	foreach {x y} [($Ax, $Ay, $Cx, $Cy)]  {
	    lappend Coords [::apply_affine [::translation $dx $dy]  [($x,$y)] ]
	}
	lassign [lindex $Coords 0] Ax Ay
	lassign [lindex $Coords 1] Cx Cy	    

	$canvas coords $index $Ax $Ay $Cx $Cy
    }
}

	
