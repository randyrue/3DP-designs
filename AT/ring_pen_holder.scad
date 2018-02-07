// number of facets for the cylinders
// lower for quick rendering during editing
// higher for smooth cylinders for printing
$fn = 32;

// all measurements are in mm


// inner diameter of the thumb ring
t_id = 26;
// length/height of the thumb ring
t_ht = 25;
// width of the thumb ring split
t_sp = 11;
// thickness of the thumb ring
t_th = 1;


// inner diameter of the pen ring
p_id = 9;
// length/height of the pen ring
p_ht = 15;
// width of the pen split
p_sp = 5;
// thickness of the pen ring
p_th = .6;

// how much is the pen ring separated from the thumb ring
pr_offset=6;
// angle of the pen ring relative to the thumb ring
// 90 for "horizontal" use
// 0 for "vertical" use
pr_rot = 90;

// thumb ring
minkowski() {
    difference() {
        translate([0,0,0]) cylinder(d=t_id+t_th,h=t_ht);
        translate([0,0,-1]) cylinder(d=t_id,h=t_ht+2);
        translate([0,-t_sp/2,-1]) cube([t_id,t_sp,t_ht+2]);
    }
    sphere(r=1);
}

// pen ring
x_os = (t_id+t_th)/2 + (p_id+p_th)/2 + pr_offset;
translate([-x_os,0,t_ht/2])
rotate([pr_rot,0,180])
minkowski() {
    difference() {
        translate([0,0,0]) cylinder(d=p_id+p_th,h=p_ht,center=true);
        translate([0,0,-1]) cylinder(d=p_id,h=p_ht+2,center=true);
        translate([0,-p_sp/2,-p_ht/2-1]) cube([p_id,p_sp,p_ht+2]);
    }
    sphere(r=1);
}

// pen ring mount
translate([0,0,t_ht/2])
difference() {
    translate([-t_id-t_th+p_th,0,0])
    rotate([0,90,0])
    cylinder(d2=t_id,d1=1.15*p_id,h=3.25*pr_offset);
    cylinder(d=t_id-1, h=t_ht+5,center=true);
    translate([-x_os,0,0])
    rotate([pr_rot,0,180])    
    cylinder(d=p_id-1, p_ht+5, center=true);
}

//