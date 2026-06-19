// Victorian Ornamental Shelf Bracket - Production Design
// Based on classic wrought iron with hanging S-scroll ornaments

// === MAIN PARAMETERS ===
shelf_arm_length = 250;    // Horizontal arm length
shelf_arm_width = 35;      // Width of main support arm
shelf_arm_thickness = 15;  // Thickness (depth) of main arm

// Wall mounting
wall_plate_width = 90;
wall_plate_height = 160;
wall_plate_thickness = 8;

// Scroll ornaments
num_scrolls = 1;           // Number of hanging scrolls
scroll_base_radius = 25;   // Radius of largest scroll
scroll_thickness = 14;     // Thickness of scroll tubing
scroll_depth = 80;         // How far scrolls extend downward

// Decorative banding
band_thickness = 6;        // Thickness of wrapping bands
band_width = 28;           // Width of bands
num_bands = 6;             // Flutes/ridges per band

// Mounting
bolt_hole_diameter = 9;

// === MAIN ASSEMBLY ===
module victorian_shelf_bracket() {
    union() {
        // 1. Wall mounting plate
        // wall_plate();
        
        // 2. Main horizontal shelf arm
        // shelf_arm();
        
        // 3. Connection reinforcement at wall
        // arm_wall_connection();
        
        // 4. Ornamental hanging scrolls
        hanging_scrolls();
    }
}

// === WALL MOUNTING PLATE ===
module wall_plate() {
    difference() {
        // Main plate
        cube([wall_plate_width, wall_plate_thickness, wall_plate_height]);
        
        // Bolt holes (3 hole vertical array)
        for(hole_y = [25, 80, 135]) {
            translate([wall_plate_width/2, -1, hole_y])
                cylinder(h=wall_plate_thickness+2, r=bolt_hole_diameter/2, $fn=32);
        }
        
        // Decorative perforations along plate
        for(y_pos = [40:40:wall_plate_height-40]) {
            translate([wall_plate_width*0.2, -1, y_pos])
                cylinder(h=wall_plate_thickness+2, r=3.5, $fn=24);
            translate([wall_plate_width*0.8, -1, y_pos])
                cylinder(h=wall_plate_thickness+2, r=3.5, $fn=24);
        }
    }
}

// === MAIN SHELF ARM ===
module shelf_arm() {
    // Tapered main arm (thicker near wall, tapers toward end)
    translate([wall_plate_width, wall_plate_thickness/2, wall_plate_height*0.5]) {
        hull() {
            // Base at wall (thicker)
            cube([5, shelf_arm_thickness, shelf_arm_width], center=true);
            
            // Tapered end
            translate([shelf_arm_length - 5, 0, 0])
                cube([5, shelf_arm_thickness * 0.7, shelf_arm_width * 0.8], center=true);
        }
    }
    
    // Fluted/ridged details along arm for visual interest
    for(ridge_pos = [20:35:shelf_arm_length-20]) {
        translate([wall_plate_width + ridge_pos, wall_plate_thickness/2 - shelf_arm_thickness/2, wall_plate_height*0.5 - shelf_arm_width/2]) {
            cube([2, shelf_arm_thickness/2, shelf_arm_width + 8]);
        }
    }
}

// === ARM-TO-WALL CONNECTION REINFORCEMENT ===
module arm_wall_connection() {
    // Reinforcement where arm meets wall plate
    translate([wall_plate_width - 8, wall_plate_thickness/2, wall_plate_height*0.5]) {
        cube([8, shelf_arm_thickness + 4, shelf_arm_width + 6], center=true);
    }
}

// === HANGING ORNAMENTAL SCROLLS ===
module hanging_scrolls() {
    // Distribute scrolls along the length of the arm
    for(scroll_index = [0:num_scrolls-1]) {
        // Position along arm
        t = (scroll_index + 1) / (num_scrolls + 1); // Distribute evenly
        scroll_x = wall_plate_width + t * shelf_arm_length;
        
        // Scale: slightly smaller as we move away from wall
        scale_factor = 0.7 + 0.3 * (1 - t);
        
        // Position below the arm
        translate([scroll_x, wall_plate_thickness/2 + shelf_arm_thickness + 10, wall_plate_height*0.5]) {
            // Decorative band at connection point
            connection_band(scale_factor);
            
            // Hanging scroll ornament
            ornamental_s_scroll(
                scroll_base_radius * scale_factor,
                scroll_thickness * scale_factor * 0.8,
                scroll_index
            );
        }
    }
}

