/*

*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <TrellisFunctions.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;

ISDEBUGEMODE = false;

test();
module test()
{
    // difference()
    // {
    //     SquareFrame();
    //     SquareFrameCutter();        
    // }

    difference()
    {    
    CircleFrame();
    CircleFrameCutter();
    // HexFrame();
    // HexFrameCutter();
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
            debugEcho(str("module_name is ","SquareFrame()", 
                ", frameDimension = ", frameDimension, 
                ", frameBoardDimension = ", frameBoardDimension, 
                ", screwHoles = ", screwHoles ));
            // echo(width = frameDimension.x, height  = frameDimension.y, screwHoles = screwHoles);
            // echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementHoz = incrementHoz);
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

module SquareFrameCutter
(
    frameDimension = [convert_ft2mm(1), convert_ft2mm(2)],
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(1)]
)
{
    debugEcho(str("module_name is ","SquareFrameCutter()", 
        ", frameWidth = ", frameDimension.x, 
        ", frameHeight = ", frameDimension.y, 
        ", frameBoardDimension = ", frameBoardDimension));
    
    // echo(FrameCutter="FrameCutter", frameWidth=frameDimension.x, frameHeight=frameDimension.y, frameBoardDimension=frameBoardDimension);
    offset =  NozzleWidth/4; //values needs to be less than nozzel frameDimension.x
    translate([0, 0, -frameBoardDimension.y])
    linear_extrude(height= 3 * frameBoardDimension.y)
    {
        difference()
        {
            square(size = [3 * frameDimension.x, 3 * frameDimension.y], center = true);
            square(size = [frameDimension.x + offset, frameDimension.y + offset], center = true);
        }
    }
}

module CircleFrame
(
    frameRadius = 300,
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(2)],
    screwHoles = [10, 3]  //[od, count]
)
{
    debugEcho(str("module_name is ","CircleFrame()", 
        ", frameRadius = ", frameRadius, 
        ", frameBoardDimension = ", frameBoardDimension,
        ", screwHoles = ", screwHoles
        ));    
    // echo(CircleFrame="CircleFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);
    difference()
    {
        union()
        {
            rotate_extrude(angle = 360)
            {
                translate([frameRadius,0,0])
                {
                    // echo(size = [frameBoardDimension.x, frameBoardDimension.y]);
                    square(size = [2*frameBoardDimension.x, 2*frameBoardDimension.y], center = true);
                }                     
            }
        
        }     
    
        if (len(screwHoles) != undef)
        {
            echo(screwHoleCount = screwHoles[enumScrewCount], screwHoleOD = screwHoles[enumScrew_OD]);
            for(i = [1 : screwHoles[enumScrewCount]])
            {
                rotate([90,0, i * 360/(screwHoles[enumScrewCount])])
                cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameRadius + frameBoardDimension.x), center=true);
            }
        }
    }
}

module CircleFrameCutter
    (
        frameRadius = 300,
        frameBoardDimension = [convert_in2mm(1), convert_in2mm(2)]
    )
{
    debugEcho(str("module_name is ","CircleFrameCutter()", 
        ", frameRadius = ", frameRadius, 
        ", frameBoardDimension = ", frameBoardDimension));        
    // echo(CircleFrameCutter="CircleFrameCutter", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

    union()
    {
        translate([0,0,-frameBoardDimension.y/2])
        rotate_extrude(angle = 360)
        {
            translate([frameRadius + frameBoardDimension.x/2 + 0.01,0,0])
            {
                echo(size = frameBoardDimension);
                square(size = frameBoardDimension, center = false);
            }                     
        }
    }     
} 

module HexFrame
(
    frameRadius = 300,
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(2)],
    screwHoles = [5, 3]  //[od, count [0:3]]
)
{
    debugEcho(str("module_name is ","HexFrame()", 
        ", frameRadius = ", frameRadius, 
        ", frameBoardDimension = ", frameBoardDimension,
        ", screwHoles = ", screwHoles
        ));   

    // echo(HexFrame="HexFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

    difference()
    {
        union()
        {
            translate([0,0,-frameBoardDimension.y/2])
           linear_extrude(height = frameBoardDimension.y)
            {
                difference()
                {
                    circle(r=frameRadius, $fn = 6);
                    circle(r=frameRadius - frameBoardDimension.x, $fn = 6);
                }                   
            }        
        }     
    
        if (len(screwHoles) != undef)
        {
            debugEcho(str("module_name is ","HexFrame()", 
                ", screwHoleCount = ", screwHoles[enumScrewCount], 
                ", screwHoleOD = ", screwHoles[enumScrew_OD]
                ));               
            // echo(screwHoleCount = screwHoles[enumScrewCount], screwHoleOD = screwHoles[enumScrew_OD]);
            assert(screwHoles[enumScrewCount] < 4, "max value for screw holes is 3.");

            for(i = [0 : screwHoles[enumScrewCount]-1])
            {
                // echo(info = [ 90, 0, screwAngle(i = i)]);
                rotate([90, 0, screwAngle(i = i)])
                cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameRadius + frameBoardDimension.x), center=true);
            }
        }
    }

    function screwAngle(i) = 60 + (i * 60);
}

module HexFrameCutter
(
    frameRadius = 300,
    frameBoardDimension = [convert_in2mm(1), convert_in2mm(2)],
)
{
    debugEcho(str("module_name is ","HexFrameCutter()", 
        ", frameRadius = ", frameRadius, 
        ", frameBoardDimension = ", frameBoardDimension
        ));      

    union()
    {
        translate([0,0,-frameBoardDimension.y/2])
        linear_extrude(height = frameBoardDimension.y)
        {
            difference()
            {
                circle(r=2 * frameRadius, $fn = 6);
                circle(r=frameRadius + 0.01, $fn = 6);
            }                   
        }        
    }    
} 