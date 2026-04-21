# TIP :           xxx
     Title:	  Mathematical expression substitution 
     Version:  $Revision: 0.2 $
     Author:  Florent MERLET <florent.merlet.auditeur@lecnam.net>
     State:  Draft
     Type:  Project
     Tcl-Version: 9.1
     Vote:   Pending
     Created: 2026-03-01
     Post-History:
------

## Abstract
  This TIP proposes to extend the Tcl syntax, in including a new rule of substitution :   
  ***mathematical expression substitution***. 

## Rationale
Improving the readability of arithmetic calculations is a long term demand in Tcl. One of this first demand was [TIP 282](https://core.tcl-lang.org/tips/doc/trunk/tip/282.md). Periodically, expansive discussions about it occur on the wiki. There were many suggestions to make things more practical : [TIP 676](https://core.tcl-lang.org/tips/doc/trunk/tip/676.md), [TIP 674](https://core.tcl-lang.org/tips/doc/trunk/tip/674.md), [TIP 672](https://core.tcl-lang.org/tips/doc/trunk/tip/672.md).

## Specification
At the Tcl parser level, this ***mathematical expression substitution*** will be marked by this syntax :

```tcl
        set A [( *expression* )]
```
This syntax will be named below as **inline expression shorthand**.

This corresponds to this new rule of substitution :
> * **Mathematical expression substitution** : If the first caracter of a word is an open-bracket and is immediately followed by an open-parenthese, then Tcl performs a *Mathematical expression substitution*. The expression has to follows the rules of the *expr* mini-language. It must be closed by a closed-parenthese immediately followed by a closed-bracket. 

## Options

- **Native list handling** :

```tcl
         set m [((1, 0, 0), (0, 1, 0), (0, 0, 1))]
```

will be made equivalent to :

```tcl
          set m [list [list 1 0 0] [list 0 1 0] [list 0 0 1]]]
```

- **[TIP 282](https://core.tcl-lang.org/tips/doc/trunk/tip/282.md.html) proposals** :
  
And a little improvement to allow us to use a bareword for variable name on the left side of the assignement operator. 

Then, we can write :

```tcl
         set L [( x = 1; ($x, $x*2, $x*3) )]
		 # set x to 1 and set L to {1 2 3}
```
Some other things has been added : 

- - two semi-colons one after another is not an error.
  - a semi-colon immediately after a colon is not an error
- - a trailing semi-colon (just before the end) will "mute" the expression (it will then return an "empty string")

- **Expression script** :

  Every Tcl_Obj whose bytes representation is to be taken as a script by a command, when this one begins with a `(` and finishes by a `)`, will be compiled as an expression.

  ```tcl
  eval {(1+1)}; # return 2
  ```
  It should work with `if`, `while`, `for`, `foreach`, `lmap`, `eval`, `apply`, `proc`,...etc
  
  
## Examples :
- Setting a variable :
```tcl
set bright [($red*0.3 + $green*0.59 + $blue*0.11)]
```

- A cross product proc **with native list handling**
```tcl
    proc crossProduct {U V} {
       lassign $U x y z
       lassign $V u v w
       return [( $y*$w - $v*$z, $w*$x - $u*$z, $x*$v - $u*$y)]		
    }
```
- Eratosthenes sieve :
  - With **inline expression shorthand** :
  ```tcl
     proc sieve {n} {
       set L [lseq $n]
       for {set i 2} {$i < $n} {incr i} {
          set j $i
          while {$i*$j < $n} {
             lset L [( $i*$j )] {}
             incr j
          }
       }
       return [lsearch -all -not -exact $L {}]
    }
   ```

   - with **TIP 282** integration (illustrating with `for` and `while`):
   ```tcl
     proc sieve {n} {
        set L [lseq $n]
        for {set i 2} {(j = $i) < $n} {incr i} {
            while {(k = $i*$j) < $n} {
	           lset L $k {}
	           incr j
            }
       }
       return [lsearch -all -not -exact $L {}]
    }
   ```

- Matrix calculus and affine transform example **with native list handling**, **script expression**, **TIP 282**, **inline expression shorthand**

```tcl

proc MatrixTranspose {M} {
    if {[llength [lindex $M 0]] == 1} {
        # M is a vector
        return $M
    }
    set i 1
    foreach row $M {
        lassign $row m${i}1 m${i}2 m${i}3
        incr i
    }

    return  [( $i == 2 ?
               (# it was a false matrix case : there was just one row after all.
                $m11, $m12, $m13 
               ) : (
                ($m11, $m21, $m31),
                ($m12, $m22, $m32),
                ($m13, $m23, $m33)
                )  )]
}

proc MatrixProduct {M1 M2} {
    set i 0
    foreach row $M1 {
        lassign $row m${i}0 m${i}1 m${i}2
        incr i
    }
        
    set R []
    foreach v [MatrixTranspose $M2] {
         lassign $v x y z
         lappend R [if {[llength $v] == 1} then {(
                      vector = 1; # M2 is a vector !
					  y = [lindex $M2 1];
                      z = [lindex $M2 2];
                      ($m00*$x + $m01*$y + $m02*$z,
                       $m10*$x + $m11*$y + $m12*$z,
                       $m20*$x + $m21*$y + $m22*$z)
                    )} else {( 
                      vector = 0; # M2 was a matrix.
                      ($m00*$x + $m01*$y + $m02*$z,
                       $m10*$x + $m11*$y + $m12*$z,
                       $m20*$x + $m21*$y + $m22*$z)
					)}]
         if {$vector == 1} {
               return $R
         }
    }
    return $R
}

# Affine transforms examples :

proc translation {dx dy} {(
  (1, 0, $dx),
  (0, 1, $dy),
  (0, 0,  1 )  
)}

proc rotation {angle} {(
   angle = $angle/180.0*acos(-1);
   ((cos($angle), -sin($angle), 0),
    (sin($angle),  cos($angle), 0),
    (     0     ,      0      , 1))
)}

set Point  [( 100*cos(30.0/180*acos(-1)), 50, 1 )]

set RotatedPoint [MatrixProduct [rotation -30] $Point]
set TranslatedPoint [MatrixProduct [translation -100 0] $RotatedPoint]

puts RotatedPoint\ :\ $RotatedPoint ; # RotatedPoint : {100.00000000000001 7.105427357601002e-15 1.0}
puts TranslatedPoint\ :\ $TranslatedPoint ; # TranslatedPoint : {1.4210854715202004e-14 7.105427357601002e-15 1.0}

```
- Draw a rectangle on a canvas with **native list handling** 

```tcl
    .c create rect [($x, $y, $x+100, $y+100)]
```

- Tensorial product, with **expression script** (2nd lmap)

```tcl
     proc TensorialProduct {V U} {
        lmap u $U {
           lmap v $V {( $u * $v )}
        }
	 }
     puts [TensorialProduct {1 2 3} {3 2 1}]
     # {3 2 1} {6 4 2} {9 6 3}
```

- Matrix transpose (2) : with **inline expression substitution**, **native list handling**, **TIP 282**, **expression script**

```tcl
proc transpose {M} {
    set MAP {{a b c} {d e f} {g h i}}
    lmap row1 $MAP row2 $M {
    	lmap var $row1 val $row2 {($var = double($val))}
    }
    return [( 	($a, $d, $g),
	        	($b, $e, $h),
	      		($c, $f, $i) )]
}
```

- Determinant : with **TIP282 assignement**, **expression script**, **inline expression substitution** :

```tcl
proc determinant {M} {
    set MAP {{a b c} {d e f} {g h i}}
    lmap row1 $MAP row2 $M {
        lmap var $row1 val $row2 {($var = $val)}
    }
    return [($a*$e*$i + $b*$f*$g + $c*$d*$h - $c*$e*$g - $b*$d*$i - $a*$f*$h)]
}
```
## Implementation
The code is made on top of Tcl9.04. Last version can be found on [github](https://github.com/florentis/tcl90-exprSH) There is an Install_SH Folder with tclsh.exe / wish.exe compiled under mingw64 above Win10 with gcc.

### Code for inline expression substition
It should allow this syntax :

	 set A [(1+1)]; # $A is 2

#### Principles of the changes
 * In tclParse.c :
     * in *parseToken* : Add a test for the existence of an open parenthese after the open bracket, using the Parse_Expr parser, to get to the length of the expression. Mark this area as a TCL_TOKEN_SUB_EXPR.
     * in *substToken* : Add a case to check for a TCL_TOKEN_SUB_EXPR and call Tcl_ExprObj to substitute the token value.
 * In tclCompExpr.c :
   * in *ParseExpr* : Add a new variable substExpressionContext, some code to be able to nest the shorthand into the shorthand, and to control the end of the expression
   * in *Tcl_ParseEpr* : Manage the return of the length of the expression to *parseToken*
 * In TclCompile.c
     * in *TclCompileTokens* : Add a case to handle TCL_TOKEN_SUB_EXPR
     
### Code for native list handling
It should allow this syntax :

     set C((1+1)) [(  (1+1, 2+2, 3+3),  
                      (2*4, 2*5, 2*6)    )]  
     # $C(2) is {{2 4 6} {8 10 12}}

#### Principles of the changes

  * In TclCompExpr.c :
     * In *ParseExpr* : For each OPEN_PAREN unary operator not preceded by a FUNCTION operator, create a NULL_FUNC unary operator and add the list function in the litlist. If an error "comma out function argument" occurs, change this NULL_FUNC operator by a FUNC operator.
     * In Tcl_CompileExprTree :
        * add NULL_FUNC case, which does nothing except skip the current element in the list of func
  * In tclBasic.c : add Tcl_ListObjCmd in the table for mathfunc.

### Code for TIP282 integration 
It should allow this syntax :

      set K [( x=10; y=50; ($x*$y, $y/$x) )]
      # will set K to {500 5}

#### Principles of the changes

* In tclParse.c :
  * The code from the patch of TIP282
  * In *ParseExpr* : The code to detect if a bareword is followed by a '=' sign and to add it to the literal list, so that it can be taken as a variable name during bytecode execution.
 
### Script shorthand

 In a context where a script has to be compiled (proc, lambda, ...etc), the shorthand should allow this syntax :

         proc P0 args {( *expression* )} 
		 proc P1 args "( *expression* )" ; # 
		 proc P2 args (**expression**) ; # (if no space)

#### Principles of the changes
* In tclParse.c :
	* In *Tcl_ParseCommand* : At the begining, detect if the string begins with a `(` and finishes with a `)` [or `)\n`] then fills the parse structure with a TCL_TOKEN_WORD, containing a TCL_TOKEN_SUB_EXPR
 * In tclCompile.c :
 	* In *TclSetBytcodesFromAny* : Check if the string begins with a `(` and finishes with a `)`, then compile it as an *expression*. Avoid optimisation.
   	* In *TclCompileScript* :  Check if Tcl_ParseCommand returns a TCL_TOKEN_WORD containing a TCL_TOKEN_SUB_EXPR token. If so, compile its component as an expression


## Incompatibilities :
 * inline expression substition : Any proc which is named '(' will be shadowed by the shorthand. However, it will still be possible to use it, either by protecting it by a backslash '\\(', or simply, but less readable, by inserting a space between the open-bracket and the open-parenthese.
 
        set A [\( protect-it with backslash to eval the '(' proc ]
      
 * Index shorthand : As Tcl9 now forbid parentheses into array index, there should be none.

## Comment
to be added
## Copyright

This document has been placed in the public domain.









