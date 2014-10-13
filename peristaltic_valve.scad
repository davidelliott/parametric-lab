// peristaltic valve
// https://github.com/davidelliott/parametric-lab 
// License: CC-BY

// This design is for a peristaltic valve which can pinch multiple tubes to control flow.


// Main configurable parameters
explode_multiplier=0; // set at zero to disable exploding the design - output will appear as finished object
pipe_outer_dia=6;
pipe_bore_dia=2;

pipe_spacing=19; // distance between in/out pipes where they emerge in the housing
//bolt_radius=3.2; // M6 bolt diameter = 6mm, leave some clearance
// servo to be installed on side
servo_length=24.6;
servo_hole_spacing=28.6;
servo_axis_z=11.6/2;
servo_axis_x=7; // manual measurement - not shown on data sheet
servo_width=11.6;
servo_depth=24; // this is the depth of the main body along the rotating axis
//cam_axle_height=valve_height-servo_axis_z;
cam_axle_radius=3;
	roller_radius=3.15; // M6 rod could be used as the roller
fn_resolution=70; //quality vs render time
$fn=fn_resolution;
housing_floor_thickness=0; // this var needs to be removed, part of another design
housing_length=65;

peristaltic_valve_cutout_radius=15; // better to have this a fixed size suitable for the parts being used.
valve_height=30;
valve_wall_thickness_y=4; // sides where the axis / servo are
valve_wall_thickness_x=6; // front and back
valve_base_thickness=3;
valve_base_length=10;
cam_clearance=2;

pipe1_y = 20;
pipe2_y = pipe1_y+pipe_spacing;

peristaltic_pipe_radius=pipe_outer_dia/2;
///////////////////////////////
// calculate important dimensions
// Some of these would be suitable for manual setting
// The calculations just make reasonable estimates
pinch_depth=(pipe_bore_dia*2)/3;
axle_length=(2*cam_clearance)+valve_wall_thickness_y;

//h_in=valve_height/3; // height of inlet pipe
//h_out=valve_height/4; // height of outlet pipe

h_in=housing_floor_thickness+valve_base_thickness+cam_clearance;

valve_length=(peristaltic_valve_cutout_radius+valve_wall_thickness_x+cam_clearance)*2;

cam_axle_height=h_in+peristaltic_valve_cutout_radius+pinch_depth;

// Note
// cam_clearance raises up the cam a bit so it will not catch.
// however the roller distance to the pipe should be accurate, hence
// the cam_clearance is added to the base, raising the floor
// i.e. the clearance applies to the cam but does not affect the pinching depth

//////////////////////////////////
show=1; // 1=printable; 2=assembled; 3=testing

if(show==3) {
intersection(){
cam();
peristaltic_valve();
}
}

if(show==2) {
/// Show complete assembly ///
// add the peristaltic valve
//color("orange")
peristaltic_valve();

// add the valve cam
color("red")
cam();

// add the valve cam roller
color("purple")
cam_roller();

// show the servo
color("blue")
servo();

} /// End of complete assembly ///

if(show==1) {
/// Show individual parts arranged for printing ///
translate([-10,0,valve_height]){
rotate([0,180,0]){
difference(){
cam();
servo();
}
}
}

difference(){
peristaltic_valve();
servo();
}

translate([40,0,cam_roller_length]){
rotate([270,0,0]){
cam_roller();
}
}

} /// End of printable parts ///

///////////////
// VARIABLES //
///////////////
// these variables are used by the modules and probably don't need to be changed usually
valve_xpos=0;
valve_width=pipe_spacing*3;
valve_length_middle=valve_xpos+(valve_length/2);
valve_cutout_y=valve_width-(2*valve_wall_thickness_y); //offset+chamber_wall_thickness/2;
valve_ypos=0;
cam_roller_length=valve_cutout_y-(0.5*valve_wall_thickness_y)-(1*cam_clearance);


/////////////
// MODULES //
/////////////

module cam(explode=0) {
explode=explode*explode_multiplier;


