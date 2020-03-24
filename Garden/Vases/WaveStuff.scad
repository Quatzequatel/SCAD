/*
    how to use;
    Radius1 - bottom radius.
    Radius2 - currently calculated from R1.
    Scale - ratio from bottom to top.
    Angle1 - the angle of segments from center ([0,0]).
    Angle2 - the angle of segments for circles.
    Twists - in degrees, angle of twist completed in vertical
            extrusion. positive value is clockwise, negative is opposite.
*/
GOLDEN_RATIO = 1.61803398874989484;
$fn=360;
Radius1 = 100;
Scale = 1 + PI/10;
Angle1 = 360/24;
Angle2 = 12;
// Angle2 = Angle1 * 0.61803;
Twists = 180;
Radius2 = PointY(Radius1,Angle2);
Radius3 = Radius1 + Radius2;
Radius4 = Radius2/2;
HullRadius = 2;
Height = Radius1 * 2 * GOLDEN_RATIO;



function DegreeSteps(resolution) = 360/resolution;
function StepCount(resolution) = 360/DegreeSteps(resolution);

function PointX(radius, degree) = cos(degree) * radius;
function PointY(radius, degree) = sin(degree) * radius;
function MoveCircleToArcLocation(radius, resolution, index) = 
    [
        PointX(radius, DegreeSteps(resolution) * index), 
        PointY(radius, DegreeSteps(resolution) * index), 
        0
    ];

//BaseBrim 
function HullBaseBrimX() = (Radius2 - (2 * HullRadius) + HullRadius);
function HullBaseBrimY() = 4 * (Radius2 - (2 * HullRadius));
function HullBaseRadius() = Radius3 - ( PointX(Radius2, Angle2));

function RimX() = HullBaseBrimX() * Scale;
function RimY() = -HullBaseBrimY() * Scale;
function RimRadius() = (HullBaseRadius()  * Scale);

Build();
module Build(args) 
{
    echo(Height = Height);
    echo(Radius1 = Radius1);
    echo(Radius2 = Radius2);
    echo(Radius3 = Radius3);
    echo(Radius4 = Radius4);
    echo(BottomRadius = Radius3);
    echo(TopRadius = (Radius3) * Scale);

    echo(Angle1=Angle1, Angle2=Angle2);
    echo(Scale=Scale);

    union()
    {
        linear_extrude(height = Height, twist = Twists, scale=Scale)
        {
            CirclesAroundCircle(Radius1, Angle1, Radius2);
            circle(Radius1);            
        }

        //base
        translate([0,0,HullRadius])
        Brim( HullBaseRadius(), HullBaseBrimX(), HullBaseBrimY());

        //Rim
        translate([ 0, 0, Height-HullRadius])
        Brim( RimRadius(), RimX(), RimY());

    }       
}

module Brim(radius = HullBaseRadius(), x = HullBaseBrimX(), y = HullBaseBrimY())
{
    rotate_extrude()
    translate([radius, 0, 0])
    hull()
    {
        circle(HullRadius);

        translate([x, 0, 0])
        circle(HullRadius);

        translate([0, y, 0])
        circle(HullRadius);
    }
}

module CirclesAroundCircle(radius, resolution, r2)
{
    echo(radius = radius, resolution = resolution, Steps = StepCount(resolution) );
    for(i = [0: StepCount(resolution)])
    {
        translate(MoveCircleToArcLocation(radius, resolution, i))
        circle(r2);
    }
}
