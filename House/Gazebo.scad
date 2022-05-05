/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build(args) 
{
    draw_Gazebo();
}

module draw_Gazebo()
{
        gazebo = 
        [ "gazebo",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["fragments", 8],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];
}