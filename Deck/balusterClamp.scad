/*
Notes: recreated ring portion.
    Reduced clamp height by half.
    Increased splice to 2;
*/
BalusterWidth = 39;
BalusterSpacing = 83.5;
WallThickness = 4;
ClampHeight = BalusterWidth * 1;
PlanterDiameter = 150;
PlanterRingDiameter = 8;
PlanterRingOffset = 25;
Triangle = [[0,0],[0,5],[3,0]];

function FullBalusterWidth() = BalusterWidth + WallThickness ;
function BalusterDepth() = BalusterWidth + (WallThickness * 2);
function ClampWidth() = BalusterSpacing + FullBalusterWidth()*2;
function ClampDepth() = BalusterDepth();
function half(v) = radius(v);
function radius(diameter) = diameter/2;

//draw object
difference()
{
    balusterClamp();
    //onlyBackClamp();
}

//just back clamp
module onlyBackClamp()
{
    translate([0,half(BalusterDepth())+1,0])
    cube([ClampWidth(), ClampDepth()+PlanterDiameter, ClampHeight]);
}


module balusterClamp()
{
    clamp();
    planterRing(PlanterDiameter,PlanterRingDiameter);
    ringAttachment();
    ringSupports();
}

module ringSupports()
{
    translate([half(ClampWidth()-26),ClampDepth()-2,0])
    {
    rotate([0,-90,44])
    linear_extrude(height = 6, center = true, convexity = 10, twist = 0)
    polygon(points=[[0,0],[30,0],[0,55]], paths=[[0,1,2]],convexity=10);
    }
    
    translate([half(ClampWidth()+26),ClampDepth()-2,0])
    {
    rotate([0,-90,-44])
    linear_extrude(height = 6, center = true, convexity = 10, twist = 0)
    polygon(points=[[0,0],[30,0],[0,55]], paths=[[0,1,2]],convexity=10);
    }
}

module clamp()
{
    difference()
    {
        cube([ClampWidth(), ClampDepth(), ClampHeight]);
        translate([WallThickness, WallThickness,0])
        baluster(BalusterWidth,ClampHeight);
        
        translate([BalusterSpacing + FullBalusterWidth(), WallThickness,0])
        baluster(BalusterWidth,ClampHeight);
        
        //splice
        translate([0,half(BalusterDepth()),0])
            cube([BalusterSpacing + FullBalusterWidth()*2,2,ClampHeight]);
        
        //through hole
        rotate([90,0,0])  {
            translate([ClampWidth()/2,ClampHeight/2,-50])  {
                cylinder(h = 100,d = 5, $fn=100);
            }
        }
        //nut
        rotate([90,0,0])  {
            translate([ClampWidth()/2,ClampHeight/2,-7])  {
                cylinder(h = 100,d = 10, $fn=6);
            }
        }
        //head
        rotate([90,0,0])  {
            translate([ClampWidth()/2,ClampHeight/2,-65])  {
                cylinder(h = 20,d = 10, $fn=100);
            }
        }
    }
}

module baluster(width, height)
{
    cube([width, width, height]);
}

module planterRing(ringInnerDiameter, ringDiameter)
{
    echo(ClampWidth());
    translate(
        [radius(ClampWidth()),
        radius(ringInnerDiameter)+BalusterWidth+PlanterRingOffset,
        radius(ringDiameter)])
    rotate_extrude(convexity = 10,$fn = 100)
    translate([radius(ringInnerDiameter), 0, 0])
    circle(r = radius(ringDiameter), $fn = 100);
}

module ringAttachment()
{
    translate([
        radius(ClampWidth())-radius(BalusterSpacing),
        BalusterWidth+4,
        0])
    cube([BalusterSpacing, PlanterRingOffset, PlanterRingDiameter]);
    
    #polygon(points=Triangle, 10);
}
