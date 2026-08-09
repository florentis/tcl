# README:  Tcl

This is the **Tcl 9.0.4** source distribution with **expr shorthand**

# what is it ?
- In expr parser,
  - includes TIP282 proposal : 
    - separating instructions with `;`
    - assigning vars with `=`
  - add a new feature :
    - a comma separated list of elements between parenthesese is taken as a list : `expr {((1,2,3),(4,5,6),(7,8,9))}` is equivalent to `{{1 2 3} {4 5 6} {7 8 9}}`
- In Tcl parser
  - A new rule has been added to the Tcl parser : the math expression substitution. A word enclosed with `[(` ... `)]` is taken as an expression. there is two situations here
    - with a trailing semi-colon, nothing is returned (muted expression)
    - else the result is returned (inline expression)
- in Tcl compiler
  - if a script begins with a `(` and finish with a `)`, then it will be compiled as an expression.

# examples

    # Tcl parser
    set x [( 1 + 1 )]; # inline
    [( y = 2 * 2 ;)] ;# muted
    # Tcl compiler 
    if {($x == 2)} ("ok x")
    switch $y 2 ("ok y")
    lmap z [lseq 10] (\$z*2)
    
# in this repository :
you will find the modified Tcl source.

you will find a binary distribution, with Tk, compiled with Msys under Windows 10, in the folder `Install_SH`
