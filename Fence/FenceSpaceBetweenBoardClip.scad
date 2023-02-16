include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

ClipParams = 
[
    "Clip Params",
    ["x", convert_in2mm(1)],
    ["y", convert_in2mm(1)],
    ["z", convert_in2mm(1)],    
];

thickness = convert_in2mm(0.2);
length = convert_in2mm(1);
height = convert_in2mm(1);

HParams =
[
    "H - clip params",
    ["pt1", [0,0]],
    ["pt2", [0,convert_in2mm(1.5)]],
    ["pt3", [convert_in2mm(0.2),convert_in2mm(1.5)]],
    ["pt4", [0,convert_in2mm(1)]],
];

$fn = 100;


build();

module build(args) 
{
    difference() 
    {
        Hclip();
        label("1.0");        
    }

    echo("Save as 'Fence Spacer 1 inch'");
}

module Hclip()
{
    drawCube(ClipParams);
    points = [[0,0], [length,0], [length,length], [length-thickness, length], [length-thickness,thickness], [length-thickness, thickness], [thickness, thickness], [thickness, length], [0, length]];
    translate([0, length-thickness, 0 ])
    linear_extrude(height)
    polygon(points=points);

    translate([length, thickness, 0 ])
    rotate([0,0,180])
    linear_extrude(height)
    polygon(points=points);
}

module label(text)
{
    translate([length/6, length/3, length-3])
    // color("blue", 0.5)
    linear_extrude(4)
    text(text);

    translate([length-3, length/3, 3])
    rotate([0,180,0])
    // color("blue", 0.5)
    linear_extrude(4)
    text(text);
}