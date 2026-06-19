// Victorian Ornamental Shelf Bracket
// Functional shelf bracket with flowing plant-like curves for strength and elegance

// === PARAMETERS ===
shelf_width = 200;        // Width of the shelf surface
shelf_depth = 150;        // Depth of the shelf (front to back)
shelf_thickness = 12;     // Thickness of shelf material

// Support structure
support_height = 150;     // Height from wall to shelf bottom
vertical_arm_width = 20;  // Width of main vertical support
vertical_arm_thickness = 10; // Thickness of vertical support

// Wall mounting
wall_mount_width = 100;   // Width of wall mounting plate
wall_mount_height = 180;  // Height of wall mounting plate
wall_mount_thickness = 8;

// Ornamental supports (the flowing plant-like curves)
support_curve_thickness = 12;  // Thickness of ornamental curves
curve_amplitude = 40;     // How far the curves extend outward
num_curves = 3;           // Number of flowing support curves

// Mounting hardware
bolt_hole_diameter = 10;
bolt_hole_spacing = 60;

// === MAIN ASSEMBLY ===
module victorian_shelf_bracket() {
    union() {
        // Wall mounting plate
        wall_mounting_plate();
        
        // Main vertical support structure
        vertical_support();
        
        // Shelf surface
        shelf_surface();
        
        // Ornamental flowing plant-like curves (structural & decorative)
        ornamental_supports();
        
        // Connection reinforcement at curves
        reinforcement_nodes();
    }
}

// === WALL MOUNTING PLATE ===
module wall_mounting_plate() {
    difference() {
        union() {
            // Main plate
            cube([wall_mount_width, wall_mount_thickness, wall_mount_height]);
            
            // Decorative border frame
            translate([2, 0, 2]) {
                linear_extrude(wall_mount_height - 4) {
                    square([wall_mount_width - 4, wall_mount_thickness], center=false);
                }
            }
        }
        
        // Mounting bolt holes (vertical array)
        hole_y_positions = [30, 90, 150];
        for(y_pos = hole_y_positions) {
            translate([wall_mount_width/2, -1, y_pos])
                cylinder(h=wall_mount_thickness+2, r=bolt_hole_diameter/2, $fn=32);
        }
        
        // Decorative perforations
        for(y = [40:40:wall_mount_height-40]) {
            translate([wall_mount_width*0.25, -1, y])
                cylinder(h=wall_mount_thickness+2, r=4, $fn=24);
            translate([wall_mount_width*0.75, -1, y])
                cylinder(h=wall_mount_thickness+2, r=4, $fn=24);
        }
    }
}

// === MAIN VERTICAL SUPPORT BEAM ===
module vertical_support() {
    // Main vertical structural beam running from wall down
    translate([wall_mount_width/2 - vertical_arm_width/2, wall_mount_thickness, 0]) {
        cube([vertical_arm_width, vertical_arm_thickness, support_height]);
    }
    
    // Vertical reinforcement ribs (for strength)
    for(rib = [0:25:vertical_arm_width]) {
        translate([wall_mount_width/2 - vertical_arm_width/2 + rib, wall_mount_thickness, 0])
            cube([2, vertical_arm_thickness, support_height]);
    }
}

// === SHELF SURFACE ===
module shelf_surface() {
    // Main shelf top surface
    translate([wall_mount_width/2 - shelf_width/2, wall_mount_thickness + vertical_arm_thickness, support_height]) {
        cube([shelf_width, shelf_depth, shelf_thickness]);
    }
    
    // Shelf edge trim (decorative but structural)
    translate([wall_mount_width/2 - shelf_width/2 - 3, wall_mount_thickness + vertical_arm_thickness, support_height]) {
        cube([3, shelf_depth, shelf_thickness + 5]); // Left edge
    }
    translate([wall_mount_width/2 + shelf_width/2, wall_mount_thickness + vertical_arm_thickness, support_height]) {
        cube([3, shelf_depth, shelf_thickness + 5]); // Right edge
    }
}

