
$fn=60;
build("Tube");
module build(shape)
{
    if(shape == "ScrewHole")
    {
         ScrewHole(height=16, od=4, id=3.25, insetDiameter=9.25);
    }
    if(shape == "Tube")
    {
        Tube(od=4, id=3.25, length=16);
    }
    if(shape == "ConeHollow")
    {
        ConeHollow(od1=8, od2=4, wall=2, height=16);
    }
}


module ScrewHole(height, od, id, insetDiameter)
{
    echo("ScrewHole", height=height, od=od, id=id, insetDiameter=insetDiameter);
    //translate([0, 0, height+1])
    rotate([0, 180, 0]) 
    {
        wall = od - id;
        cylinder(h=height + 1, d1=od, d2=od);;
        if(insetDiameter > id)
        {
            cylinder(h=insetDiameter, d1 = insetDiameter, d2 = 1);
        }
    }
}

module Tube(od, id, length)
{
    linear_extrude(height=length)
    {
        difference()
        {
            circle(r=od/2);
            circle(r=id/2);
        }
    }
}

module ConeHollow(od1, od2, wall, height)
{
    {
        difference()
        {
            cylinder(d1=od1, d2=od2, h=height);
            cylinder(d1=od1-wall, d2=od2-wall, h=height);
        }
    }
}