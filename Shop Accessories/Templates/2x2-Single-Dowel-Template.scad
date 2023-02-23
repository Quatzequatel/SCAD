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
    ["x", 38.9], //convert_in2mm(1.55) => 39.37 was too big.
    ["y", 38.9], //38.5 is tight to too small.
    ["z", convert_in2mm(96)],    
];

TemplateDimensions = 
[
    "Template outer dimensions",
    ["x", gdv(BoardDimensions, "x") + 2 * WallThickness(6)],
    ["y", gdv(BoardDimensions, "y") + 2 * WallThickness(6)],
    ["z", convert_in2mm(0.75)],   
    ["bottom thickness", LayersToHeight(15)] 
];

CenterHole = 
[
    "template center hole",
    ["diameter", 9.25],  //7.93
    ["height", gdv(TemplateDimensions, "z")],
];
echo(gdv(CenterHole, "diameter"));
echo(convert_in2mm(1.55));
echo(convert_in2mm(3/8));

build();

module build(args) 
{

    difference() 
    {
        this_drawCube(TemplateDimensions, true);
        
        translate([0,0, gdv(TemplateDimensions, "bottom thickness")])
        this_drawCube(BoardDimensions, true);
        
        translate([0,0, -gdv(TemplateDimensions, "bottom thickness")])
        cylinder(d=gdv(CenterHole, "diameter"), h=gdv(CenterHole, "height"), center=true);
    }
    
}

module this_drawCube(properties, middle)
{
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=middle);    
}