// === CONNECTION BAND (Decorative Wrapping at Scroll) ===
module connection_band(scale) {
    size = band_width * scale;
    thick = band_thickness;
    
    difference() {
        // Main band ring
        cylinder(h=thick, r=size/2 + 3, $fn=32, center=true);
        
        // Inner hole
        cylinder(h=thick+2, r=size/2 - 3, $fn=32, center=true);
        
        // Fluted ridges on top
        for(ridge = [0:num_bands-1]) {
            angle = (ridge / num_bands) * 360;
            rotate([0, 0, angle]) {
                translate([size/2 - 2, -1.5, 0])
                    cube([4, 3, thick+2], center=true);
            }
        }
    }
}

// === GENERATE C-CURVE POINTS ===
function c_curve_points(radius, num_points) = [
    for(i = [0:num_points-1])
    let(angle = (i / (num_points - 1)) * 180)
    [radius * cos(angle), radius * sin(angle)]
];

// === GENERATE S-CURVE POINTS (2D PROFILE) ===
function s_curve_points(radius, num_points) = 
    concat(
        [for(i = [0:num_points-1])
            let(angle = (i / (num_points - 1)) * 180)
            [radius * (1 - cos(angle)), radius * sin(angle)]
        ],
        [for(i = [num_points-1:-1:0])
            let(angle = (i / (num_points - 1)) * 180)
            [radius * (1 - cos(angle)), -radius * sin(angle)]
        ]
    );

// === ORNAMENTAL S-SCROLL (Using Polygon + Linear Extrude) ===
module ornamental_s_scroll(radius, thickness, scroll_id) {
    num_curve_points = 20;
    
    // Get the S-curve path
    curve_path = s_curve_points(radius, num_curve_points);
    
    // Create 2D cross-section profile (tubing shape)
    profile_radius = thickness / 2;
    profile_points = circle_profile(profile_radius, 12);
    
    // Create the scroll by placing hulled profiles along the curve
    for(i = [0:len(curve_path)-2]) {
        p1 = curve_path[i];
        p2 = curve_path[i+1];
        
        // Calculate rotation angle between points
        angle = atan2(p2[1] - p1[1], p2[0] - p1[0]);
        
        // Hull between rotated profiles
        hull() {
            translate([p1[0], p1[1], 0])
                rotate([0, 0, angle])
                    linear_extrude(height=1, center=true)
                        polygon(profile_points);
            
            translate([p2[0], p2[1], 0])
                rotate([0, 0, angle])
                    linear_extrude(height=1, center=true)
                        polygon(profile_points);
        }
    }
    
    // Add ornamental bulbs at curve endpoints
    // translate([curve_path[0][0], curve_path[0][1], 0])
    //     sphere(r=thickness*1.3, $fn=20);
    
    // translate([curve_path[len(curve_path)-1][0], curve_path[len(curve_path)-1][1], 0])
    //     sphere(r=thickness*1.1, $fn=20);
}

// === GENERATE CIRCULAR PROFILE POINTS ===
function circle_profile(radius, segments) = [
    for(i = [0:segments-1])
    let(angle = (i / segments) * 360)
    [radius * cos(angle), radius * sin(angle)]
];

// === RENDER COMPLETE BRACKET ===
victorian_shelf_bracket();

// === REFERENCE PLANES (for visualization, use % to hide) ===
// Wall surface
// %translate([-20, -10, 0]) cube([30, 1, 200]);

// Shelf surface reference
// %translate([wall_plate_width - 20, wall_plate_thickness + shelf_arm_thickness + 5, wall_plate_height*0.5 - shelf_arm_width/2]) 
//     cube([shelf_arm_length + 40, 1, shelf_arm_width + 20]);
