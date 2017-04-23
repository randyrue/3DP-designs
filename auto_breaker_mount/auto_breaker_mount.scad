// number of relay insets
relays = 2;

// dimensions of relay body
relay_x = 21;
relay_y = 32;
relay_z = 18;

// inset of terminals from body end, edge to center
terminal_offset = 7.5;

// thickness of side, top, divider walls
wall_thickness = 3;

// cover specs
cover_height = 16;
cover_screw_diameter = 3;
pass_through_width = 8;

// terminal holes
// set to "rect" and set x,y, or set to "round" and set diameter d
// logic checks for "rect" and sets to round for anything else
// ignores irrelevant value set
bottom_hole = "round";
bottom_hole_x = 12;
bottom_hole_y = 9;
bottom_hole_d = 12;

top_hole = "rect";
top_hole_x = 13;
top_hole_y = 10;
top_hole_d = 12;

// mounting tabs width
mounting_tab_width = 12;
// screw hole diameters
mounting_screw_diameter = 4;


// uncomment the part you want to render
//baseplate();
//holder();
cover();

overall_x = relays * relay_x + wall_thickness*(relays+1);
overall_y = relay_y+2*wall_thickness;
overall_z = relay_z+wall_thickness;

module cover() {
rotate([0,0,0]) {
    difference() {
    union() {
        // main body
        cube([overall_x,overall_y,cover_height]);
        
        //cover tabs
        translate([overall_x-mounting_tab_width/2,overall_y-mounting_tab_width,0])
        cube([mounting_tab_width,mounting_tab_width,cover_height]);
        translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=cover_height);
        
        translate([-mounting_tab_width/2,0,0])
        cube([mounting_tab_width,mounting_tab_width,cover_height]);
        translate([-mounting_tab_width/2,mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=cover_height);
    }
    
    // cover holes
    // bumped out 1mm in diameter to accommodate top of screw
    translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,-1])
    cylinder(d=cover_screw_diameter+1,h=cover_height+2,$fn=24);
    translate([-mounting_tab_width/2,mounting_tab_width/2,-1])
    cylinder(d=cover_screw_diameter+1,h=cover_height+2,$fn=24);
    
    
    // main cavity
    translate([wall_thickness,wall_thickness,wall_thickness])
    cube([overall_x-2*wall_thickness,overall_y-2*wall_thickness,cover_height]);
    
    //wire pass-throughs
    for (i=[0:1:relays-1]) {
        // calculate offsets
        x_offset = i*(relay_x+wall_thickness)+wall_thickness;
        centerline = x_offset+relay_x/2;
        
        translate([centerline,overall_y+1,wall_thickness+pass_through_width/2])
        rotate([90,0,0])
        cylinder(d=pass_through_width,h=overall_y+2,$fn=24);
        
        translate([centerline-pass_through_width/2,-1,wall_thickness+pass_through_width/2])
        cube([pass_through_width,overall_y+2,cover_height]);
        
        
        
    }
    
}
}
}



module holder() {
rotate([180,0,0]) {
    difference() {
    union() {
        // main body
        cube([overall_x,overall_y,overall_z]);
        // mounting tabs
        translate([-mounting_tab_width/2,0,0])
        cube([mounting_tab_width,mounting_tab_width,overall_z]);
        translate([-mounting_tab_width/2,mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=overall_z);
        translate([overall_x-mounting_tab_width/2,overall_y-mounting_tab_width,0])
        cube([mounting_tab_width,mounting_tab_width,overall_z]);
        translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=overall_z);
        
        //cover tabs
        translate([overall_x-mounting_tab_width/2,0,overall_z-10])
        cube([mounting_tab_width,mounting_tab_width,10]);
        translate([overall_x+mounting_tab_width/2,mounting_tab_width/2,overall_z-10])
        cylinder(d=mounting_tab_width,h=10);
        translate([-mounting_tab_width/2,overall_y-mounting_tab_width,overall_z-10])
        cube([mounting_tab_width,mounting_tab_width,10]);
        translate([-mounting_tab_width/2,overall_y-mounting_tab_width/2,overall_z-10])
        cylinder(d=mounting_tab_width,h=10);
    }
    //mounting holes
    translate([-mounting_tab_width/2,mounting_tab_width/2,-1])
    cylinder(d=mounting_screw_diameter,h=overall_z+2,$fn=24);
    translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,-1])
    cylinder(d=mounting_screw_diameter,h=overall_z+2,$fn=24);
    
    // cover holes
    translate([overall_x+mounting_tab_width/2,mounting_tab_width/2,-1])
    cylinder(d=cover_screw_diameter,h=overall_z+2,$fn=24);
    translate([-mounting_tab_width/2,overall_y-mounting_tab_width/2,-1])
    cylinder(d=cover_screw_diameter,h=overall_z+2,$fn=24);
    
    
    //relay slots and terminal holes
    for (i=[0:1:relays-1]) {
        // relay body sockets
        x_offset = i*(relay_x+wall_thickness)+wall_thickness;
        centerline = x_offset+relay_x/2;
        translate([x_offset,wall_thickness,-1])
        cube([relay_x,relay_y,relay_z+1]);
        
        // bottom holes
        if (bottom_hole == "rect") {
            translate([centerline-bottom_hole_x/2,wall_thickness + terminal_offset - bottom_hole_y/2,-1])
            cube([bottom_hole_x,bottom_hole_y,overall_z+2]);
        }
        else {
            // assumes round hole
             translate([centerline,wall_thickness + terminal_offset,-1])
            cylinder(d=bottom_hole_d, h=overall_z+2);
        }
        
        // top holes
        if (top_hole == "rect") {
            translate([centerline-top_hole_x/2,overall_y-wall_thickness-terminal_offset-top_hole_y/2,-1])
            cube([top_hole_x,top_hole_y,overall_z+2]);
        }
        else {
            // assumes round hole
             translate([centerline,overall_y-wall_thickness-terminal_offset,-1])
            cylinder(d=top_hole_d, h=overall_z+2);
        }
    }
    
}
}
}


module baseplate() {
rotate([180,0,0])    
difference() {
    union() {
        cube([overall_x,overall_y,wall_thickness]);
        translate([-mounting_tab_width/2,0,0])
        cube([mounting_tab_width,mounting_tab_width,wall_thickness]);
        translate([-mounting_tab_width/2,mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=wall_thickness);
        translate([overall_x-mounting_tab_width/2,overall_y-mounting_tab_width,0])
        cube([mounting_tab_width,mounting_tab_width,wall_thickness]);
        translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,0])
        cylinder(d=mounting_tab_width,h=wall_thickness);
    }
    translate([-mounting_tab_width/2,mounting_tab_width/2,-1])
    cylinder(d=mounting_screw_diameter,h=mounting_tab_width/2,$fn=24);
    translate([overall_x+mounting_tab_width/2,overall_y-mounting_tab_width/2,-1])
    cylinder(d=mounting_screw_diameter,h=mounting_tab_width/2,$fn=24);
}
}