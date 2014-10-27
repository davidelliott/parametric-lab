// matrix maze
// https://github.com/davidelliott/parametric-lab 
// License: CC-BY

// this design enables simple mazes to be easily made by defining
// the presence of walls or gaps in an array.

// size of blocks and gaps
cell_x=8; 
cell_y=8; 

// size of hole inside blocks
hole_x=6.5; 
hole_y=6.5;

// calculate hole position in each block
hole_x_pos=(cell_x-hole_x)/2; 
hole_y_pos=(cell_y-hole_y)/2;

z=8; // height of walls
f=1;  // height of floor
hole_height=-0.1; // increase for strength, decrease to save plastic/time

// define the maze as an array of z (walls) and f (floor)
// example from http://www.amentsoc.org/bug-club/fun/experiment-turning.html
m = [
[z,f,z,f,f,f,f,f,z,f,z],
[z,f,z,f,f,f,f,f,z,f,z],
[z,f,z,z,z,z,z,z,z,f,z],
[z,f,f,f,f,f,f,f,f,f,z],
[z,f,z,z,z,f,z,z,z,f,z],
[z,f,z,f,z,f,z,f,z,f,z],
[z,f,z,f,z,f,z,f,z,f,z]
];

// find the array dimensions
len_x=len(m)-1;
len_y=len(m[0])-1;

// loop through the array
for(x = [0 : len_x]) {
for(y = [0 : len_y]) {
	translate([x*cell_x,y*cell_y,0]){
		difference(){
		// build a cube for the current position
		// the height defined in the array is what
		// determines presence of a wall or gap
		cube([cell_x,cell_y,m[x][y]]);
		// now to save time and plastic
		// make the walls hollow by subtraction of a 
		// smaller cube.
		translate([hole_x_pos,hole_y_pos,hole_height]){
		if(m[x][y]==z) { 
			cube([hole_x,hole_y,m[x][y]+1]);
		}
		}
	}
	}
}
}

