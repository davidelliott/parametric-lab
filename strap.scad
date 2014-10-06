// strap
// https://github.com/davidelliott/parametric-lab 
// License: CC-BY

// This design is for a strap which can be screwed down to secure objects
// The simple design allows for several straps to be screwed together
// to make a longer one. 
// This first version is meant for holding curved objects like bottles
// in a 180 degree curved strap

// TODO / ideas
// Option to screw directly down
// option to change angle of anchor

strap_x=150; // length
strap_y=10; // width
strap_z=0.5; //thickness

anchor_x=7; // shoud be small to minimise strain
anchor_y=strap_y; // make sure this is big enough for the screw head
anchor_z=10; // total height of the anchor excluding the strap itself
anchor_hole_d=4;

$fn=100;

// strap
cube([strap_x,strap_y,strap_z]);
anchor();
translate([strap_x-anchor_x,0,0])
anchor();

// anchor
module anchor(){
	difference(){
	hull(){
	cube([anchor_x,anchor_y,strap_z]);
	translate([0,strap_y/2,strap_z+anchor_z/2])
	rotate([0,90,0])
	cylinder(d=anchor_z,h=anchor_x);
	}
	translate([-1,strap_y/2,strap_z+anchor_z/2])
	rotate([0,90,0])
	cylinder(d=anchor_hole_d,h=anchor_x+2);
}
}

