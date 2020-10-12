/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <morphology.scad>;
use <Roof.scad>;
$fn = 100;

build();

module build(args) 
{
    // rotate([180,0,0])
    // rafter_template(Main_Rafter_template);
    rafter_template(Brace_One_template);
    // rafter_template(Brace_Two_template);
    // rafter_template(Entry_Rafter_template);

    // add_Block_jBolt_template(Block_jBolt_template);
    // add_center_beam_spacer(Center_beam_spacer);

    // // pts = trapazoid(42, 42, 50, 30, 200);

    // // translate([-151.0052/2, -50.9878/2])
    // color("red", 0.5)
    // minkowski()     
    // {
    //     // linear_extrude(10)
    //     polygon(pts);
    //     circle(r=2);        
    // }


    // echo(pts = pts);
}

module add_center_beam_spacer(properties) 
{
    scale(size = 9, increment = convert_in2mm(1), fontsize = 6);
    properties_echo(properties);

    points = 
    [
        gdv(properties, "p1"),
        gdv(properties, "p2"),
        gdv(properties, "p3"),
        gdv(properties, "p4"),
    ];

    rotate([90,0,0])
    difference()
    {
        union()
        {
            linear_extrude(height=gdv(properties, "brace width"), center=true) 
            shell(d = gdv(properties, "spacer thickness"),center=true)
            polygon(points);

            //brace 
            translate([0, 0, 16])
            linear_extrude(height = gdv(properties, "spacer thickness"), center=true) 
            polygon(points);  

            //brace 
            translate([0, 0, -16])
            linear_extrude(height = gdv(properties, "spacer thickness"), center=true) 
            polygon(points);              
        }

        //void for beam
        translate([0, points[1].y - gdv(properties, "beam depth")/2 + gdv(properties, "spacer thickness"), 0])
        color("yellow", 0.5) 
        linear_extrude(height=gdv(properties, "brace width"), center=true, convexity=10, twist=0) 
        square([gdv(properties, "beam width"), gdv(properties, "beam depth")], center = true);

        //screw holes
        add_screw_holes(screw_hole_properties);
        
        mirror([1, 0, 0]) 
            add_screw_holes(screw_hole_properties);
        
        
        // %color("grey", 0.5)
        // translate([-45, 10, 0])
        // rotate([90, 0, 48])         
        // cylinder(d = woodScrewShankDiaN_8, h=50, center=true);
    }
}

module add_screw_holes(properties, count = 1, space = -45)
{
    for (i=[0:count]) 
    {
        add_screw_hole(properties, addspace = i * space);
    }
    
}

module add_screw_hole(properties, addspace = -20)
{
    //shank
    color(gdv(properties, "shank color"), 0.5)
    translate(Add2X(gdv(properties, "shank move"), addspace))
    rotate(gdv(properties, "shank rotate"))         
    cylinder(d = gdv(properties, "shank diameter"), h=gdv(properties, "shank length"), center=true);    
    
    //head
    color(gdv(properties, "head color"), 0.5)
    translate(Add2X(gdv(properties, "head move"), addspace) )
    rotate(gdv(properties, "head rotate"))         
    cylinder(d = gdv(properties, "head diameter"), h=gdv(properties, "head length"), center=true);  
}

module add_Block_jBolt_template(properties)
{
    scale(size = 9, increment = convert_in2mm(1), fontsize = 6);

    rotate([90, 0, 0])
    union()
    {
        difference()
        {
            linear_extrude(gdv(properties, "template thickness"))
            square([gdv(properties, "block width"), gdv(properties, "template width")]);

            translate([gdv(properties, "block width")/2, gdv(properties, "template width")/2, -2])
            linear_extrude(2 * gdv(properties, "template thickness"))
            // circle(gdv(properties, "template thickness"), $fn=100);        
            circle(d = convert_in2mm(5/8), $fn=100);    
        }        



        color("yellow", 0.5)
        translate([ gdv(properties, "block width") + gdv(properties, "template tab thickness"), 0, 0])
        rotate([0,0, 90])
        linear_extrude(gdv(properties, "template tab depth"))
        square([gdv(properties, "template width"), gdv(properties, "template tab thickness")]);

        color("aqua", 0.5)
        rotate([0,0, 90])
        // translate([gdv(properties, "block width"), 0, 0])
        linear_extrude(gdv(properties, "template tab depth"))
        square([gdv(properties, "template width"), gdv(properties, "template tab thickness")]);        
    }

}

module rafter_template(properties)
{
    points = brace_board_points
                (
                    angle = gdv(properties, "angle"),
                    angle2 = gdv(properties, "angle2"),
                    depth = gdv(properties, "depth"),
                    length = gdv(properties, "length")                    
                );

    echo(points = points);
    difference()
    {
        translate([0, 0, gdv(properties, "tool thickness")/2])
        brace_board_cut
        (
            angle = gdv(properties, "angle"),
            angle2 = gdv(properties, "angle2"),
            width = gdv(properties, "tool thickness"),
            depth = gdv(properties, "depth"),
            length = gdv(properties, "length")
        );

        cut_text(gdv(properties, "lable text"), properties, convert_in2mm(1), points[1].y/2);

        cut_text(str(gdv(properties, "angle"), "°"), properties, points.x.x + 25, 2);

        cut_text(str(90 - gdv(properties, "angle"), "°"), properties, points[2].x - 20, points[2].y - 10);

        cut_text(str(gdv(properties, "angle2"), "°"), properties, points[3].x - 40, 2);

    }

