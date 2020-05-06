/*

*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;

test();
module test()
{
    difference()
    {
        SquareFrame();
        FrameCutter();        
    }

    difference()
    {    
    CircleFrame();
    CircleFrameCutter();
    }
}

module SquareFrame
(
    frameDimension = [convert_ft2mm(1), convert_ft2mm(2)],
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(1)],
    screwHoles = [5, 3]
) 
{
    difference()
    {
        union()
        {    
            // Box
            linear_extrude(height = frameBoardDimension.y)
            difference()
            {
                square(size=[frameDimension.x, frameDimension.y], center=true);
                square(size=[frameDimension.x - frameBoardDimension.x, frameDimension.y - frameBoardDimension.x], center=true);
            }
        }   

        if (len(screwHoles) != undef) 
        {
            incrementHoz = frameDimension.y / (screwHoles[enumScrewCount] + 1);
            echo(width = frameDimension.x, height  = frameDimension.y, screwHoles = screwHoles);
            echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementHoz = incrementHoz);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                //note: p[x=>length]
                point_sphere
                    (
                        diameter = screwHoles[enumScrew_OD], 
                        p1 = [ - getActualWidth()/2, (i * incrementHoz - frameDimension.y/2), frameBoardDimension.y/2], 
                        p2 = [   getActualWidth()/2, (i * incrementHoz - frameDimension.y/2), frameBoardDimension.y/2]
                    );
            }

            incrementVert = frameDimension.x / (screwHoles[enumScrewCount] + 1);
            echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementVert = incrementVert);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                //note: p[y=>length]
                point_sphere
                    (
                        diameter = screwHoles[enumScrew_OD], 
                        p1 = [(i * incrementVert - frameDimension.x/2), - getActualHeight()/2, frameBoardDimension.y/2], 
                        p2 = [(i * incrementVert - frameDimension.x/2),   getActualHeight()/2, frameBoardDimension.y/2]
                    );                
            }
        }        
    }

    function getActualWidth() = frameDimension.x + frameBoardDimension.x;
    function getActualHeight() = frameDimension.y + frameBoardDimension.x;
}

module CircleFrame
(
    frameRadius = 300,
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(2)],
    screwHoles = [5, 3]
)
{
    difference()
    {
        union()
        {
            rotate_extrude(angle = 360)
            {
                translate([frameRadius,0,0])
                {
                    // echo(size = [frameBoardDimension.x, frameBoardDimension.y]);
                    square(size = frameBoardDimension, center = true);
                }                     
            }
        
        }     
    
        if (len(screwHoles) != undef)
        {
            echo(screwHoles = screwHoles[enumScrewCount])
            for(i = [1 : 2])
            {
                rotate([90,0, i * 360/(screwHoles[enumScrewCount]*2)])
                cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameRadius + frameBoardDimension.x), center=true);
            }
        }
    }
}

module FrameCutter
(
    frameDimension = [convert_ft2mm(1), convert_ft2mm(2)],
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(1)]
)
{
    echo(FrameCutter="FrameCutter", frameWidth=frameDimension.x, frameHeight=frameDimension.y, frameBoardDimension=frameBoardDimension);
    offset =  NozzleWidth/4; //values needs to be less than nozzel frameDimension.x
    translate([0, 0, -frameBoardDimension.y])
    linear_extrude(height= 3 * frameBoardDimension.y)
    {
        difference()
        {
            square(size = [2 * frameDimension.x, 2 * frameDimension.y], center = true);
            square(size = [frameDimension.x + offset, frameDimension.y  +offset], center = true);
        }
    }
}

module CircleFrameCutter
    (
        frameRadius = 300,
        frameBoardDimension = [convert_in2mm(0.5), convert_in2mm(0.5)]
    )
{
    union()
    {
        translate([0,0,-frameBoardDimension.y/6])
        rotate_extrude(angle = 360)
        {
            translate([frameRadius + frameBoardDimension.y/6,0,0])
            {
                // echo(size = frameBoardDimension);
                square(size = frameBoardDimension, center = false);
            }                     
        }
    
    }     
} 