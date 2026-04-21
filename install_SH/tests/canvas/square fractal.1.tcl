 package require Tk
 
 proc programit { level } {
 
     global tagcount 
 
     set tagcount 1 
     set noofiter [expr {pow(8,[expr $level - 1])}] 
     set noofiter [expr {int($noofiter)}] 
     set count 1 
 
     while { $count <= $noofiter } { 
         divideem $level $count 
         incr count 
     } 
     incr level 
 
     if { $level < 6 } { 
         after 1000 programit $level 
     } else {
         tk_messageBox -title "EXIT MESSAGE" -message "PROGRAM COMPLETED";
         after 5000 exit
     }
 }
 
 proc divideem { level count } { 
     global tagcount 
     foreach { x0 y0 x1 y1 } [.c coords sq$level$count] {} 
     set maxsize [expr $x1 - $x0] 
     set x $x0 
     set count 1 
 
     while { $x < [expr $x1 - 1] } { 
         set y $y0 
         while { $y < [expr $y1 - 1] } { 
             if { $count == 5 } {
                 set colo white; set tg dummy
             } else {
                 set colo black; set tg sq[expr $level + 1]$tagcount; incr tagcount;
             } 
             .c create rect $x $y [expr $x + $maxsize / 3.0] [expr $y + $maxsize / 3.0] \
                 -fill $colo -outline $colo -tag $tg 
             set y [expr $y + $maxsize / 3.0] 
             incr count 
         } 
         set x [expr $x + $maxsize / 3.0] 
     } 
 }
 
 canvas .c -width 990 -height 990 -bg black 
 
 .c create rect 0 0 990.0 990.0 -fill white -tag sq11 
 
 programit 1 
 pack .c
