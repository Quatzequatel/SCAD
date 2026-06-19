/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

// import("C:\\Users\\quatz\\xDrive\\SCAD\\SCAD\\Deck\\Deko-Haken-Bracket\\Deko-Haken-Deko-Haken-Lang.stl");

// === GENERATE C-CURVE POINTS ===
function c_curve_points(radius, num_points) = [
    for(i = [0:num_points-1])
    let(angle = (i / (num_points - 1)) * 180)
    [radius * cos(angle), radius * sin(angle)]
];

// === GENERATE S-CURVE POINTS (2D PROFILE) ===
// function s_curve_points(radius, num_points) = 
//     concat(
//         [for(i = [0:num_points-1])
//             let(angle = (i / (num_points - 1)) * 180)
//             [radius * (1 - cos(angle)), radius * sin(angle)]
//         ],
//         [for(i = [num_points-1:-1:0])
//             let(angle = (i / (num_points - 1)) * 180)
//             [radius * (1 - cos(angle)), -radius * sin(angle)]
//         ]
//     );
function s_curve_points(radius, num_points) = 
    concat(
        [for(i = [0:num_points-1])
            let(angle = (i / (num_points - 1)) * 180)
            [-radius * (1 - cos(angle)), radius * sin(angle)]
        ],
        [for(i = [0:num_points-1])
            let(angle = (i / (num_points - 1)) * 180)
            [radius * (1 - cos(angle)), -radius * sin(angle)]
        ]
        // [for(i = [num_points-1:-1:0])
        //     let(angle = (i / (num_points - 1)) * 180)
        //     [2 * radius + radius * (1 - cos(angle)), -radius * sin(angle)]
        // ]
    );


// === GENERATE CIRCULAR PROFILE POINTS ===
function circle_profile(radius, segments) = [
    for(i = [0:segments-1])
    let(angle = (i / segments) * 360)
    [radius * cos(angle), radius * sin(angle)]
];

// === ORNAMENTAL S-SCROLL (Using Polygon + Linear Extrude) ===
module ornamental_s_scroll(radius, thickness, scroll_id) 
{   
    num_curve_points = 5;
    
    // Get the S-curve path
    curve_path = s_curve_points(radius, num_curve_points);
    echo(str("Curve Path for Scroll ", scroll_id, ": ", curve_path));
    
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
        hull() 
            {
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
}

module Test(radius = 20, thickness = 3) 
{
    num_curve_points = 5;
    
    // Get the S-curve path
    curve_path = s_curve_points(radius, num_curve_points);
    echo(str("Curve Path for Scroll ", scroll_id, ": ", curve_path));    
    polygon(points=curve_path);
}
        
ornamental_s_scroll(radius = 20, thickness = 3, scroll_id = 1);
// Test();