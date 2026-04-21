proc graphscale-sh {v vmin vmax pixels} {(
    $pixels*($v-$vmin)/($vmax-$vmin)
)}

proc plot-sh {res labels} {(
    # adapted the simple graph plotter, https://wiki.tcl-lang.org/8552
    [upvar [set state [namespace current]::plot_[clock clicks]] plot];
    [array set plot [list busy 0 colors {ff 00 00} res $res labels $labels]];
    "plot(newcolors)"=$plot(colors);
    width=[winfo screenwidth .] / 2;
    height=[winfo screenheight .] / 2;
    [if [winfo exists .c] { ;# delete it. Same as clear.
	 destroy .c
    }
     canvas .c -width $width -height $height \
	 -xscrollincrement 1 -bg beige
     pack .c -expand 1 -fill both
     wm title . Graph
     bind .c <Configure> [list draw-sh $state]
     event generate .c <Configure>
     ];
    $state
)}

proc draw-sh {plot} {(
    [upvar [namespace current]::$plot plot[unset plot]
     if {$plot(busy)} return
     set plot(busy) 0
     .c addtag all all
     .c delete all  ];
    "plot(newcolors)"=$plot(colors);
    res=[lsort -real -index 0 $plot(res)];
    # get range of x & y
    width=[winfo width .c];
    height= [winfo height .c];
    xmin = xmax = ymin = ymax = 0;
    nvars=[llength [lindex $res 0]]-1;
    [foreach item $plot(res) {(
	 y = [lassign $item r];
	 xmin = min($xmin, $r);
	 xmax = max($xmax, $r);
	 [foreach yv $y {(
	      # get range of Y coordinate
	      ymin = min($ymin, $yv);
	      ymax = max($ymax,$yv)
	      )}]
	 )}];
    # how often tick marks
    tspace = ($xmax-$xmin)/8.0;
    # how often to draw grid in X
    nexttic = int($xmin/$tspace)*$tspace;
    [while {$nexttic < $width} {(
	 # draw grid
	 xpix = [graphscale-sh $nexttic $xmin $xmax $width];
	 nexttic =$nexttic+$tspace;
	 [.c create text [($xpix-10)] 0 -anchor n -text [format %.2f $nexttic] \
	     -fill gray
	  .c create line $xpix 0 $xpix $height -fill gray]
       )}
     ]; 
    #how often Ytick marks
    tspace = ($ymax-$ymin)/8.0;
    # how often to draw grid in X
    nexttic = int($ymin/$tspace)*$tspace;
    [while {$nexttic < $ymax} {(
	 # draw grid
	 ypix=[graphscale-sh $nexttic $ymax $ymin $height];
	 nexttic=$nexttic+$tspace;
	 [.c create text 20 [($ypix-10)] -anchor n -text [format %.2f $nexttic] \
	      -fill gray
	  .c create line 0 $ypix $width $ypix -fill gray]
	 )}];
    lastheight=$height;
    [for (iy=0) {$iy<$nvars} {incr iy} {(
	 [lassign $plot(newcolors) red green blue
	  lappend plot(newcolors) $red
	 ];
	 "plot(newcolors)"=[lreplace $plot(newcolors) 0 0];
	 #label graph
	 label=[lindex $plot(labels) $iy];
	 [.c create text -1000 0 -anchor n -text $label -fill #$red$green$blue -tag $label 
	  lassign [.c bbox $label] textx1 texty1 textx2 texty2
	 ];
	 textwidth=abs($textx2-$textx1);
	 textheight=abs($texty2-$texty1);
	 [  .c coords $label [($width-$textwidth)] \
	      [(lastheight=$lastheight-$textheight)]];
	 coordlist={};
	 [foreach item $res {(
	      y=[lassign $item r];
	      xpix=[graphscale-sh $r $xmin $xmax $width];
	      vv=[lindex $y $iy];
	      v=[graphscale-sh $vv $ymax $ymin $height];
	      [lappend coordlist $xpix $v];
	      rold=$xpix;
	      # vector of y values
	      yold=$v
	      )}
	  .c create line $coordlist -fill #$red$green$blue] 
       )}];
    "plot(busy)"=0
)}

proc examples-sh {} {(
    plot=[list];
    [for (i=0) {$i<20} {incr i} {
        lappend plot [($i/3.0, sin($i/3.0), cos($i/3.0))]
    }];

    names={Sine Cos};
    [plot-sh $plot $names]
)}

examples-sh
