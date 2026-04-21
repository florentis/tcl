# Wish console :
# Scalar vars
#1. Assignement to constants
puts "test num\ [set i 0]"; # 0
puts {
   * Numeric assignement :
      [(x=0;)]
      ---------------}
[(x=0;)]

if {$x == 0} {puts "--> ok"} else {puts "--> NOK !"}

puts "\ntest num\ [incr i]"; # 1
puts {
   * String assignement :
      [(string="hello";)]
      -------------------------}
[(string="hello";)];

if {$string  eq "hello"} {puts "--> ok"} else {puts "--> NOK !"}

#2. assignement to non constants
puts "\ntest num\ [incr i]"; # 2
puts {
   * Assignement to variable :
      [(y=$x;)]
      --------------}
[(y=$x;)]

if {$y == $x} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #3
puts {
   * Assignement to func :
      [(z=acos(-$y)/2;)]
      ----------------------------}
[(z=acos(-$y)/2;)]

if {$z == acos(-$y)/2} {puts "--> ok"} else {puts "--> NOK !"}

#3. More complex assignement
puts \ntest\ num\ [incr i]; # 4
puts {
   * Right associative rule :
     [(j = k = l = 0;)]
     -------------------------}
[(j = k = l = 0;)]

if {$l == 0 && $j == 0 && $k == 0} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #5
puts {
    * Nested assignement :
       [(w = (u = 3) * 2;)]
       ------------------------------}
[(w = (u = 3) * 2;)]

if {$w == 6 && $u == 3} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #6
puts {
    * Save old var value and reset :
    [( new = 1; new = (old=$new; 0) ;)]
    -------------------------------------------------------}
[( new = 1; new = (old=$new; 0) ;)];

if {$new == 0 && $old == 1} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #7
puts {
    * Swap two vars :
    [(f0=2; f1 = 3;)]
    [( f0 = (tmp = $f0 ; $f1); f1 = $tmp ;)]
    -------------------------------------------------------------------------------}
[(  f0=2;
    f1 = 3;
    f0 = (tmp = $f0 ; $f1);
    f1 = $tmp ;)]

if {$f0 == 3 && $f1 == 2} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; # 9
puts {
    * Ref to a variable :
      [((ref = "var") = "referenced";)]
      -----------------------------------------------}
[((ref = "var") = "referenced";)] 

if {[set $ref] eq $var && $var eq "referenced"} {
    puts "--> ok"
} else {puts "--> NOK !"}

# Array vars
puts \ntest\ num\ [incr i]; #9
puts {
   * Array into inline shorthand :
      [( "A(3)" = 3; )]
      ------------------------------}
[( "A(3)" = 3; )]

if {$A(3) == 3} {puts "--> ok"} else {puts "--> NOK !"}
    
puts \ntest\ num\ [incr i]; #10
puts {
   * Assign Array with inline shorthand into inline shorthand :
      [( "A([(2+2)])" = 4 ;)]
      -----------------------------------------}
[( "A([(2+2)])" = 4 ;)]

if {$A(4) == 4} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #11
puts {
   * Inline shorthand into Array index
      set A([(3+2)]) 5
      ----------------------------}
set A([(3+2)]) 5

if {$A(5) == 5} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #12
puts {
   * Right associative rule for array :
      [( "A(7)" = "A(8)" = 78;)];
    -------------------------------------}
[( "A(7)" = "A(8)" = 78;)]

if {$A(7) == 78 && $A(8) == 78} {puts "--> ok"} else {puts "--> NOK !"}

puts \ntest\ num\ [incr i]; #13
puts {
   * Nested shorthand in array index :
      [( "A(9)" = $A([(2+2)]) + $A([(3+2)]) ;)];
      ----------------------------------------------------------------}
[( "A(9)" = $A([(2+2)]) + $A([(3+2)]) ;)]

if {$A(9) == 9}  {puts "--> ok"} else {puts "--> NOK !"}

