# From https://wiki.tcl-lang.org/page/Matrix+determinant

proc determinant_Orig matrix {
    if {[llength $matrix] != [llength [lindex $matrix 0]]} {
       error "non-square matrix"
    }
    switch [llength $matrix] {
	2 {
	    set Map {{a b} {c d}}
	    lmap map $Map row $matrix {
		lmap var $map val $row {
		    set $var $val
		}
	    }
	    expr {$a*$d - $b*$c}
	} default {
	    set i 0
	    set mat2 [lrange $matrix 1 end]
	    set res 0
	    foreach element [lindex $matrix 0] {
		if $element {
		    set sign [expr {$i%2? -1: 1}]
		    set res [expr {$res + $sign*$element* [determinant_Orig [cancelcol $i $mat2]]}]
		}
		incr i
	    }
	    set res 
	}
    }
 }
 proc cancelcol {n matrix} {
    set res {}
    foreach row $matrix {
        lappend res [lreplace $row $n $n]
    }
    set res
 }


proc determinant_SH1 matrix {
    if {[llength $matrix] != [llength [lindex $matrix 0]]} {
	error "non-square matrix"
    }
    switch [llength $matrix] {
	2 {
	    set Map {{a b} {c d}}
	    lmap map $Map row $matrix {
		lmap var $map val $row {($var=$val)}
	    }
	    return [($a*$d - $b*$c)]
	} default {
	    expr { i = res = 0; mat2=[lrange $matrix 1 end]}
	    foreach element [lindex $matrix 0] {
		if $element {(
		    sign = $i%2? -1: 1;
		    res =$res + $sign*$element* [determinant_SH1 [cancelcol $i $mat2]]
		    )}
		incr i
	    }
	    set res 	    
	}
    }
}

set chan [open ./tests/determinant.log w]
for (i="speed(Orig)"="speed(SH1)"=0) {$i<3} {incr i} {(
    "speed(Orig)" = $speed(Orig) + [lindex [timerate [list determinant_Orig {{5 -3 2} {1 0 6} {3 1 -2}}]] 0] ;
    "speed(SH1)" = $speed(SH1) + [lindex [timerate [list determinant_SH1 {{5 -3 2} {1 0 6} {3 1 -2}}]] 0]
    )}

foreach suffix {Orig SH1} {("speed($suffix)" = [set speed($suffix)]/3)}

puts $chan Results
puts $chan "Original Proc : speed = $speed(Orig)"
puts $chan "Original Proc : result : [determinant_Orig {{5 -3 2} {1 0 6} {3 1 -2}}]"
puts $chan "SH1 Proc : speed = $speed(SH1)"
puts $chan "SH1 Proc : result = [determinant_SH1 {{5 -3 2} {1 0 6} {3 1 -2}}]"
puts $chan -------------------------------------------------------------------------
puts $chan Bytecodes
puts $chan -------------------------------------------------------------------------
puts $chan 1.Orig,\ length=[string length [info body determinant_Orig]]
puts $chan [tcl::unsupported::disassemble proc determinant_Orig]
puts $chan -------------------------------------------------------------------------
puts $chan 1.SH1,\ length=[string length [info body determinant_SH1]]
puts $chan [tcl::unsupported::disassemble proc determinant_SH1]

close $chan
