/*
    copywrite 2/1/2021 Steven H. Mitchell
    planter caddy 
    to modify the anchor, modify corrisponding dictionary value below.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <../libraries/kvpairs.scad>;
// use <../frenchwall/ToolHolders_Modules_Library.scad>;
$fn = 100;


CaddyPegInfoStore = 
[
        ["description", "information for planter caddy peg"],
        ["radius", convert_in2mm(0.25)],
        ["scale", [2, 4]],
        ["filename", "Planter caddy peg.stl"],
        ["height", convert_in2mm(0.75)],
        ["move", [0, 0, 0] ],  
        ["rotate", [180, 0, 0]],
        ["color", "Aqua"],
        ["location", [0, 0, 0] ],  
        ["rotate", [180, 0, 0]],
        ["color", "Aqua"], 
];

screw_hole =
[
    ["description", "#8 GRK cabinet screw"],
    ["diameter", 2.94],
    ["length", kv_get(CaddyPegInfoStore, "height") ],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "Red"]
];

    Draw(CaddyPegInfoStore);


module Draw(properties)
{
    echo();
    echo(Filename = str(convert_mm2in(kv_get(properties, "height")), " inch ", kv_get(properties, ("filename"))));
    echo();

    rotate(kv_get(properties, "rotate"))
    difference()
    {
        Draw_CaddyPeg(properties);
        
        make_screw_hole(screw_hole);
    }

}

module Draw_CaddyPeg(properties = CaddyPegInfoStore)
{
    properties_echo(properties);
    linear_extrude(
        height = kv_get(properties, "height"), 
        center = false, 
        convexity = 10, 
        scale=kv_get(properties, "scale"), 
        $fn=100)
    circle(r = kv_get(properties, "radius"));
}



module make_screw_hole(properties)
{
    properties_echo(properties);
    translate(kv_get(screw_hole, "move"))

    // translate([0, 0, - kv_get(properties, "length") / 2]) 
    linear_extrude(kv_get(properties, "length"))
    circle(d=kv_get(properties, "diameter"));
}