    // lable_angle(a = gdv(properties, "angle"), l = 20, r = 0.5, size = 2, color = "blue", show_labels = true);
    // text(text = str(gdv(properties, "angle"), "°"), size = 10);

    if(gdv(properties, "left handed"))
    {
        translate([0, 0, - 2 * gdv(properties, "tool thickness")])    
        add_tabs(points, properties);
    }
    else
    {
        add_tabs(points, properties);
    }


}

module add_tabs(points, properties)
{
    union()
    {
        linear_extrude(3 * gdv(properties, "tool thickness"))
        polygon(points = bottom_bracket(points, properties));

        linear_extrude(3 * gdv(properties, "tool thickness"))
        polygon(points = top_bracket(points, properties));        
    }    
}

module cut_text(lable, properties, dx, dy)
{
        color("white", 0.5)
        translate([dx, dy, -gdv(properties, "tool thickness")])
        linear_extrude(gdv(properties, "tool thickness") * 3)
        text(lable, size = 8);
}

function bottom_bracket(pts, properties) = 
[
    [pts[0].x, pts[0].y],
    [pts[0].x, - gdv(properties, "tool thickness")],
    [pts[3].x, - gdv(properties, "tool thickness")],
    [pts[3].x, pts[3].y],
];

function top_bracket(pts, properties) = 
[
    [pts[1].x + gdv(properties, "tool thickness"), pts[1].y],
    [pts[1].x + gdv(properties, "tool thickness"), pts[1].y + gdv(properties, "tool thickness")],
    [pts[2].x - gdv(properties, "tool thickness"), pts[2].y + gdv(properties, "tool thickness")],
    [pts[2].x - gdv(properties, "tool thickness"), pts[2].y],
];

Main_Rafter_template = 
[
    "Main Rafter",
        ["angle", 42],
        ["angle2", 48],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 9.5)],
        ["tool thickness", LayersToHeight(10)],
        // ["pre-translate", [0, -convert_in2mm(in = 68.25),0] ],              
        // ["location", [0, -convert_in2mm(in = 27.35), convert_in2mm(in = 21)]],
        // ["rotate", [32, 0, 0]],
        ["lable length", convert_ft2mm(3.5)],
        ["left handed", false],        
        ["lable text", "Main Rafter"],
        ["color", "yellow"]    
];

Brace_One_template = 
[
    "Brace_One",
        ["angle", 32],
        ["angle2", 106],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 5.5)],
        ["tool thickness", LayersToHeight(10)],
        // ["pre-translate", [0, -convert_in2mm(in = 68.25),0] ],              
        // ["location", [0, -convert_in2mm(in = 27.35), convert_in2mm(in = 21)]],
        // ["rotate", [32, 0, 0]],
        ["lable length", convert_ft2mm(3.5)],
        ["lable text", "Brace 1"],
        ["left handed", false], 
        ["color", "yellow"]    
];

Brace_Two_template = 
[
    "Brace_Two",
        ["angle", 25],
        ["angle2", 113],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 7.5)],
        ["tool thickness", LayersToHeight(10)],
        // ["pre-translate", [0, -convert_in2mm(in = 68.25),0] ],              
        // ["location", [0, -convert_in2mm(in = 27.35), convert_in2mm(in = 21)]],
        // ["rotate", [32, 0, 0]],
        ["lable length", convert_ft2mm(3.5)],
        ["lable text", "Brace 2"],
        ["left handed", false], 
        ["color", "yellow"]    
];

Entry_Rafter_template = 
[
    "Entry_Rafter",
        ["angle", 45],
        ["angle2", 45],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 8.5)],
        ["tool thickness", LayersToHeight(10)],
        // ["pre-translate", [0, -convert_in2mm(in = 68.25),0] ],              
        ["lable location", [0, -convert_in2mm(in = 27.35), convert_in2mm(in = 21)]],
        // ["rotate", [32, 0, 0]],
        ["lable length", convert_ft2mm(3.5)],
        ["lable text", "Entry Rafter"],
        ["color", "yellow"]    
];

Block_jBolt_template = 
[
    "block j bolt placement template",
    ["block width", 195],
    ["bolt diameter", 15],
    ["template width" , convert_in2mm(2)],
    ["template thickness", WallThickness(6)],
    ["template tab depth", convert_in2mm(1)],
    ["template tab thickness", WallThickness(6)]
];

Center_beam_spacer = 
[
    "center beam spacer",
    ["angle", 42],
    ["beam width", 37.75],
    ["beam depth", convert_in2mm(5.25 - 4.7)],
    ["beam location", [0, convert_in2mm(4.7), 0]],
    ["brace length", convert_in2mm(3)],
    ["brace width", convert_in2mm(1.5)],
    ["spacer thickness", WallThickness(6)],
    ["p1", [-75.5026, 0]],
    ["p2", [-18.875, 50.9878]],
    ["p3", [18.875, 50.9878]],
    ["p4", [75.5026, 0]]
];

screw_hole_properties = 
[
    "screw hole properties",
    ["angle", 48],
    ["shank color", "grey"],
    ["head color", "yellow"],
    ["shank diameter", woodScrewShankDiaN_8],
    ["shank length", 150],
    ["shank rotate", [90, 0, 48]],
    ["shank move", [-12.7, 10, 0]],
    ["head diameter", convert_in2mm(0.5)],
    ["head length", 25],
    ["head rotate", [90, 0, 48]],    
    ["head move", [-(12.7 - convert_in2mm(0.5)), 0, 0]],
];