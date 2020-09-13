/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <morphology.scad>;
use <Roof.scad>;

build();

module build(args) 
{
    rotate([180,0,0])
    // rafter_template(Main_Rafter_template);
    // rafter_template(Brace_One_template);
    // rafter_template(Brace_Two_template);
    // rafter_template(Entry_Rafter_template);

    // add_Block_jBolt_template(Block_jBolt_template);
    add_center_beam_spacer(Center_beam_spacer);

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

    rotate([-90,0,0])
    difference()
    {
        union()
        {
            linear_extrude(height=gdv(properties, "brace width"), center=true) 
            shell(d = gdv(properties, "spacer thickness"),center=true)
            polygon(points);

            linear_extrude(height = gdv(properties, "spacer thickness"), center=true) 
            polygon(points);  
        }

        translate([0, points[1].y - gdv(properties, "beam depth")/2 + gdv(properties, "spacer thickness"), 0])
        color("yellow", 0.5) 
        linear_extrude(height=gdv(properties, "brace width"), center=true, convexity=10, twist=0) 
        square([gdv(properties, "beam width"), gdv(properties, "beam depth")], center = true);
    }

  
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

        cut_text(gdv(properties, "lable text"), properties, convert_in2mm(-1), points[1].y/2);

        cut_text(str(gdv(properties, "angle"), "°"), properties, points.x.x + 25, 2);

        cut_text(str(90 - gdv(properties, "angle"), "°"), properties, points[2].x - 20, points[2].y - 10);

        cut_text(str(gdv(properties, "angle2"), "°"), properties, points[3].x - 40, 2);

    }

    // lable_angle(a = gdv(properties, "angle"), l = 20, r = 0.5, size = 2, color = "blue", show_labels = true);
    // text(text = str(gdv(properties, "angle"), "°"), size = 10);

    translate([0, 0, - 2 * gdv(properties, "tool thickness")])
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
    [pts[1].x, pts[1].y],
    [pts[1].x, pts[1].y + gdv(properties, "tool thickness")],
    [pts[2].x, pts[2].y + gdv(properties, "tool thickness")],
    [pts[2].x, pts[2].y],
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
        ["color", "yellow"]    
];

Brace_Two_template = 
[
    "Brace_One",
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
    ["beam depth", convert_in2mm(5.5 - 4.7)],
    ["beam location", [0, convert_in2mm(4.7), 0]],
    ["brace length", convert_in2mm(3)],
    ["brace width", convert_in2mm(1.5)],
    ["spacer thickness", WallThickness(4)],
    ["p1", [-75.5026, 0]],
    ["p2", [-18.875, 50.9878]],
    ["p3", [18.875, 50.9878]],
    ["p4", [75.5026, 0]]
];