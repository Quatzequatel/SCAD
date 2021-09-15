/*
    This still needs some tweaks, the inserts are slightly too big.
    about 1mm off. the spacing is more off.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <morphology.scad>;

wall_line_count = 6;

properties = 
[
    "",
    ["width", 22.25],    //x
    ["depth", 22.25],      //y
    ["height", convert_in2mm(0.75)],   //z 
    ["wall", WallThickness(wall_line_count)],
    ["Pryamid height", convert_in2mm(1.5)],
    ["orientation", [0,0,0]]
];

function f_tube_width() = gdv(properties, "width") + 2 * gdv(properties, "wall");
function f_offset(x = 1) = x * (gdv(properties, "width") /2 + f_tube_width()/2);
function f_pyramid_width() = 3 * gdv(properties, "width") + 2 * gdv(properties, "wall");

build();

module build(args) 
{
    properties_echo(properties);
    echo(str("f_pyramid_width = ", f_pyramid_width()));
    echo();

    difference()
    {
        union()
        {
            Pryamid();

            translate([0, 0, -gdv(properties, "height")])
            rows();      
        }        

        translate([0, 0, -50])
        linear_extrude(100)
        square(size=[gdv(properties, "width"), gdv(properties, "depth")], center=true);        
    }      
}

module rows()
{
    //row 1
    translate([0, f_offset(), 0])
    row();

    //row 2
    // translate([0, 0, 0])
    // row();
    //row 3
    translate([0, f_offset(-1), 0])
    row();      
}

module row()
{
    // Thing();

    translate([f_offset() ,0,0])
    Thing();
    // echo(value1 = f_offset(1), value2 = f_offset(-1))

    translate([f_offset(-1) ,0,0])
    Thing();
}

module Thing()
{
    linear_extrude(gdv(properties, "height"))
    // shell(d=gdv(properties, "wall"), center = true)
    square(size=[gdv(properties, "width"), gdv(properties, "depth")], center=true);
}

module Pryamid()
{
    linear_extrude(height = gdv(properties, "Pryamid height"), scale = gdv(properties, "width")/f_pyramid_width()) square(f_pyramid_width(), center = true);
}