include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;
// 
//Data Objects
//
BoardDimensions = 
[
    "2x2 board",
    ["x", convert_in2mm(1.55)],
    ["y", convert_in2mm(1.55)],
    ["z", convert_in2mm(96)],    
];

TemplateDimensions = 
[
    "Template outer dimensions",
    ["x", gdv(BoardDimensions, "x") + 2 * WallThickness(6)],
    ["y", gdv(BoardDimensions, "y") + 2 * WallThickness(6)],
    ["z", convert_in2mm(0.75)],   
    ["bottom thickness", LayersToHeight(10)] 
];

CenterHole = 
[
    "template center hole",
    ["radius", convert_in2mm(3/8)/2],
    ["height", gdv(TemplateDimensions, "z")],
];

build();

module build(args) 
{

    difference() 
    {
        this_drawCube(TemplateDimensions, true);
        
        translate([0,0, gdv(TemplateDimensions, "bottom thickness")])
        this_drawCube(BoardDimensions, true);
        
        translate([0,0, -gdv(TemplateDimensions, "bottom thickness")])
        cylinder(r=gdv(CenterHole, "radius"), h=gdv(CenterHole, "height"), center=true);
    }
    
}

module this_drawCube(properties, middle)
{
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=middle);    
}