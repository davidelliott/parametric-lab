// flexible grid
// https://github.com/davidelliott/parametric-lab 
// License: CC-BY

// This design is for a flexible interlocking grid system
// initially made for holding small petri dishes in position
// Code is quite rough but it works for the original purpose
// Design is not fully parameterised

// TO DO / known problems
// bug- Grid has to be a square - i.e. cells_x = cells_y
// feature- option for cells to not be square

// set parameters
hole_size=50;
wall_width=5;
height=4;
unit_length=hole_size+wall_width;
cells_x=3;
cells_y=3;
total_x=unit_length*cells_x;
total_y=unit_length*cells_y;
floor_thickness=0.5; // Set 0 for no base

// print the total dimensions
echo(total_x);
echo(total_y);

// build the objects
main();

translate([0,total_y+wall_width*1.5,0]){
extra_wall();
}

rotate([0,0,-90]){
translate([-total_x-wall_width,total_y+wall_width*1.5,0]){
extra_wall(option=0);
}
}

//////////////
// MODULES //
/////////////

module extra_wall(option=1){
	

	difference(){
	union(){
		cube([total_x,wall_width,height]);
rotate([180,0,90]){
	translate([0,total_x,-height]){
		if(option){connector_array(start=0,end=0);}
	}
}
} // end of union
// now remove the sockets
		
		translate([0,0,-2]){
			connector_array(h=height+5,adj=1.1,start=0,end=cells_x-option);
		}
	}

}


module main(){
difference() {
union() {
// build the base.
color("brown")
cube([total_x,total_y,floor_thickness]);

// build the grid
for(i=[0:cells_x-1]) {
		translate([0,i*(unit_length),0]){
			cube([total_x,wall_width,height]);
		}
	}

for(i=[0:cells_y-1]) {
		translate([i*(unit_length),0,0]){
			cube([wall_width,total_y,height]);
		}
}

// add reinforcements
for(i=[0:cells_x-1]) {
	
	translate([0,i*(unit_length)+wall_width,0]){
rotate([0,0,270]){
		reinforcement(i);
	}
}
}

for(i=[0:cells_y]) {
		translate([i*(unit_length),0,0]){
			reinforcement(i);
		}
}


// add connectors
translate([0,total_y,0]){
connector_array(start=0,end=cells_y-1);
}

rotate([180,0,90]){
	translate([0,total_x,-height]){
		connector_array(start=0,end=cells_x-1);
	}
}



} // end of union

// remove connector sockets
translate([0,0,-2]){
	connector_array(h=height+5,adj=1.1,start=0,end=cells_x-1);
}
rotate([180,0,90]){
	translate([0,0,-height-2]){
		connector_array(h=height+5,adj=1.1,start=0,end=cells_y);
	}
}


} // end of difference group
} // end of module main


module connector_array(h=height,adj=1,start=0,end=cells_y) {
	for(i=[start:end]) {
		translate([i*(unit_length),0,0]){
			connector(h=h,adjust=adj);
		}
	}
}

module connector(subtract=false,adjust=1) {
translate([0,0,0]){
hull(){
translate([-wall_width*adjust/2,wall_width*adjust/2,0]){
cube([wall_width*2*adjust,1*adjust,h]);
}
cube([wall_width*adjust,1*adjust,h]);
}
translate([0,-3,0]){
	cube([wall_width*adjust,5,h]);
}
}
}


module reinforcement(i=1) {
if(i<cells_x){
reinforcement_part();
}
if(i>0) {
translate([wall_width-0.1,0,0]){
mirror("x"){
reinforcement_part();
}
}
}
}

module reinforcement_part() {
r=wall_width;
difference(){
translate([wall_width-0.1,r,0]){
cylinder(r=r,h=height);
}

translate([-0.1,-0.1,-1]){
cube([r*4,wall_width,height*2]);
cube([wall_width-0.01,r*3,height*2]);
}
} // end of difference
}



