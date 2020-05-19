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
    //Global Properties
    FrameBoardDimension = [WallThickness(count = 4), convertInches2mm(0.5)]; 
    FrameDimension = [convertInches2mm(12) - FrameBoardDimension.y, convertInches2mm(12) - FrameBoardDimension.y];
    LatticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    ScrewHoles = [woodScrewShankDiaN_8, 2];
    IntervalCount =2;    
    Includes = setIncludeProperty
        ([], 
            frame = true, 
            diamondStyleTrellis = false, 
            squareTrellis = false, 
            spiralTrellis = false, 
            waveTrellis = false,
            frameType = enumFrameTypeSquare
        );

    //Frame type Properties
    frameProperties = 
    [
        FrameDimension,         //[0] enumPropertyFrame
        FrameBoardDimension,    //[1] enumPropertyFrameBoard
        LatticeDimension,       //[2] enumPropertyLattice
        ScrewHoles,             //[3] enumPropertyScrewHoles
        IntervalCount,          //[4] enumPropertyInterval
        Includes                //[5] enumPropertyInclude.
    ];

    if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeSquare)
    {        
        difference()
        {
            SquareFrame(frameProperties = frameProperties);
            SquareFrameCutter(frameProperties = frameProperties); 
        }   
    }
    
    if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeCircle)
    {        
        difference()
        {
            CircleFrame(frameProperties = frameProperties);
            CircleFrameCutter(frameProperties = frameProperties);
        }   
    }

    if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeHex)
    {        
        difference()
        {
            HexFrame(frameProperties = frameProperties);
            HexFrameCutter(frameProperties = frameProperties);  
        }   
    }           
}

module SquareFrame
(
    frameProperties
) 
{
    difference()
    {
        union()
        {    
            // Box
            linear_extrude(height = frameProperties[enumPropertyFrameBoard].y)
            difference()
            {
                square(size=[frameProperties[enumPropertyFrame].x, frameProperties[enumPropertyFrame].y], center=true);
                square(size=[frameProperties[enumPropertyFrame].x - frameProperties[enumPropertyFrameBoard].x, frameProperties[enumPropertyFrame].y - frameProperties[enumPropertyFrameBoard].x], center=true);
            }
        }   

        if (len(frameProperties[enumPropertyScrewHoles]) != undef) 
        {
            incrementHoz = frameProperties[enumPropertyFrame].y / (frameProperties[enumPropertyScrewHoles][enumScrewCount] + 1);
            debugEcho(str("module_name is ","SquareFrame()", 
                ", frameDimension = ", frameProperties[enumPropertyFrame], 
                ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard], 
                ", screwHoles = ", frameProperties[enumPropertyScrewHoles] ));
            // echo(width = frameDimension.x, height  = frameDimension.y, screwHoles = screwHoles);
            // echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementHoz = incrementHoz);
            for(i = [1 : frameProperties[enumPropertyScrewHoles][enumScrewCount]])
            {
                //note: p[x=>length]
                point_sphere
                    (
                        diameter = frameProperties[enumPropertyScrewHoles][enumScrew_OD], 
                        p1 = [ - getActualWidth()/2, (i * incrementHoz - frameProperties[enumPropertyFrame].y/2), frameProperties[enumPropertyFrameBoard].y/2], 
                        p2 = [   getActualWidth()/2, (i * incrementHoz - frameProperties[enumPropertyFrame].y/2), frameProperties[enumPropertyFrameBoard].y/2]
                    );
            }

            incrementVert = frameProperties[enumPropertyFrame].x / (frameProperties[enumPropertyScrewHoles][enumScrewCount] + 1);
            echo(getActualHeight = getActualHeight(), ScrewCount  = frameProperties[enumPropertyScrewHoles][enumScrewCount], incrementVert = incrementVert);
            for(i = [1 : frameProperties[enumPropertyScrewHoles][enumScrewCount]])
            {
                //note: p[y=>length]
                point_sphere
                    (
                        diameter = frameProperties[enumPropertyScrewHoles][enumScrew_OD], 
                        p1 = [(i * incrementVert - frameProperties[enumPropertyFrame].x/2), - getActualHeight()/2, frameProperties[enumPropertyFrameBoard].y/2], 
                        p2 = [(i * incrementVert - frameProperties[enumPropertyFrame].x/2),   getActualHeight()/2, frameProperties[enumPropertyFrameBoard].y/2]
                    );                
            }
        }        
    }

    function getActualWidth() = frameProperties[enumPropertyFrame].x + frameProperties[enumPropertyFrameBoard].x;
    function getActualHeight() = frameProperties[enumPropertyFrame].y + frameProperties[enumPropertyFrameBoard].x;
}

module SquareFrameCutter
(
    // frameDimension = [convert_ft2mm(1), convert_ft2mm(2)],
    // frameBoardDimension = [convert_in2mm(1), convert_in2mm(1)]
    frameProperties
)
{
    debugEcho(str("module_name is ","SquareFrameCutter()", 
        ", frameWidth = ", frameProperties[enumPropertyFrame].x, 
        ", frameHeight = ", frameProperties[enumPropertyFrame].y, 
        ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard]));
    
    // echo(FrameCutter="FrameCutter", frameWidth=frameDimension.x, frameHeight=frameDimension.y, frameBoardDimension=frameBoardDimension);
    offset =  NozzleWidth/4; //values needs to be less than nozzel frameDimension.x
    translate([0, 0, -frameProperties[enumPropertyFrameBoard].y])
    linear_extrude(height= 3 * frameProperties[enumPropertyFrameBoard].y)
    {
        difference()
        {
            square(size = [3 * frameProperties[enumPropertyFrame].x, 3 * frameProperties[enumPropertyFrame].y], center = true);
            square(size = [frameProperties[enumPropertyFrame].x + offset, frameProperties[enumPropertyFrame].y + offset], center = true);
        }
    }
}

