set procNames {dotproduct show shape scale_mat dim mkHilbert sub_mat mkVector mkUnitVector dgetrf solvePGauss unitLengthVector mkOnes to_LA solveTriangularBand angle mkDiagonal getrow unitLengthVectorSH scale_vect conforming mkDingdong norm transpose_old rotate matmul solveGaussBand largesteigen choleski leastSquaresSVD axpy_vect orthonormalizeColumns transpose mkRandom add dger determineSVD axpy add_mat mkIdentity getelem sub_vect swaprows1 matmul_org orthonormalizeRows swaprows2 mkWilkinsonW+ scale matmul_mm solveTriangular mkWilkinsonW- mkFrank sub eigenvectorsSVD swapcols det norm_two mkMatrix mkBorder setelem setcol add_vect matmul_mv crossproduct solveGauss normalizeStat mkMoler mkTriangular normMatrix norm_max matmul_vm setrow symmetric norm_one from_LA axpy_mat matmul_vv MorV swaprows getcol NormalizeStat_vect}

proc ::orig::dotproduct { vect1 vect2 } {
    if { [llength $vect1] != [llength $vect2] } {
	return -code error "Vectors must be of equal length"
    }
    set sum 0.0
    foreach c1 $vect1 c2 $vect2 {
        set sum [expr {$sum + $c1*$c2}]
    }
    return $sum
}

proc ::orig::show { obj {format %6.4f} {rowsep \n} {colsep " "} } {
    set result ""
    if { [llength [lindex $obj 0]] == 1 } {
        foreach v $obj {
            append result "[format $format $v]$rowsep"
        }
    } else {
        foreach row $obj {
            foreach v $row {
                append result "[format $format $v]$colsep"
            }
            append result $rowsep
        }
    }
    return $result
}

proc ::orig::shape { obj } {
    set result [llength $obj]
    if { [llength [lindex $obj 0]] <= 1 } {
	return $result
    } else {
	lappend result [llength [lindex $obj 0]]
    }
    return $result
}

proc ::orig::scale_mat { scale mat } {
    set result {}
    foreach row $mat {
        lappend result [scale_vect $scale $row]
    }
    return $result
}

proc ::orig::dim { obj } {
    set shape [shape $obj]
    if { $shape != 1 } {
        return [llength [shape $obj]]
    } else {
        return 0
    }
}
proc ::orig::mkHilbert { size } {
    set result {}
    for { set j 0 } { $j < $size } { incr j } {
        set row {}
        for { set i 0 } { $i < $size } { incr i } {
            lappend row [expr {1.0/($i+$j+1.0)}]
        }
        lappend result $row
    }
    return $result
}

proc ::orig::sub_mat { mat1 mat2 } {
    set result {}
    foreach row1 $mat1 row2 $mat2 {
        lappend result [sub_vect $row1 $row2]
    }
    return $result
}

proc ::orig::mkVector {ndim {value 0.0}} {
    set result {}

    while { $ndim > 0 } {
        lappend result $value
        incr ndim -1
    }
    return $result
}

proc ::orig::mkUnitVector { ndim dir } {

    if { $dir < 0 || $dir >= $ndim } {
        return -code error "Invalid direction for unit vector - $dir"
    } else {
        set result [mkVector $ndim]
        lset result $dir 1.0
    }
    return $result
}

