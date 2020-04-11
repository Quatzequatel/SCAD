INCH = 25.4;
LineWidth = 0.6;
WallThickness = LineWidth * 3; //
//3/4 poly tubing value is 0.72
Target_Radius = half(Inches(0.25) +  WallThickness); // mm 3/4inch
$fn = 100;

radius = 20;
angles = [-80, 270];
width = 2;
fn = 60;


function half(value) = value/2;
function Inches(value) = INCH * value;
function TailDepthAdjustment(value) = value < 2 ? 0.8 : value /2;
build();

module build(args) 
{
    echo( str("module is ", "P"), Target_Radius=Target_Radius);
    difference()
    {
        PolyPipeClip(radius = Target_Radius, wall = WallThickness, clipLength =  Inches(1.5), clipDepth = WallThickness * 3, height = Inches(0.75));  
    }


}

module PolyPipeClip(radius, wall, clipLength, clipDepth, height=13, screHoleRadius = 3)
{
    difference()
    {
        linear_extrude(height = height)
        difference()
        {
            P(radius+wall, clipLength, clipDepth);         

            P(radius, clipLength, 2*LineWidth);       
        }

        translate([0.5*clipLength,-2,height/2]) rotate([90,0,0]) cylinder(r=screHoleRadius, h=10, center=true);
    }
}

module P(radius, tailLengh, tailDepth)
{
    echo( str("module is ", "P"), radius=radius, wall=TailDepthAdjustment(tailDepth), tailLengh=tailLengh, clipDepth=tailDepth);
    //pipe
    circle(r=radius);
    //clip
    translate([tailLengh/2,-(radius - TailDepthAdjustment(tailDepth) ),0])
    square(size=[tailLengh, tailDepth], center=true);       
}