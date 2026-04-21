package require Tk
 
proc programit { level } {(
    
    [global tagcount];
    tagcount=1 ;
    noofiter=pow(8,$level - 1); 
    noofiter=int($noofiter);
    count=1;
 
    [while { $count <= $noofiter } { 
	divideem $level $count 
	incr count 
    }
     incr level ];
 
    [if { $level < 6 } { 
	after 1000 programit $level 
    } else {
	tk_messageBox -title "EXIT MESSAGE" -message "PROGRAM COMPLETED";
	after 5000 exit
    }]
)}
 
proc divideem {level count } {( 
    [global tagcount
     lassign [.c coords sq$level$count] x0 y0 x1 y1   ];
    maxsize= $x1 - $x0;
    x = $x0;
    count=1; 
 
    [while { $x < ($x1 - 1)} {(
	y=$y0;
	[while { $y < ($y1 - 1) } {(
	    [if { $count == 5 } {(
		colo="white"; tg="dummy"
	     )} else {(
		colo="black"; tg="sq[($level + 1)]$tagcount"; tagcount = $tagcount+1
	     )}
	     
	    .c create rect $x $y {*}[( $x + $maxsize / 3.0, $y + $maxsize / 3.0 )] \
		-fill $colo -outline $colo -tag $tg
	    ];
	    y= $y + $maxsize / 3.0;
	    count = $count+1
	)}];
	x=$x + $maxsize / 3.0
    )}]
)}
 
 canvas .c -width 990 -height 990 -bg black 
 
 .c create rect 0 0 990.0 990.0 -fill white -tag sq11 
 
 programit 1 
 pack .c
