/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

include <GreenHouseProperties.scad>;
use <transformations.scad>;

// Fence_Properties = 
// [
//     "fence properties",
//         ["width", convert_ft2mm(103.24)],
//         ["length", convert_in2mm(4)],
//         ["height", convert_in2mm(72)],
//         ["easement", -1 * convert_ft2mm(12)],
// ];

// build_Fence();

cut_board(angle = 42, width = 2, depth = 6, length = 8 * 12);

module build_Fence(args) 
{
    draw_Fence(fence_properties = Fence_Properties);
}

module draw_Fence(fence_properties)
{
    move_to_fence_line(fence_properties = fence_properties)
    color("SpringGreen")
    linear_extrude(height = getDictionaryValue(fence_properties, "height"))
    square
    (
        [
            getDictionaryValue(fence_properties, "width"), 
            getDictionaryValue(fence_properties, "length")
        ], 
        center = true
    ); 

    fence_properties_info();
}


module fence_properties_info()
{
    echo();
    debugEcho("Fence_Properties", Fence_Properties, true);
    echo();
}

module cut_board(angle, width, depth, length)
{
    points = trapazoid(angle, depth, length);

    linear_extrude(height = width)
    polygon(points=points);
    
}

function side_b(angle, depth) = depth/tan(angle);
function trap_top(angle, depth, length) = length -  side_b(angle, depth);
function trapazoid(angle, depth, length) = 
    [
        [0,0], 
        [side_b(angle, depth), depth], 
        [trap_top(angle, depth, length), depth], 
        [length, 0]
    ];