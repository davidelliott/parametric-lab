d=10; // diameter of the probe
height=30; // overall height
wall_width=2; // thickness of the main wall
rim_width=1; // width of the rim that will grip the probe
stop_width=2; // width of the stop that prevents the cover sliding all the way up the probe
stop_height=height/2; // position of the stop
dia=d+rim_width; // calculate the main bore diameter which should be a bit wider than the probe
hole_rad=3.5; // radius of holes to expose the probe to the medium

$fn=36;

difference(){
main();
cutout();
}

module cutout(){
// slit 1
translate([0,-dia*1.5,-0.1]){
cube([1,dia*3,stop_height-stop_width]);
}

// slit 2
rotate([0,0,90]){
translate([0,-dia*1.5,-0.1]){
cube([1,dia*3,stop_height-stop_width]);
}
}

// holes
translate([0,dia*1.5,height*0.75]){
rotate([90,00,0]){
cylinder(r=hole_rad,h=dia*3);
}
}

// more holes
translate([-dia*1.5,0,height*0.75]){
rotate([90,0,90]){
cylinder(r=hole_rad,h=dia*3);
}
}

}



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