	// Build a cylinder then cut parts away.
	difference(){
		// the main cylinder
		translate([valve_length_middle,valve_ypos+valve_cutout_y+valve_wall_thickness_y-(0.5*cam_clearance),cam_axle_height+explode]){
			rotate([90,0,0]) {
				cylinder(r=peristaltic_valve_cutout_radius-cam_clearance,h=valve_cutout_y-cam_clearance,$fn=fn_resolution);
			}
		}

		// cut off the top which is not needed
		translate([valve_xpos,valve_ypos,cam_axle_height+servo_axis_z-1+explode]){
			cube([valve_length,valve_width,servo_width+1]);
		}

		// Cut out a groove for the outlet pipe roller
		translate([valve_length_middle,pipe1_y,cam_axle_height+explode]){
			rotate([90,0,0])
			rotate_extrude(convexity = 10,$fn=100)
			translate([peristaltic_valve_cutout_radius-cam_clearance,0, 0])
			circle(r = peristaltic_pipe_radius*2.5, $fn=100);
		}

		// Cut out a groove for the inlet pipe roller
		translate([valve_length_middle,pipe2_y,cam_axle_height+explode]){
			rotate([90,0,0])
			rotate_extrude(convexity = 10,$fn=100)
			translate([peristaltic_valve_cutout_radius-cam_clearance,0, 0])
			circle(r = peristaltic_pipe_radius*2.5, $fn=100);
		}

		// cut out a hole for the roller to go in
		// the hole is offset so it is only open at one end
		translate([valve_length_middle,valve_ypos+valve_cutout_y+(1.25*valve_wall_thickness_y),cam_axle_height-peristaltic_valve_cutout_radius+cam_clearance+roller_radius+explode]){
			rotate([90,0,0]) {
				cylinder(r=roller_radius+0.1,h=cam_roller_length,$fn=fn_resolution);
			}
		}

		// cut off the sharp edge on the roller hole
		translate([valve_length_middle,valve_ypos+valve_cutout_y+(1.25*valve_wall_thickness_y),cam_axle_height-peristaltic_valve_cutout_radius+cam_clearance+explode]){
			rotate([90,0,0]) {
				cylinder(r=0.75*(roller_radius+0.1),h=cam_roller_length,$fn=fn_resolution);
			}
		}
	

	// make hole for an axle on the end where the servo is not
	
	translate([valve_length_middle,valve_ypos+valve_cutout_y+valve_wall_thickness_y-(0.5*cam_clearance)+axle_length+0.01,cam_axle_height+explode]){
		rotate([90,0,0]) {
			cylinder(r=cam_axle_radius,h=valve_cutout_y-cam_clearance+axle_length,$fn=fn_resolution);
		}
	}
	
	} // end of difference group
}


module cam_roller(explode=0) {
explode=explode*explode_multiplier;

	// draw the roller
		translate([valve_length_middle,valve_ypos+valve_cutout_y+(0.5*valve_wall_thickness_y),cam_axle_height-peristaltic_valve_cutout_radius+cam_clearance+roller_radius+explode]){
			rotate([90,0,0]) {
				cylinder(r=roller_radius,h=cam_roller_length,$fn=fn_resolution);
			}
		}

}


// servo - this is not part of the design but it's shape needs to be subtracted from some parts
module servo(explode=0) {
explode=explode*explode_multiplier;
	bracket_length=34;
	bracket_offset_y=2.5;
bracket_thickness=0.5;
rotor_drive_depth=6;
rotor_thickness=3.8;
rotor_length=17;
rotor_depth=5;
servo_depth_full=servo_depth+rotor_drive_depth;
first_hole=(servo_length-servo_hole_spacing)/2;



	translate([valve_length_middle-servo_length+servo_axis_x,valve_ypos-servo_depth+bracket_offset_y-bracket_thickness,cam_axle_height-servo_axis_z+explode]){
	cube([servo_length,servo_depth,servo_width]);

	// bracket

	translate([-(bracket_length-servo_length)/2,servo_depth-bracket_offset_y,0]){
	cube([bracket_length,bracket_thickness,servo_width]);
	}
	// screw hole 1
	translate([first_hole,servo_depth,servo_width/2])
	rotate([90,0,0])
	cylinder(r=1,h=servo_depth_full);

	// screw hole 2
	translate([first_hole+servo_hole_spacing,servo_depth,servo_width/2])
	rotate([90,0,0])
	cylinder(r=1,h=servo_depth_full);

	// rotor drive
	translate([servo_length-servo_axis_x,servo_depth_full+0.01,servo_width/2]){
		rotate([90,0,0]){
		cylinder(d=18,h=rotor_drive_depth);
		}
	}

	// axle
	translate([servo_length-servo_axis_x,servo_depth_full+rotor_thickness+2,servo_width/2]){
		rotate([90,0,0]){
		cylinder(r=0.3,h=servo_depth_full);
		}
	}
	// rotor
	translate([servo_length-servo_axis_x-(rotor_length/2),servo_depth_full-rotor_drive_depth,(servo_width/2)-rotor_thickness/2]){
		//cube([rotor_length,rotor_depth+rotor_drive_depth,rotor_thickness]);
	}

	translate([servo_length-servo_axis_x-(rotor_thickness/2),servo_depth_full-rotor_drive_depth,(servo_width/2)+rotor_length/2]){
	rotate([0,90,0]){
			cube([rotor_length,rotor_depth+rotor_drive_depth,rotor_thickness]);
		}
	}

}	

}


