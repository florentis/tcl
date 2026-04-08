proc typedef {name vars {methods {}}} {
    catch {oo::class create $name}
    set decVars {}
    set setVars {}
    set getVars {}
    set listVars {}
    foreach v $vars {
	oo::define $name variable _$v
	append decVars "my variable _$v\n"
	append setVars "set _$v \[set $v\] \n"
	append getVars "set $v \[set _$v\] \n"
	lappend listVars "\$$v"
    }
    foreach {mNAME mARGS mBODY} $methods {
	oo::define $name [list method $mNAME $mARGS [subst {
	    $decVars
	    $getVars
	    $mBODY}]]
    }
    oo::define $name [list constructor $vars [subst {
	$decVars
	$setVars
	uplevel \[list set \[self\] \[list  [join $listVars " "]\]\]
    }]]
}

typedef Point {x y} {
    coords {} {
	return [list $x $y]
    }
    translation {dx dy} {
	expr {("_x"=$x+$dx, "_y"=$y+$dy)}
    }
}

typedef biPoint {P Q} {
    coords {} {
	return [list [$P coords] [$Q coords]]
    }
    
}

typedef triPoint {P Q R} {
    coords {} {
	return [list [$P coords] [$Q coords] [$R coords]]
    }
}

typedef quadriPoint {P Q R S} {
    coords {} {
	return [list [$P coords] [$Q coords] [$R coords] [$S coords]]
    }
    translation {dx dy} {
	set R [list]
	foreach point [list $P $Q $R $S] {
	    lappend R [$point translation $dx $dy]
	}
	return $R
    }
}

typedef PolyLine {args} {
    coords {} {
	foreach e $args {
	    lappend L [$e coords]
	}
	return $L
    }
    translation {dx dy} {
	set R [list]
	foreach point $args {
	    lappend R [$point translation $dx $dy]
	}
	return $R
    }
}



    