proc ::orig::dgetrf  { matrix } {
    upvar $matrix mat
    set norows [llength $mat]
    set nocols $norows

    # Initialize permutation
    set nm1 [expr {$norows - 1}]
    set ipiv {}
        
    # Perform Gauss transforms
    for {set k 0 } { $k < $nm1 } { incr k } {(
        # Search pivot in column n, from lines k to n
        column =[getcol $mat $k $k $nm1];
        foreach {abspivot murel} [norm_max $column 1] {break}
        # Shift mu, because max returns with respect to the column (k:n,k)
        set mu [expr {$murel + $k}]
        # Swap lines k and mu from columns 1 to n
        swaprows mat $k $mu
        set akk [lindex $mat $k $k]
        # Store permutation
        lappend ipiv $mu
        # Store pivots for lines k+1 to n in columns k+1 to n
        set kp1 [expr {$k+1}]
        set akp1 [getcol $mat $k $kp1 $nm1]
        set mult [expr {1. / double($akk)}]
        set akp1 [scale $mult $akp1]
        setcol mat $k $akp1 $kp1 $nm1
        # Perform transform for lines k+1 to n
        set akp1k [getcol $mat $k $kp1 $nm1]
        set akkp1 [lrange [lindex $mat $k] $kp1 $nm1]
        set scope [list $kp1 $nm1 $kp1 $nm1]
        dger mat -1. $akp1k $akkp1 $scope
    }
    return $ipiv
}
proc ::orig::solvePGauss {} {
}
proc ::orig::unitLengthVector {} {
}
proc ::orig::mkOnes {} {
}
proc ::orig::to_LA {} {
}
proc ::orig::solveTriangularBand {} {
}
proc ::orig::angle {} {
}
proc ::orig::mkDiagonal {} {
}
proc ::orig::getrow {} {
}
proc ::orig::unitLengthVectorSH {} {
}
proc ::orig::scale_vect {} {
}
proc ::orig::conforming {} {
}
proc ::orig::mkDingdong {} {
}
proc ::orig::norm {} {
}
proc ::orig::transpose_old {} {
}
proc ::orig::rotate {} {
}
proc ::orig::matmul {} {
}
proc ::orig::solveGaussBand {} {
}
proc ::orig::largesteigen {} {
}
proc ::orig::choleski {} {
}
proc ::orig::leastSquaresSVD {} {
}
proc ::orig::axpy_vect {} {
}
proc ::orig::orthonormalizeColumns {} {
}
proc ::orig::transpose {} {
}
proc ::orig::mkRandom {} {
}
proc ::orig::add {} {
}
proc ::orig::dger {} {
}
proc ::orig::determineSVD {} {
}
proc ::orig::axpy {} {
}
proc ::orig::add_mat {} {
}
proc ::orig::mkIdentity {} {
}
proc ::orig::getelem {} {
}

proc ::orig::sub_vect { vect1 vect2 } {
    set result {}
    foreach c1 $vect1 c2 $vect2 {
        lappend result [expr {$c1-$c2}]
    }
    return $result
}

proc ::orig::swaprows1 {} {
}
proc ::orig::matmul_org {} {
}
proc ::orig::orthonormalizeRows {} {
}
proc ::orig::swaprows2 {} {
}
proc ::orig::mkWilkinsonW+ {} {
}
proc ::orig::scale {} {
}
proc ::orig::matmul_mm {} {
}
proc ::orig::solveTriangular {} {
}
proc ::orig::mkWilkinsonW- {} {
}
proc ::orig::mkFrank {} {
}
proc ::orig::sub {} {
}
proc ::orig::eigenvectorsSVD {} {
}
proc ::orig::swapcols {} {
}
proc ::orig::det {} {
}
proc ::orig::norm_two {} {
}
proc ::orig::mkMatrix {} {
}
proc ::orig::mkBorder {} {
}
proc ::orig::setelem {} {
}
proc ::orig::setcol {} {
}
proc ::orig::add_vect {} {
}
proc ::orig::matmul_mv {} {
}
proc ::orig::crossproduct {} {
}
proc ::orig::solveGauss {} {
}
proc ::orig::normalizeStat {} {
}
proc ::orig::mkMoler {} {
}
proc ::orig::mkTriangular {} {
}
proc ::orig::normMatrix {} {
}
proc ::orig::norm_max {} {
}
proc ::orig::matmul_vm {} {
}
proc ::orig::setrow {} {
}
proc ::orig::symmetric {} {
}
proc ::orig::norm_one {} {
}
proc ::orig::from_LA {} {
}
proc ::orig::axpy_mat {} {
}
proc ::orig::matmul_vv {} {
}
proc ::orig::MorV {} {
}
proc ::orig::swaprows {} {
}
proc ::orig::getcol {} {
}
proc ::orig::NormalizeStat_vect {} {
}

######################################
proc ::exprsh::dotproduct { vect1 vect2 } {(
    [llength $vect1] != [llength $vect2] ? \
	[return -code error "Vectors must be of equal length"]:;

    sum = 0.0;
    [foreach c1 $vect1 c2 $vect2 {( sum = $sum + $c1*$c2 )}];
    $sum
)}


proc ::exprsh::show { obj {format %6.4f} {rowsep \n} {colsep " "} } {
    set result ""
    if { [llength [lindex $obj 0]] == 1 } {
        foreach v $obj {
            append result "[format $format $v]$rowsep"
        }
    } else {
        foreach row $obj {
            foreach v $row {
                append result "[format $format $v]$colsep"
            }
            append result $rowsep
        }
    }
    return $result
}

proc ::exprsh::shape { obj } {
    set result [llength $obj]
    if { [llength [lindex $obj 0]] <= 1 } {
	return $result
    } else {
	lappend result [llength [lindex $obj 0]]
    }
    return $result
}

proc ::exprsh::scale_mat { scale mat } {
    set result {}
    foreach row $mat {
        lappend result [scale_vect $scale $row]
    }
    return $result
}

proc ::exprsh::dim { obj } {
    set shape [shape $obj]
    if { $shape != 1 } {(
	[llength [shape $obj]]
    )} else {(0)}
}

proc ::exprsh::mkHilbert { size } {
    set result {}
    for {( j=0)} { $j < $size } { incr j } {
        set row {}
        for {(i=0)} { $i < $size } { incr i } {
            lappend row [(   1.0/($i+$j+1.0)  )]
        }
        lappend result $row
    }
    return $result
}
proc ::exprsh::sub_mat { mat1 mat2 } {
    lmap row1 $mat1 row2 $mat2 {(  [sub_vect $row1 $row2]   )}
}
proc ::exprsh::sub_mat2 { mat1 mat2 } {
    lmap row1 $mat1 row2 $mat2 {
	lmap c1 $row1 c2 $row2 {(  $c1 - $c2  )}
    }
}
proc ::exprsh::mkVector {ndim {value 0.0}} {
    lrepeat $ndim $value 
}
proc ::exprsh::mkUnitVector { ndim dir } {
    if { $dir < 0 || $dir >= $ndim } {
        return -code error "Invalid direction for unit vector - $dir"
    } else {(
        result = [mkVector $ndim];
        [lset result $dir 1.0];
    )}
    return $result
}

proc ::exprsh::dgetrf { matrix } {
    upvar $matrix mat
    [(	norows=[llength $mat];
	nocols = $norows;
	# Initialize permutation
	nm1= $norows - 1;
	ipiv = {} )]
    
    # Perform Gauss transforms
    for {(k=0)} { $k < $nm1 } { incr k } {(
        # Search pivot in column n, from lines k to n
        column =[getcol $mat $k $k $nm1];
        [foreach {abspivot murel} [norm_max $column 1] {break}];
        # Shift mu, because max returns with respect to the column (k:n,k)
        mu = $murel + $k;
        # Swap lines k and mu from columns 1 to n
        [swaprows mat $k $mu];
        akk = [lindex $mat $k $k];
        # Store permutation
        [lappend ipiv $mu];
        # Store pivots for lines k+1 to n in columns k+1 to n
        kp1= $k+1;
        akp1= [getcol $mat $k $kp1 $nm1];
        mult=1. / double($akk);
        akp1= [scale $mult $akp1];
        [setcol mat $k $akp1 $kp1 $nm1];
        # Perform transform for lines k+1 to n
        akp1k = [getcol $mat $k $kp1 $nm1];
        akkp1 = [lrange [lindex $mat $k] $kp1 $nm1];
        scope = [list $kp1 $nm1 $kp1 $nm1];
        [dger mat -1. $akp1k $akkp1 $scope]
    )}
    return $ipiv
}
    
proc ::exprsh::solvePGauss {} {
}
proc ::exprsh::unitLengthVector {} {
}
proc ::exprsh::mkOnes {} {
}
proc ::exprsh::to_LA {} {
}
proc ::exprsh::solveTriangularBand {} {
}
proc ::exprsh::angle {} {
}
proc ::exprsh::mkDiagonal {} {
}
proc ::exprsh::getrow {} {
}
proc ::exprsh::unitLengthVectorSH {} {
}
proc ::exprsh::scale_vect {} {
}
proc ::exprsh::conforming {} {
}
proc ::exprsh::mkDingdong {} {
}
proc ::exprsh::norm {} {
}
proc ::exprsh::transpose_old {} {
}
proc ::exprsh::rotate {} {
}
proc ::exprsh::matmul {} {
}
proc ::exprsh::solveGaussBand {} {
}
proc ::exprsh::largesteigen {} {
}
proc ::exprsh::choleski {} {
}
proc ::exprsh::leastSquaresSVD {} {
}
proc ::exprsh::axpy_vect {} {
}
proc ::exprsh::orthonormalizeColumns {} {
}
proc ::exprsh::transpose {} {
}
proc ::exprsh::mkRandom {} {
}
proc ::exprsh::add {} {
}
proc ::exprsh::dger {} {
}
proc ::exprsh::determineSVD {} {
}
proc ::exprsh::axpy {} {
}
proc ::exprsh::add_mat {} {
}
proc ::exprsh::mkIdentity {} {
}
proc ::exprsh::getelem {} {
}

proc ::exprsh::sub_vect { vect1 vect2 } {
    lmap c1 $vect1 c2 $vect2 {( $c1 - $c2 )}
}

proc ::exprsh::swaprows1 {} {
}
proc ::exprsh::matmul_org {} {
}
proc ::exprsh::orthonormalizeRows {} {
}
proc ::exprsh::swaprows2 {} {
}
proc ::exprsh::mkWilkinsonW+ {} {
}
proc ::exprsh::scale {} {
}
proc ::exprsh::matmul_mm {} {
}
proc ::exprsh::solveTriangular {} {
}
proc ::exprsh::mkWilkinsonW- {} {
}
proc ::exprsh::mkFrank {} {
}
proc ::exprsh::sub {} {
}
proc ::exprsh::eigenvectorsSVD {} {
}
proc ::exprsh::swapcols {} {
}
proc ::exprsh::det {} {
}
proc ::exprsh::norm_two {} {
}
proc ::exprsh::mkMatrix {} {
}
proc ::exprsh::mkBorder {} {
}
proc ::exprsh::setelem {} {
}
proc ::exprsh::setcol {} {
}
proc ::exprsh::add_vect {} {
}
proc ::exprsh::matmul_mv {} {
}
proc ::exprsh::crossproduct {} {
}
proc ::exprsh::solveGauss {} {
}
proc ::exprsh::normalizeStat {} {
}
proc ::exprsh::mkMoler {} {
}
proc ::exprsh::mkTriangular {} {
}
proc ::exprsh::normMatrix {} {
}
proc ::exprsh::norm_max {} {
}
proc ::exprsh::matmul_vm {} {
}
proc ::exprsh::setrow {} {
}
proc ::exprsh::symmetric {} {
}
proc ::exprsh::norm_one {} {
}
proc ::exprsh::from_LA {} {
}
proc ::exprsh::axpy_mat {} {
}
proc ::exprsh::matmul_vv {} {
}
proc ::exprsh::MorV {} {
}
proc ::exprsh::swaprows {} {
}
proc ::exprsh::getcol {} {
}
proc ::exprsh::NormalizeStat_vect {} {
}
