catch {grid [canvas .c -width 400 -height 300 -bg gray85]}

proc layout_Orig {} {
    set s 50
    set e [.c create text 250 $s -text "One" -anchor n]
    foreach item { Two Three Four } {
	lassign [.c bbox $e] * * * y
	set next [expr {$y+50}]
	.c create line 250 $y 250 $next -arrow last
	set e [.c create text 250 $next -text $item -anchor n]
    }
}

proc layout_SH {} {(
    s=50;
    e=[.c create text 150 $s -text "One" -anchor n];
    [foreach item {Two Three Four} {(
	[lassign [.c bbox $e] * * * s];
	next=$s+50;
	[.c create line 150 $s 150 [(s=$next)] -arrow last];
	e=[.c create text 150 $s -text $item -anchor n]
     )}]
)}

foreach proc {Orig SH} {(
    "speed($proc,1)"= "speed($proc,m)" = [lindex [timerate [list layout_$proc]] 0];
    [foreach i {2 3} {(
	"speed($proc,$i)"=[lindex [timerate [list layout_$proc]] 0];
	"speed($proc,m)"=$speed($proc,m) + $speed($proc,$i)
	)}];
    "speed($proc,m)" = $speed($proc,m)/3
)}
    
