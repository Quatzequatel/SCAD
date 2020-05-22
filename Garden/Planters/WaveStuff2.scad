/*
    This structure is a circle (R1) surrounded by semi-circles (R2),
        the circles are then extruded and 'rotated' (Twists).
        Ideally only Radius1, Columns and Twists needs to be modified.
            R3 = R1 + R2; R2 => sin(Angle1) * R1.
            Function PointY() is the distance between Ray1 (twist0) and Ray2 (twist1); 
        Adjusting Angle2 affects the size of the columns. 
            including if they overlap or not.
        Brims - having the columns emerge from a floor and into a top.
        Brims are hulled triangle rotate_extrude()
    how to use;
    Radius1 - bottom radius.
    Radius2 - Radius1 plus distance of arc1 - arc2 which is Radius2.
    Scale - ratio from bottom to top.
    Angle1 - the angle of segments from center ([0,0]).
    Angle2 - the angle of segments for circles (columns).
    Twists - in degrees, angle of twist completed in vertical
            extrusion. positive value is clockwise, negative is opposite.
*/
FirstLayerHeight = 0.4;
LayerHeight = 0.32;
LayerCount = 3;
GOLDEN_RATIO = 1.61803398874989484;
$fn=60;
Radius1 = 75;
Scale = 1 + PI/10; //ratio of top over bottom.
Columns = 24; // 
Angle1 = 360/Columns;  //
//Radius2 is dependent on Angle2.
Angle2 = Angle1; //
// Angle2 = Angle1 * 0.61803;
Twists = 120; // Value above 120 will cause slicer to add bottom layer
Radius2 = PointY(Radius1, Angle2);
Radius3 = Radius1 + Radius2;
HullRadius = 2;
Height = Radius1 * 2 * GOLDEN_RATIO;
FloorThickness = FirstLayerHeight +  (LayerCount-1 * LayerHeight);

function DegreeSteps(angle) = 360/angle;
function StepCount(angle) = 360/DegreeSteps(angle);

function PointX(radius, degree) = cos(degree) * radius;
function PointY(radius, degree) = sin(degree) * radius;
function MoveCircleToArcLocation(radius, resolution, index) = 
    [
        PointX(radius, DegreeSteps(resolution) * index), 
        PointY(radius, DegreeSteps(resolution) * index), 
        0
    ];

//BaseBrim 
function BaseBrimX() = PointX(30, Radius2);
function BaseBrimY() = Height/2;
function BaseRadius() = Radius3 - (BaseBrimX()) ;//- (PointX(Radius2, Angle2));
function BaseBevelX() = 
    [
        BaseBrimX(),
        0,
        -BaseBrimX()
    ];
function BaseBevelY() = 
    [
        0,
        BaseBrimY(),
        0
    ];

//TopBrim
function RimX() = BaseBrimX() * Scale;
function RimY() = -BaseBrimY() * Scale;
// function RimRadius1() = (BaseRadius() + 1.24);
function RimRadius2() = (BaseRadius()  * Scale);
function TopRadius() = Radius3 * Scale;
function RimBevelX() = 
    [
        RimX(),
        RimX(),
        RimX() - PointX(60, Radius2)
    ];
function RimBevelY() = 
    [
        -Radius2,
        -Radius2*2,   //This is a magic value.
        -Height
    ];

Build();
module Build(args) 
{
    echo(Height = Height);
    echo(Radius1 = Radius1);
    echo(Radius2 = Radius2);
    echo(Radius3 = Radius3);
    echo( value = PointX(Radius2, Angle2));
    echo(BottomRadius = BaseRadius());
    echo(TopRadius = (Radius3) * Scale);

    echo(Angle1=Angle1, Angle2=Angle2);
    echo(Scale=Scale);

    difference()
    {
        union()
        {
            linear_extrude(height = Height, twist = Twists, scale=Scale)
            union()
            {
                CirclesAroundCircle(Radius1, Angle1, Radius2);
                circle(Radius1);            
            }

            //base
            translate([0,0,2])
            BaseBrim( BaseRadius(), BaseBevelX(), BaseBevelY());

            //Rim
            translate([ 0, 0, (Height + abs(RimBevelY()[0]))])
            Brim2( RimRadius2(), RimBevelX(), RimBevelY());

        }    

            //Rim
            translate([ 0, 0, (Height + abs(RimBevelY()[0]))])
            Brim3( RimRadius2(), RimBevelX(), RimBevelY());

            translate([0,0,Height/2 + FloorThickness])
            cylinder(r1=BaseRadius() + 1.24, r2 = TopRadius() , h=Height, center=true);
    }
     
}

module BaseBrim(radius = BaseRadius(), vX = BaseBrimX(), vY = BaseBrimY())
{
    // echo(mod =  "Brim", vX = vX);
    // echo();
    // echo(mod =  "Brim",vY = vY);
    // echo();

    rotate_extrude()
    translate([radius, 0, 0])
    hull()
    {
        translate([vX[0], vY[0], 0])
        circle(HullRadius);

        translate([vX[1], vY[1], 0])
        circle(HullRadius);

        translate([vX[2], vY[2], 0])
        circle(HullRadius);
    }
}

module Brim2(radius = RimRadius2(), vX = RimBevelX(), vY = RimBevelY())
{
    echo(mod =  "Brim2", radius = radius);
    echo(mod =  "Brim2", vX = vX);
    echo();
    echo(mod =  "Brim2",vY = vY);
    echo();

    rotate_extrude()
    difference()
    {
        translate([radius, 0, 0])
        hull()
        {
            translate([vX[0], vY[0], 0])
            circle(HullRadius);

            translate([vX[1], vY[1], 0])
            #circle(HullRadius);

            translate([vX[2], vY[2], 0])
            #circle(HullRadius);
        }

        translate([0,0,0])
        translate([radius-4, 0, 0])
        hull()
        {
            translate([-radius+4, vY[1], 0])
            circle(HullRadius);

            translate([-radius+4, vY[2], 0])
            circle(HullRadius);

            translate([vX[0], vY[0], 0])
            circle(HullRadius);

            translate([vX[1], vY[1], 0])
            circle(HullRadius);

            translate([vX[2], vY[2], 0])
            circle(HullRadius);
        }
    }
}

module Brim3(radius = RimRadius2(), vX = RimBevelX(), vY = RimBevelY())
{
    echo(mod = "Brim3", vX = vX);
    echo();
    echo(mod = "Brim3", vY = vY);

    rotate_extrude()
    translate([radius-2, -1, 0])
    hull()
    {
        translate([-radius+4, vY[1], 0])
        circle(HullRadius);

        translate([-radius+4, vY[2], 0])
        circle(HullRadius);

        translate([vX[0], vY[0], 0])
        circle(HullRadius);

        translate([vX[1], vY[1], 0])
        circle(HullRadius);

        translate([vX[2], vY[2], 0])
        circle(HullRadius);
    }
}

module CirclesAroundCircle(radius, angle, r2)
{
    echo(radius = radius, angle = angle, Steps = StepCount(angle) );
    for(i = [0: StepCount(angle)])
    {
        translate(MoveCircleToArcLocation(radius, angle, i))
        circle(r2);
    }
}