include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;



wallCount = 15;
wall = WallThickness(15);
board_height = 101.9;
thickness = 15;
spaceing = convert_in2mm(1);
full_length = (2 * wall) + (2 * board_height) + spaceing;
template_width = convert_in2mm(0.5);

build();

module build() 
{
    echo("save model as 'top_2_bottom_fence_guide'");
    points=[
            [0,0], 
            [full_length , 0], 
            [full_length, wall + thickness],
            [full_length - wall, wall + thickness],
            [full_length - wall, wall],
            [full_length - wall - board_height, wall],
            [full_length - wall - board_height, wall + thickness],
            [full_length - wall - board_height - spaceing, wall + thickness],
            [full_length - wall - board_height - spaceing, wall ],
            [full_length - wall - ( 2 * board_height) - spaceing, wall ],
            [full_length - wall - ( 2 * board_height) - spaceing, wall + thickness ],
            [0 , wall + thickness],
            ];

    translate([full_length/2, (wall + thickness)/2, 0])
    linear_extrude(template_width)
    polygon(points=points);
}

module boringWay() 
{
    rotate([0,-90,0])
    difference()
    {
        linear_extrude(convert_in2mm(9) + (2 * WallThickness(wallCount)))
            square(size=[convert_in2mm(1), convert_in2mm(1.2)], center=false);

        translate([-2, WallThickness(wallCount),  WallThickness(wallCount)])
        #linear_extrude(convert_in2mm(9))
            square(size=[convert_in2mm(1.25), convert_in2mm(1)], center=false);
    }
}