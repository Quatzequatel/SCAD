/*
    
*/

include <constants.scad>;
// use <ToolHolders_Modules_Library.scad>;
use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build(args) 
{
    draw_Gazebo();
}

function octagon_radius_from_side_length(s) = s * sqrt( 1 + (1/sqrt(2)));

module draw_Gazebo()
{
        gazebo = 
        [ "gazebo",
            ["x", convert_in2mm(8 * 12)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(1)],
            ["radius", octagon_radius_from_side_length( convert_ft2mm(8))],
            ["fragments", 8],
            ["move", [0, 0, 0]],
            ["rotate", [ 0, 0, 0] ],
            ["color", "LightSlateGray"]
        ];

    properties_echo(gazebo);

    applyColor(gazebo)
    applyExtrude(gazebo)
    drawCircleShape(gazebo);

    for (i=[0:8]) 
    {
        rotate([0, 0, i * 45])
        translate([gdv(gazebo, "radius")/4, 0, 0])
        rotate([0, 0, 90])
        draw2by4(gdv(gazebo, "radius")/2);   
    }

    // // translate([gdv(gazebo, "radius")/2, 0, 0])
    // rotate([0, 0, 67.5 * 1])
    // // translate([gdv(gazebo, "radius")/4, 0, 0])
    // // rotate([0, 0, 90])
    // #draw2by4(gdv(gazebo, "radius")/2);

}


module drawCircleShape(properties)
{
    circle(d=gdv(properties, "radius"), $fn = gdv(properties, "fragments"));
}

module draw2by4(length)
{
    linear_extrude(convert_in2mm(3.5))
    square(size=[convert_in2mm(1.75), length], center=true);
}