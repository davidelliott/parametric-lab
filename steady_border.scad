// steady border
// https://github.com/davidelliott/parametric-lab 
// License: CC-BY

// This design is for a border which can be easily taped or screwed
// down to keep items steady
// The edge width can be varied according to the width of tape being
// used, and the tabs with screw holes are optional.

// TODO
// option to include an interior floor might be useful

///////////////////////////
// Adjustable parameters //
///////////////////////////
x=52; // size of main hole x dimension
y=152; // size of main hole y dimension
z=5; // size of main hole z dimension
wall=3; // width of main wall
edge=6; // width of flat area outside of main wall which is meant for sticking tape to
edge_z=1; // height of flat area
tab_x=2; // number of tabs along x walls
tab_y=4; // number of tabs along y walls

// Calculate some dimensions
base_x=x+(2*edge);
base_y=y+(2*edge);
tab_x_step=base_x/(max(tab_x-1,1)); // max() is used to avoid having
tab_y_step=base_y/(max(tab_y-1,1)); // step of infinity when only 1 tab specified

// Build the object
difference(){
union(){

// flat base
cube([base_x,base_y,edge_z]);

// raised centre
translate([edge-wall,edge-wall,0]){
cube([x+(2*wall),y+(2*wall),z]);
}

// tabs
if(tab_x+tab_y>0){
for(xx=[0:max(tab_x-1,0)]) {
for(yy=[0:max(tab_y-1,0)]) {
translate([xx*tab_x_step,yy*tab_y_step,0]){
cylinder(r=edge,h=edge_z);
}
}
}
}
} // end of union
// Following parts are subtracted

// cut out hole
translate([edge,edge,-1]){
cube([x,y,z+2]);
}

// cut out screw holes in tabs

if(tab_x+tab_y>0){
for(xx=[0:tab_x-1]) {
for(yy=[0:tab_y-1]) {
translate([xx*tab_x_step,yy*tab_y_step,-0.1]){
cylinder(r1=1,r2=3,h=edge_z+0.2);
}
}
}
}

} // end of difference
