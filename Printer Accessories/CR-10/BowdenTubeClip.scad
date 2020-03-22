/*

*/

$fn= 360;

Nozzle = 0.8;
LineWidth = 1.2;
LayerHeight = 0.24;
Layers = 8;

TabAngle = 4;
CutAngle = TabAngle /16;
Radius = 8;
WallThickness = LineWidth * 2;
Height = LayerHeight * Layers;

function GripR(r) = r/5;
function GripW(w) = w/2;
function GripX(r, w) = cos(TabAngle) * abs(r);
function GripY(r, w) = sin(TabAngle) * r + cos(TabAngle) * w;
function CutAwayX(r,w) = cos(CutAngle) * r + w;
function CutAwayY(r,w) = sin(CutAngle) * r + w;

Build();
module Build(args) {
    Clip(Radius,WallThickness,Height);
}

module Clip(r, w, z)
{
    difference()
    {
        union()
        {
            echo( OD = r*2, ID = (r-w)*2);
            Tube(r,w,z);

            for (i=[-1,1]) 
            {
                translate([GripX(r * i, w), GripY(r * i, w * i), 0]) 
                {
                    Tube(GripR(r),GripW(w),z);
                }
            }
        }

        translate([0,0,z-2])
        CutAway(r,w,z+2);
        translate([0,0,z+1])
        {
            rotate([180,0,0])
            CutAway(r,w,z+2);
        }
    }
}

module Tube(r, w, z)
{
    linear_extrude(height = z)
    difference()
    {
        circle(r=r);
        circle(r= r-w);
    }
}

module CutAway(r, w, z)
{
    echo(r=r, w=w, z=z);
    echo(CutAwayX = CutAwayX(r, w), CutAwayY = CutAwayY( r, w));

    t = [[0,0] , [r,0], [CutAwayX(r, w), CutAwayY( r, w)]];

    linear_extrude(height = z)
    polygon(t);   
}