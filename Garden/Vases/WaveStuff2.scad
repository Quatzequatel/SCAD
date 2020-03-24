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
Radius2 = PointY(Radius1, Angle2);
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
function BaseBevelX() = 
    [
        HullBaseBrimX()+1,
        0,
        -HullBaseBrimX()
    ];
function BaseBevelY() = 
    [
        0,
        HullBaseBrimY(),
        0
    ];

function RimX() = HullBaseBrimX() * Scale;
function RimY() = -HullBaseBrimY() * Scale;
function RimRadius() = (HullBaseRadius()  * Scale) + 1;
function RimBevelX() = 
    [
        RimX(),
        RimX(),
        RimX() - (2 * Radius2)
    ];
function RimBevelY() = 
    [
        -Radius2,
        RimY()/8,
        RimY()
    ];

// Brim2();
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

    difference()
    {
        union()
        {
            linear_extrude(height = Height, twist = Twists, scale=Scale)
            {
                CirclesAroundCircle(Radius1, Angle1, Radius2);
                circle(Radius1);            
            }

            //base
            translate([0,0,2])
            Brim( HullBaseRadius(), BaseBevelX(), BaseBevelY());

            //Rim
            translate([ 0, 0, (Height + abs(RimBevelY()[0]))])
            Brim2( RimRadius(), RimBevelX(), RimBevelY());

        }    

            //Rim
            translate([ 0, 0, (Height + abs(RimBevelY()[0]))])
            Brim3( RimRadius(), RimBevelX(), RimBevelY());
    }
     
}

module Brim(radius = HullBaseRadius(), x = HullBaseBrimX(), y = HullBaseBrimY())
{
    echo(x = x);
    echo();
    echo(y = y);
    rotate_extrude()
    translate([radius, 0, 0])
    hull()
    {
        //translate([-x/9, -y/9, 0])
        //circle(HullRadius);

        translate([x[0], y[0], 0])
        circle(HullRadius);

        translate([x[1], y[1], 0])
        circle(HullRadius);

        translate([x[2], y[2], 0])
        circle(HullRadius);
    }
}

module Brim2(radius = RimRadius(), x = RimBevelX(), y = RimBevelY())
{
    echo(mod =  "Brim2", x = x);
    echo();
    echo(mod =  "Brim2",y = y);

    rotate_extrude()
    difference()
    {
        // rotate_extrude()
        translate([radius, 0, 0])
        hull()
        {
            //translate([-x/9, -y/9, 0])
            //circle(HullRadius);

            translate([x[0], y[0], 0])
            circle(HullRadius);

            translate([x[1], y[1], 0])
            circle(HullRadius);

            translate([x[2], y[2], 0])
            circle(HullRadius);
        }

        translate([0,0,0])
        // rotate_extrude()
        translate([radius-4, -1, 0])
        hull()
        {
            translate([-radius+4, y[1], 0])
            circle(HullRadius);

            translate([-radius+4, y[2], 0])
            circle(HullRadius);

            translate([x[0], y[0], 0])
            circle(HullRadius);

            translate([x[1], y[1], 0])
            circle(HullRadius);

            translate([x[2], y[2], 0])
            circle(HullRadius);
        }
    }
}

module Brim3(radius = RimRadius(), x = RimBevelX(), y = RimBevelY())
{
    echo(mod = "Brim3", x = x);
    echo();
    echo(mod = "Brim3", y = y);

    rotate_extrude()
    translate([radius-2, -1, 0])
    hull()
    {
        translate([-radius+4, y[1], 0])
        circle(HullRadius);

        translate([-radius+4, y[2], 0])
        circle(HullRadius);

        translate([x[0], y[0], 0])
        circle(HullRadius);

        translate([x[1], y[1], 0])
        circle(HullRadius);

        translate([x[2], y[2], 0])
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