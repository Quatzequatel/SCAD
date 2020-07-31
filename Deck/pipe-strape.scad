include <constants.scad>;
use <dictionary.scad>;
use <convert.scad>;
INCH = 25.4;
nozzel_width = 0.6;
WallThickness = nozzel_width * 3; //
//3/4 poly tubing value is 0.72
Target_Radius = half(convert_in2mm(0.25) +  WallThickness); // mm 3/4inch
$fn = 100;

// radius = 20;
// angles = [-80, 270];
// width = 2;
fn = 60;

 Three_Quarter_Inch_Pipe_Properties = 
[
    "filename == Poly_pipe_clip_0_75_Inch",
    ["radius", half(convert_in2mm(0.75))],
    ["radius_adjusted", half(convert_in2mm(0.75) +  WallThickness)],
    ["wall", WallThickness],
    ["clip_length", convert_in2mm(1.5)],
    ["clip_depth", 2 * WallThickness],
    ["clip_width", convert_in2mm(0.75)],
    ["clip_space", 2 * nozzel_width],
    ["screwhole_radius", 2],
    ["screwhole_length", 3 * WallThickness]
];

Quarter_Inch_Pipe_Properties = 
[
    "filename == Poly_pipe_clip_0_25_Inch",
    ["radius", half(convert_in2mm(0.25))],
    ["radius_adjusted", half(convert_in2mm(0.25) +  WallThickness)],
    ["wall", WallThickness],
    ["clip_length", convert_in2mm(1)],
    ["clip_depth", 2 * WallThickness],
    ["clip_width", convert_in2mm(0.5)],
    ["clip_space", 2 * nozzel_width],
    ["screwhole_radius", 2],
    ["screwhole_length", 10]
];

function half(value) = value/2;
function TailDepthAdjustment(value) = value < 2 ? 0.8 : value /2;

build(Quarter_Inch_Pipe_Properties);

module build(args) 
{
    echo( filename = args);
    difference()
    {
        PolyPipeClip
        (
            pipe_properties = args
        );  
    }


}

module PolyPipeClip(pipe_properties)
{
    difference()
    {
        linear_extrude(height = getDictionaryValue(pipe_properties , "clip_width"))
        difference()
        {
            pin_shape(
                getDictionaryValue(pipe_properties , "radius_adjusted"), 
                getDictionaryValue(pipe_properties , "clip_length"), 
                getDictionaryValue(pipe_properties , "clip_depth")
                );         

            #pin_shape(
                getDictionaryValue(pipe_properties , "radius"), 
                getDictionaryValue(pipe_properties , "clip_length"), 
                getDictionaryValue(pipe_properties , "clip_space")
                );       
        }

        translate
        (
            [
                half(getDictionaryValue(pipe_properties , "clip_length")),
                - getDictionaryValue(pipe_properties , "radius") - 2 + half(getDictionaryValue(pipe_properties , "screwhole_length")),
                half(getDictionaryValue(pipe_properties , "clip_width"))
            ]
        ) 
        rotate([90,0,0]) 
        #cylinder(
            r=getDictionaryValue(pipe_properties , "screwhole_radius"), 
            h=getDictionaryValue(pipe_properties , "screwhole_length"), 
            center=true
            );
    }
}

module pin_shape(radius, tailLengh, tailDepth)
{
    echo( str("module is ", "pin_shape"), radius=radius, wall=TailDepthAdjustment(tailDepth), tailLengh=tailLengh, clipDepth=tailDepth);
    //pipe
    circle(r=radius);
    //clip
    translate([tailLengh/2,-(radius - TailDepthAdjustment(tailDepth) ),0])
    square(size=[tailLengh, tailDepth], center=true);       
}