// === ORNAMENTAL FLOWING PLANT-LIKE CURVES (Structural Support) ===
module ornamental_supports() {
    // Create flowing curves that connect from wall mount to shelf
    
    for(curve_index = [0:num_curves-1]) {
        // Distribute curves across the shelf width
        curve_x_pos = (shelf_width / (num_curves + 1)) * (curve_index + 1);
        curve_x_global = wall_mount_width/2 - shelf_width/2 + curve_x_pos;
        
        // Create flowing plant-like curve
        flowing_plant_curve(
            curve_x_global,
            wall_mount_thickness + vertical_arm_thickness/2,
            curve_index,
            support_height
        );
    }
}

// === FLOWING PLANT-LIKE CURVE (Single Ornamental Support) ===
module flowing_plant_curve(start_x, start_y, curve_id, total_height) {
    // Creates an elegant flowing curve that spirals outward and down
    // Provides structural support while looking like a plant stem or vine
    
    num_segments = 30;
    base_thickness = support_curve_thickness;
    
    union() {
        // Main flowing curve traced with spheres (creates tubular vine effect)
        for(step = [0:num_segments]) {
            t = step / num_segments; // Parameter from 0 to 1
            
            // Parametric curve: spiraling outward as it descends
            angle = t * 180 * (1 + curve_id * 0.3); // Spiral rotation
            height_drop = total_height * (1 - t); // Descends to shelf
            outward_push = curve_amplitude * sin(t * 180); // Extends outward
            
            x_pos = start_x + outward_push * cos(angle);
            y_pos = start_y + outward_push * sin(angle);
            z_pos = height_drop;
            
            // Taper thickness (thicker at base, thinner at ends)
            thickness = base_thickness * (0.7 + 0.3 * (1 - abs(t - 0.5) * 2));
            
            translate([x_pos, y_pos, z_pos])
                sphere(r=thickness, $fn=20);
        }
        
        // Secondary leaf-like protrusions (2-3 per curve for plant appearance)
        for(leaf = [0:1]) {
            leaf_t = 0.3 + leaf * 0.4; // Position along the curve
            
            angle = leaf_t * 180 * (1 + curve_id * 0.3);
            height_drop = total_height * (1 - leaf_t);
            outward_push = curve_amplitude * sin(leaf_t * 180);
            
            x_base = start_x + outward_push * cos(angle);
            y_base = start_y + outward_push * sin(angle);
            z_base = height_drop;
            
            // Leaf extends perpendicular to main curve
            translate([x_base, y_base, z_base])
                leaf_flourish(support_curve_thickness * 0.6, leaf);
        }
    }
}

// === DECORATIVE LEAF FLOURISH ===
module leaf_flourish(size, leaf_id) {
    // Creates organic leaf-like protrusions along the curves
    
    union() {
        // Central vein
        for(i = [0:8]) {
            t = i / 8;
            translate([
                size * sin(t * 180) * 1.5,
                size * cos(t * 180),
                size * sin(leaf_id * 45) * 0.5
            ])
                sphere(r=size*0.3, $fn=16);
        }
    }
}

// === REINFORCEMENT NODES ===
module reinforcement_nodes() {
    // Strengthen the connection points where curves meet the shelf
    
    for(curve_index = [0:num_curves-1]) {
        curve_x_pos = (shelf_width / (num_curves + 1)) * (curve_index + 1);
        curve_x_global = wall_mount_width/2 - shelf_width/2 + curve_x_pos;
        
        // Reinforcement knot at shelf connection point
        translate([curve_x_global, wall_mount_thickness + vertical_arm_thickness, support_height]) {
            sphere(r=support_curve_thickness*1.2, $fn=28);
        }
    }
}

// === RENDER COMPLETE BRACKET ===
victorian_shelf_bracket();

// Reference plane (wall surface)
%translate([-50, -50, 0]) cube([300, 1, 300]);