module peristaltic_valve(explode=0) {
explode=explode*explode_multiplier;

first_hole=(servo_length-servo_hole_spacing)/2;
// Build the main control surface: a cuboid with cylindrical cutout
difference(){
	// A cuboid from which we will cut away to make the shape
	translate([valve_xpos,valve_ypos,housing_floor_thickness+explode]){
		cube([valve_length,valve_width,valve_height-housing_floor_thickness]);
	}	
	
	// cutting away several bits - therefore use union here to merge the cutout shapes
	union(){
	// Cut out a cylinder
	translate([valve_length_middle,valve_ypos+valve_cutout_y+valve_wall_thickness_y,cam_axle_height+explode]){
		rotate([90,0,0]) {
			cylinder(r=peristaltic_valve_cutout_radius,h=valve_cutout_y,$fn=fn_resolution);
		}
	}
	// cut out a path for the outlet pipe
	translate([valve_xpos-1,pipe1_y-peristaltic_pipe_radius,h_in+cam_clearance-pinch_depth+explode]){
		cube([housing_length+1,pipe_outer_dia,valve_height]);
	}
	
	// cut out a path for the intlet pipe
	translate([valve_xpos-1,pipe2_y-peristaltic_pipe_radius,h_in+cam_clearance-pinch_depth+explode]){
		cube([housing_length+1,peristaltic_pipe_radius*2,valve_height]);
	}

	// cut off the top of the middle bit which is not needed
	translate([valve_xpos-1,pipe1_y-peristaltic_pipe_radius+1,h_in+cam_clearance-pinch_depth+peristaltic_pipe_radius*2+explode]){
		cube([housing_length+1,pipe2_y-pipe1_y,valve_height]);
	}

	}

	// cut out a hole for the cam axle
	translate([valve_length_middle,chamber_external_radius+valve_width,cam_axle_height+explode]){
		rotate([90,0,0]) {
			cylinder(r=cam_axle_radius*1.05,h=valve_cutout_y*2,$fn=fn_resolution);
		}
	}
	
	// axle hole
	translate([valve_length_middle,valve_ypos+valve_cutout_y+valve_wall_thickness_y-(0.5*cam_clearance)+axle_length+0.01,cam_axle_height+explode]){
		rotate([90,0,0]) {
			cylinder(r=cam_axle_radius,h=valve_cutout_y-cam_clearance+axle_length,$fn=fn_resolution);
		}
	}

	// cut out a hole where the servo will be mounted
	translate([valve_length_middle-servo_length+servo_axis_x,valve_ypos-1,cam_axle_height-servo_axis_z+explode]){
	cube([servo_length,7.3,servo_width+1]);

	// screw hole 1
	translate([first_hole,7.3,servo_width/2])
	rotate([90,0,0])
	cylinder(r=1,h=7.3);

	// screw hole 2
	translate([first_hole+servo_hole_spacing,7.3,servo_width/2])
	rotate([90,0,0])
	cylinder(r=1,h=7.3);

}	

	// cut off the top because we cannot build over the top of the servo hole
	// anyway nothing is needed above the control surface
	translate([valve_xpos-1,valve_ypos-1,cam_axle_height+servo_axis_z+explode]){
	cube([valve_length+2,valve_width+1.1,valve_height]);
	}

}

	// add a base with screw holes
	difference(){
	translate([valve_xpos-valve_base_length,valve_ypos,housing_floor_thickness+explode]){
		cube([valve_length+(2*valve_base_length),valve_width,valve_base_thickness]);
	}	

	// screw holes
	valve_mounting_screw_holes(explode=explode);
	}

}

module valve_mounting_screw_holes(explode=0) {
explode=explode*explode_multiplier;
z=-0.5*valve_height+explode;
y0=valve_ypos+(0.1*valve_width);
y1=valve_ypos+(0.9*valve_width);
y2=valve_ypos+(0.5*valve_width);

x0=valve_xpos-0.5*valve_base_length;
x1=valve_xpos+0.5*valve_base_length+valve_length;

	//valve_width
	translate([x0,y0,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
	translate([x0,y1,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
	translate([x0,y2,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
	translate([x1,y0,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
	translate([x1,y1,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
	translate([x1,y2,z]) 
		cylinder(h=valve_height, r=2.6, $fn=fn_resolution);
}
