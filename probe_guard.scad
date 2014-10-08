dia=10;
height=30;
wall_width=3;
rim_width=1;
stop_width=2;
stop_height=height/2;

main();

module main(){
// build a pipe
difference(){
cylinder(d=dia+wall_width,h=height);
translate([0,0,-1])
cylinder(d=dia,h=height+2);
}

// add bottom rim
translate([0, 0, rim_width]){
rotate_extrude(convexity = 10)
translate([dia/2, 0, 0])
circle(r = rim_width, $fn = 100);
}

// add top rim
translate([0, 0, height-rim_width]){
rotate_extrude(convexity = 10)
translate([dia/2, 0, 0])
circle(r = rim_width, $fn = 100);
}

// add centre stop
translate([0, 0, stop_height]){
rotate_extrude(convexity = 10)
translate([dia/2, 0, 0])
circle(r = stop_width, $fn = 100);
}

}

// TODO
// slits in top
// holes in bottom
