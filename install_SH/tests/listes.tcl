proc vect {x} {
    list [expr {$x+1}] [expr {$x*2}] [expr {$x/3}]
}

proc vectSH {x} {
    list [($x+1)]  [($x*2)]  [($x/3)]
}

proc vectSH-1 {x} {
    return [($x+1, $x*2, $x/3)]
}

proc vectSH-2 {x} {(
    $x+1, $x*2, $x/3
)}

proc seq {x} {
    expr {$x+1}; expr {$x*2}; expr {$x/3}
}

proc seqSH {x} {
 
}

proc seqSH-1 {x} {
    return [( $x+1; $x*2; $x/3 )]
}

proc seqSH-2 {x} {(
    $x+1; $x*2; $x/3
)}


proc mat {x y z} {
    list \
	[list [expr {$x+1}] [expr {$x*2}] [expr {$x/3}]]\
	[list [expr {$y+1}] [expr {$y*2}] [expr {$y/3}]]\
	[list [expr {$z+1}] [expr {$z*2}] [expr {$z/3}]]
    
}

proc matSH {x y z} {
}

proc matSH-1 {x y z} {
    return [(
	($x+1, $x*2, $x/3),
	($y+1, $y*2, $y/3),
	($z+1, $z*2, $z/3)
    )]
}

proc matSH-2 {x y z} {(
    ( $x+1, $x*2, $x/3 ),
    ($y+1, $y*2, $y/3),
    ($z+1, $z*2, $z/3)
)}

foreach {name args} {vect 5 seq 5  mat {1 2 3}} {
    puts "-----------------------------------------------------------------------------"
    puts Orig\ $name\ :\ [$name {*}$args]
    puts [info body $name]
    lassign [lrange [timerate {$name {*}$args}] 0 1] O unit
    puts "speed : $O $unit = [($O/$O*100)] %\n"
    puts [tcl::unsupported::disassemble proc $name]
    puts "---"	  
    puts SH\ $name\ :\ [${name}SH {*}$args]
    puts [info body ${name}SH]    
    lassign [lrange [timerate {${name}SH {*}$args}] 0 1] sh unit
    puts "speed : $sh $unit = [(100 - $sh/$O*100)] %\n"
    puts [tcl::unsupported::disassemble proc ${name}SH]\n
    puts "---"	  
    puts SH-1\ $name\ :\ [${name}SH-1 {*}$args]
    puts [info body ${name}SH-1]    
    lassign [lrange [timerate {${name}SH-1 {*}$args}] 0 1] sh unit
    puts "speed : $sh $unit = [(100-$sh/$O*100)] %\n"
    puts [tcl::unsupported::disassemble proc ${name}SH-1]\n
    puts "---"
    puts SH-2\ $name\ :\ [${name}SH-2 {*}$args]
    puts [info body ${name}SH-2]    
    lassign [lrange [timerate {${name}SH-2 {*}$args}] 0 1] sh unit
    puts "speed : $sh $unit = [(100-$sh/$O*100)] %\n"
    puts [tcl::unsupported::disassemble proc ${name}SH-2]\n
    puts "------------------------------------------------------------------------------"
}