module CircleFrame
(
    frameProperties
)
{
    debugEcho(str("module_name is ","CircleFrame()", 
        ", frameRadius = ", frameProperties[enumPropertyFrame].x, 
        ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard],
        ", screwHoles = ", frameProperties[enumPropertyScrewHoles]
        ));    
    // echo(CircleFrame="CircleFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);
    difference()
    {
        union()
        {
            rotate_extrude(angle = 360)
            {
                translate([frameProperties[enumPropertyFrame].x,0,0])
                {
                    // echo(size = [frameBoardDimension.x, frameBoardDimension.y]);
                    square(size = [2*frameProperties[enumPropertyFrameBoard].x, 2*frameProperties[enumPropertyFrameBoard].y], center = true);
                }                     
            }
        
        }     
    
        if (len(frameProperties[enumPropertyScrewHoles]) != undef)
        {
            echo(screwHoleCount = frameProperties[enumPropertyScrewHoles][enumScrewCount], screwHoleOD = frameProperties[enumPropertyScrewHoles][enumScrew_OD]);
            for(i = [1 : frameProperties[enumPropertyScrewHoles][enumScrewCount]])
            {
                rotate([90,0, i * 360/(frameProperties[enumPropertyScrewHoles][enumScrewCount])])
                cylinder(d=frameProperties[enumPropertyScrewHoles][enumScrew_OD], h= 2 * (frameProperties[enumPropertyFrame].x + frameProperties[enumPropertyFrameBoard].x), center=true);
            }
        }
    }
}

module CircleFrameCutter
    (
        frameProperties
    )
{
    debugEcho(str("module_name is ","CircleFrameCutter()", 
        ", frameRadius = ", frameProperties[enumPropertyFrame].x, 
        ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard]));        
    // echo(CircleFrameCutter="CircleFrameCutter", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

    union()
    {
        translate([0,0,-frameProperties[enumPropertyFrameBoard].y/2])
        rotate_extrude(angle = 360)
        {
            translate([frameProperties[enumPropertyFrame].x + frameProperties[enumPropertyFrameBoard].x/2 + 0.01,0,0])
            {
                echo(size = frameProperties[enumPropertyFrameBoard]);
                square(size = frameProperties[enumPropertyFrameBoard], center = false);
            }                     
        }
    }     
} 

module HexFrame
(
    frameProperties
)
{
    debugEcho(str("module_name is ","HexFrame()", 
        ", frameRadius = ", frameProperties[enumPropertyFrame].x, 
        ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard],
        ", screwHoles = ", frameProperties[enumPropertyScrewHoles]
        ));   

    // echo(HexFrame="HexFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

    difference()
    {
        union()
        {
            translate([0,0,-frameProperties[enumPropertyFrameBoard].y/2])
           linear_extrude(height = frameProperties[enumPropertyFrameBoard].y)
            {
                difference()
                {
                    circle(r=frameProperties[enumPropertyFrame].x, $fn = 6);
                    circle(r=frameProperties[enumPropertyFrame].x - frameProperties[enumPropertyFrameBoard].x, $fn = 6);
                }                   
            }        
        }     
    
        if (len(frameProperties[enumPropertyScrewHoles]) != undef)
        {
            debugEcho(str("module_name is ","HexFrame()", 
                ", screwHoleCount = ", frameProperties[enumPropertyScrewHoles][enumScrewCount], 
                ", screwHoleOD = ", frameProperties[enumPropertyScrewHoles][enumScrew_OD]
                ));               
            
            assert(frameProperties[enumPropertyScrewHoles][enumScrewCount] < 4, "max value for screw holes is 3.");

            for(i = [0 : frameProperties[enumPropertyScrewHoles][enumScrewCount]-1])
            {
                // echo(info = [ 90, 0, screwAngle(i = i)]);
                rotate([90, 0, screwAngle(i = i)])
                cylinder(d=frameProperties[enumPropertyScrewHoles][enumScrew_OD], h= 2 * (frameProperties[enumPropertyFrame].x + frameProperties[enumPropertyFrameBoard].x), center=true);
            }
        }
    }

    function screwAngle(i) = 60 + (i * 60);
}

module HexFrameCutter
(
    frameProperties
)
{
    debugEcho(str("module_name is ","HexFrameCutter()", 
        ", frameRadius = ", frameProperties[enumPropertyFrame].x, 
        ", frameBoardDimension = ", frameProperties[enumPropertyFrameBoard]
        ));      

    union()
    {
        translate([0,0,-frameProperties[enumPropertyFrameBoard].y/2])
        linear_extrude(height = frameProperties[enumPropertyFrameBoard].y)
        {
            difference()
            {
                circle(r=2 * frameProperties[enumPropertyFrame].x, $fn = 6);
                circle(r=frameProperties[enumPropertyFrame].x + 0.01, $fn = 6);
            }                   
        }        
    }    
} 