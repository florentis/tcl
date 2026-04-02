# https://wiki.tcl-lang.org/page/Fibonacci+numbers

set D [dict create \
	   fib-recurs {recursive version with inline shorthand and script shorthand}\
	   fib-Orig {Original version from tcl_lib}\
	   fib-SH1 {Script shorthand on then clause in if}\
	   fib-SH2 {TIP282 before loop}\
	   fib-SH3 {Script shorthand on for init}\
	   fib-SH4-a {Script shorthand on for step in braces}\
	   fib-SH4-b {Script shorthand on for step (no braces, var backslashed)}\
	   fib-SH5-a {Script shorthand on for loop}\
	   fib-SH5-b {Script shorthand on for loop (with nested equal)}\
	   fib-SH6 {TIP 282 in for loop}\
	   fib-SH1+2+3+5b {script shorthand on then clause, for init, on for loop, tip282 before for}\
	   fib-SH1+2+3 {Shorthand on then clause, on for init, TIP282 before loop}]
       
proc fib-recurs n {(
    $n <3 ? 1 : [fib [($n-1)]] + [fib [($n-2)]]
    )}

proc fib-Orig {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {incr i} {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}

#Script shorthand on then clause in if
proc fib-SH1 {n} {
    if { $n == 0 } (0) else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {incr i} {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}
# TIP282 before loop
proc fib-SH2 {n} {
    if { $n == 0 } {
        return 0
    } else {
        expr {f0=0 ; f1=1}
        for {set i 1} {$i < $n} {incr i} {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}
# Script shorthand on for init
proc fib-SH3 {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for (i=1) {$i < $n} {incr i} {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}
# script shorthand on for step (in braces)
proc fib-SH4-a {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {(i=$i+1)} {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}

# script shorthand on for step (no braces, var backslashed)
proc fib-SH4-b {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} (i=\$i+1) {
            set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}

# script shorthand on for loop (normal)
proc fib-SH5-a {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {incr i} {(
            tmp=$f1;
            f1=$f1+$f0;
            f0=$tmp
        )}
        return $f1
    }
}
# script shorthand on for loop (with nested equal)
proc fib-SH5-b {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {incr i} {(
            f1=(tmp=$f1)+$f0;
            f0=$tmp
        )}
        return $f1
    }
}

# TIP 282 in for loop
proc fib-SH6 {n} {
    if { $n == 0 } {
        return 0
    } else {
        set f0 0
        set f1 1
        for {set i 1} {$i < $n} {incr i} {
	    expr {
		  tmp=$f1;
		  f1=$f1+$f0;
		  f0=$tmp
	      }
        }
        return $f1
    }
}
# fib-SH1+2+3 script shorthand on then clause, on for init, tip282 before for.
proc fib-SH1+2+3 {n} {
    if { $n == 0 } (0) else {
        expr {f0=0 ; f1=1}
        for (i=1) {$i < $n} {incr i} {
	    set tmp $f1
            incr f1 $f0
            set f0 $tmp
        }
        return $f1
    }
}

# fib-SH1+2+3+5b script shorthand in then, in for init, in for loop (nested equal)), tip282 before for.
proc fib-SH1+2+3+5b {n} {
    if { $n == 0 } (0) else {
        expr {f0=0 ; f1=1}
        for (i=1) {$i < $n} {incr i} {(
	    f1 = (tmp=$f1) + $f0;
	    f0 = $tmp
        )}
        return $f1
    }
}

# Others (unmeasured):
proc fib2 n {
    if { $n==0 } {
	return 0
    } else {
	for (i=1,\ tmp=f0=0,\ f1=1) {$i<$n}\
	    (i=\$i+1,\ f0=\$tmp,\ tmp=\$f1) {( f1 = $f1 + $f0 )}
	return $f1
    }
}

proc fib3 n {
    if  \$n==0 (0) else {
	for {( i=1, f0=0, tmp=f1=1 )} \
	    {$i<$n}\
	    {( i=$i+1, f0=$tmp, tmp=$f1 )} \
	    {( f1 = $f1 + $f0 )}
	
	return $f1
    }
}

proc fib4 n {
    if \$n==0 (0) else {
	for (i=1,\ f0=0,\ tmp=f1=1)  \$i<\$n \
	    (i=\$i+1,\ f0=\$tmp,\ tmp=\$f1) {( f1 = $f1 + $f0 )}
	return $f1
    }
}

proc fib n {( $n <3 ? 1 : [fib [($n-1)]] + [fib [($n-2)]] )}


puts "let's compare the speed of proc variants"
set chan [open ./tests/fibonacci.log w]

for (j=1) {$j <= 3} {incr j} {
    puts "try $j" 
    set Result [dict create]

    foreach proc [dict keys $D] {
	puts "measurement of $proc" 
	set data [timerate [list $proc 12]]
	set speed [lindex $data 0]
	dict set Result $speed [list $proc $data]
    }
    puts $chan "-----------------------------
    try $j
    --------------------------------
    Results : "
    set L {}
    set i 0
    foreach k [lsort -real [dict keys $Result]] {
	puts $chan "$i : $k [lindex [dict get $Result $k] 0] [dict get $D [lindex [dict get $Result $k] 0]]"
	incr i
    }

    foreach s [lsort -real [dict keys $Result]] {
	lassign [dict get $Result $s] proc data
	puts $chan ---------------------------------
	puts $chan "$proc : [dict get $D $proc]"
	puts $chan "Length of the body : [string length [info body $proc]] chars"
	puts $chan -----
	puts $chan "$data"
	puts $chan -----
	puts $chan [tcl::unsupported::disassemble proc $proc]
	puts $chan ----------------------------------
    }
}
puts "Finished ! Read file fibonacci.log to get the details"
