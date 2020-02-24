// A threaded lid for a standard narrow mouth home canning jar (Ball, Mason, etc.)
// Dependency:  round_threads.scad

//  David O'Connor https://www.thingiverse.com/lizard00
//
//  This work is under the Creative Commons 3.0 Attribution Unported (CC-BY-3.0) license.
//  (https://creativecommons.org/licenses/by/3.0/)
//
// 23 November 2018

// Reference:  https://en.wikipedia.org/wiki/Mason_jar

// You'll need to change the path to work with your particular file system
//use <round_threads.scad>

thread = 3;             // Thread diameter

// According to Wikipedia, the outside diameter is 70 mm (86 mm for wide mouth) 
// Below is some trial-and-error for getting the dimensions correct.  This was on a Creality CR-10S
//   with Tianse PLA filament; bed at 60 C and hot end at 225.  Your results may vary.
//d_nominal = 70.6;     // Nominal measured jar rim diameter (This value way too big; threads don't even engage.)
//d_nominal = 66.5;     // Snug; barely fits

//Replace $fs=0.2 with $fs=2
//Replace $fa=5 with $fa=1

$fn=100;

d_nominal = 67.2;       // *** USE THIS ONE FOR NARROW ***
                        //        Good compromise for narrow mouth; spins onto jar nicely without being overly sloppy
                        
//d_nominal = 83.2;     // Estimate for wide mouth, *slightly* snug but works fine.

//d_nominal = 83.3;     //  *** USE THIS ONE FOR WIDE ***
                        //         Wide mouth, if I were going to do it again.

d_clearance = thread + 0.5;  // Add 0.5 mm for slop
d = d_nominal + d_clearance; // Diameter for the base cylinder
pitch = 0.25 * 25.4;  // Thread pitch
thread_length = 16;   // Length of threaded section
thickness = 1;        // Wall thickness 
rounding = 3;         // Bevel radius 
slot = true;         // True to add a slot for a money jar

difference() {
    difference() {
        minkowski() 
        {
            sphere(r = rounding, $fa=5, $fs=2);
            translate([0, 0, rounding])
                // The default faceting works nicely for making the lid easy to grip
                cylinder(r = d * 0.5 + thickness, h = thread_length + thickness - 2* rounding);
        }
        round_threads(diam = d, thread_diam = thread, pitch = pitch, thread_length = thread_length, groove = true, num_starts = 1);
    }
    if (slot == true) {
        make_slot();
    }
}

// Sufficiently large for a 25¢ piece
module make_slot(width = 3, length = 28) {
    height = 200;
    hull() {
        translate([-0.5*length, 0, 0])
            cylinder(r = 0.5*width, h = height, $fa=5, $fs=2);
        translate([ 0.5*length, 0, 0])
            cylinder(r = 0.5*width, h = height, $fa=5, $fs=2);
    }
}


module round_threads(diam = 75, thread_diam = 2, pitch = 8, thread_length = 16, groove = false, num_starts = 1) {

if (groove == false) { 
    union() {
        cylinder(r = 0.5*diam, h = thread_length, $fa = 5, $fs = 2 );
        helix(diam = diam, thread_diam = thread_diam, pitch = pitch, thread_length = thread_length, num_starts = num_starts);   
    }
} else {
    difference() {
        cylinder(r = 0.5*diam, h = thread_length, $fa = 5, $fs = 2);
        helix(diam = diam, thread_diam = thread_diam, pitch = pitch, thread_length = thread_length, num_starts = num_starts);   
    }
} 

// Create the helical thread by combining multiple stubby cylinders
module helix(diam, thread_diam , pitch, thread_length, num_starts) {   
    ramp_angle = atan(pitch/(PI*diam));
    total_angle = 360 * thread_length / pitch;
    cylinder_height = thread_diam * 0.5;
    ncyls = total_angle / 360 * PI * diam / cylinder_height * 1.2;
    intersection() {
        cylinder(r = diam, h = thread_length, $fa = 5, $fs = 2); 
        steps_overshoot = floor(0.125*(ncyls/cylinder_height*pitch)); 
        
        union() {
            for (j = [1:num_starts]) { 
                angle_offset = 360 / num_starts * j;
                for (i = [1-steps_overshoot:ncyls+steps_overshoot]) {
                    angle = (total_angle) * (i - 1) / (ncyls-1) + angle_offset ;
                    x = diam/2 * cos(angle);
                    y = diam/2 * sin(angle);
                    z = thread_length * (i - 1) / (ncyls-1);
                
                    translate([x, y, z]) {                       
                        rotate([90, 0, 0]) { 
                            rotate([ramp_angle, angle, 0]) 
                                cylinder(r = 0.5*thread_diam, h = cylinder_height, center=true, $fa=12, $fs = 2);
                        }
                    }
                }
            }
        }
    }
}

}
        
