/*

*/
include <constants.scad>;
include <TrellisEnums.scad>;
// include <TrellisEnums.scad>;
use <vectorHelpers.scad>;
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

    FrameDimensionProperties = 
    [
        "framedimensionproperties",
        [
            ["frame type", enumFrameTypeSquare],
            ["frame dimension", FrameDimension],
            ["frameboard dimension", FrameBoardDimension],
            ["screw holes", [woodScrewShankDiaN_4, 1]],
            ["debug", true]
        ]
    ];

    //Frame type Properties
    frameProperties = 
    [
        FrameDimensionProperties
    ];

    frameDictionary = getKeyValue(frameProperties, "framedimensionproperties");
    frameType = getKeyValue(frameDictionary, "frame type");

    if(frameType == enumFrameTypeSquare)
    {        
        difference()
        {
            SquareFrame(frameProperties = frameProperties);
            SquareFrameCutter(frameProperties = frameProperties); 
        }   
    }
    
    if(frameType == enumFrameTypeCircle)
    {        
        difference()
        {
            CircleFrame(frameProperties = frameProperties);
            CircleFrameCutter(frameProperties = frameProperties);
        }   
    }

    if(frameType == enumFrameTypeHex)
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
    // debugEcho("SquareFrame(frameProperties)", frameProperties, true);
    // debugEcho("SquareFrame.frameDictionary", getKeyValue(frameProperties, "framedimensionproperties"), true);

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {    
        debugEcho("SquareFrame.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("SquareFrame.let.frameSize", frameSize, debugmode);
        debugEcho("SquareFrame.let.frameBoard", frameBoard, debugmode);
        debugEcho("SquareFrame.let.screwHoles", screwHoles, debugmode);

        difference()
        {
            union()
            {    
                // Box
                linear_extrude(height = frameBoard.y)
                difference()
                {
                    square(size=[frameSize.x, frameSize.y], center=true);
                    square(size=[frameSize.x - frameBoard.x, frameSize.y - frameBoard.x], center=true);
                }
            }   

            if (len(screwHoles) != undef) 
            {
                incrementHoz = frameSize.y / (screwHoles[enumScrewCount] + 1);
                debugEcho(str("module_name is ","SquareFrame()", 
                    ", frameDimension = ", frameSize, 
                    ", frameBoardDimension = ", frameBoard, 
                    ", screwHoles = ", screwHoles ), debugmode);
                // echo(width = frameDimension.x, height  = frameDimension.y, screwHoles = screwHoles);
                // echo(getActualHeight = getActualHeight(), ScrewCount  = screwHoles[enumScrewCount], incrementHoz = incrementHoz);

                for(i = [1 : screwHoles[enumScrewCount]])
                {
                    //note: p[x=>length]
                    point_sphere
                        (
                            diameter = screwHoles[enumScrew_OD], 
                            p1 = [ - (frameSize.x + frameBoard.x)/2, (i * incrementHoz - frameSize.y/2), frameBoard.y/2], 
                            p2 = [   (frameSize.x + frameBoard.x)/2, (i * incrementHoz - frameSize.y/2), frameBoard.y/2]
                        );
                }

                incrementVert = frameSize.x / (screwHoles[enumScrewCount] + 1);
                debugEcho
                    (
                        "SquareFrame().ActualHeight :", 
                        (frameSize.y + frameBoard.x),
                        debugmode);
                debugEcho
                    (
                        "SquareFrame().ScrewCount :", 
                        screwHoles[enumScrewCount],
                        debugmode);
                debugEcho
                    (
                        "SquareFrame().incrementVert :", 
                        incrementVert,
                        debugmode);                                                

                for(i = [1 : screwHoles[enumScrewCount]])
                {
                    //note: p[y=>length]
                    point_sphere
                        (
                            diameter = screwHoles[enumScrew_OD], 
                            p1 = [(i * incrementVert - frameSize.x/2), - (frameSize.y + frameBoard.x)/2, frameBoard.y/2], 
                            p2 = [(i * incrementVert - frameSize.x/2),   (frameSize.y + frameBoard.x)/2, frameBoard.y/2]
                        );                
                }
            }        
        }
    }
}

module SquareFrameCutter
(
    // frameDimension = [convert_ft2mm(1), convert_ft2mm(2)],
    // frameBoardDimension = [convert_in2mm(1), convert_in2mm(1)]
    frameProperties
)
{
        debugEcho("SquareFrameCutter(frameProperties)", frameProperties, getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug"));
    // debugEcho("SquareFrame.frameDictionary", getKeyValue(frameProperties, "framedimensionproperties"), true);

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {    
        debugEcho("SquareFrameCutter.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("SquareFrameCutter.let.frameSize", frameSize, debugmode);
        debugEcho("SquareFrameCutter.let.frameBoard", frameBoard, debugmode);
        debugEcho("SquareFrameCutter.let.screwHoles", screwHoles, debugmode);

        debugEcho(str("module_name is ","SquareFrameCutter()", 
            ", frameWidth = ", frameSize.x, 
            ", frameHeight = ", frameSize.y, 
            ", frameBoardDimension = ", frameBoard), debugmode);
        
        // echo(FrameCutter="FrameCutter", frameWidth=frameDimension.x, frameHeight=frameDimension.y, frameBoardDimension=frameBoardDimension);
        offset =  NozzleWidth/4; //values needs to be less than nozzel frameDimension.x
        translate([0, 0, -frameBoard.y])
        linear_extrude(height= 3 * frameBoard.y)
        {
            difference()
            {
                square(size = [3 * frameSize.x, 3 * frameSize.y], center = true);
                square(size = [frameSize.x + offset, frameSize.y + offset], center = true);
            }
        }   
    }

}

module CircleFrame
(
    frameProperties
)
{
    debugEcho("CircleFrame(frameProperties)", frameProperties, getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug"));

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {  
        debugEcho("CircleFrame.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("CircleFrame.let.frameSize", frameSize, debugmode);
        debugEcho("CircleFrame.let.frameBoard", frameBoard, debugmode);
        debugEcho("CircleFrame.let.screwHoles", screwHoles, debugmode);

        debugEcho(str("module_name is ","CircleFrame()", 
            ", frameRadius = ", frameSize.x, 
            ", frameBoardDimension = ", frameBoard,
            ", screwHoles = ", screwHoles
            ), debugmode);    
        // echo(CircleFrame="CircleFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);
        difference()
        {
            union()
            {
                rotate_extrude(angle = 360)
                {
                    translate([frameSize.x,0,0])
                    {
                        // echo(size = [frameBoardDimension.x, frameBoardDimension.y]);
                        square(size = [2*frameBoard.x, 2*frameBoard.y], center = true);
                    }                     
                }
            
            }     
        
            if (len(screwHoles) != undef)
            {
                echo(screwHoleCount = screwHoles[enumScrewCount], screwHoleOD = screwHoles[enumScrew_OD]);
                for(i = [1 : screwHoles[enumScrewCount]])
                {
                    rotate([90,0, i * 360/(screwHoles[enumScrewCount])])
                    cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameSize.x + frameBoard.x), center=true);
                }
            }
        }    
    }

}

module CircleFrameCutter
    (
        frameProperties
    )
{
    debugEcho("CircleFrameCutter(frameProperties)", frameProperties, getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug"));

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {  
        debugEcho("CircleFrameCutter.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("CircleFrameCutter.let.frameSize", frameSize, debugmode);
        debugEcho("CircleFrameCutter.let.frameBoard", frameBoard, debugmode);
        debugEcho("CircleFrameCutter.let.screwHoles", screwHoles, debugmode);

        debugEcho(str("module_name is ","CircleFrameCutter()", 
            ", frameRadius = ", frameSize.x, 
            ", frameBoardDimension = ", frameBoard));        
        // echo(CircleFrameCutter="CircleFrameCutter", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

        union()
        {
            translate([0,0,-frameBoard.y/2])
            rotate_extrude(angle = 360)
            {
                translate([frameSize.x + frameBoard.x/2 + 0.01,0,0])
                {
                    echo(size = frameBoard);
                    square(size = frameBoard, center = false);
                }                     
            }
        }
    }    
} 

module HexFrame
(
    frameProperties
)
{
    debugEcho("HexFrame(frameProperties)", frameProperties, getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug"));

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {  
        debugEcho("HexFrame.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("HexFrame.let.frameSize", frameSize, debugmode);
        debugEcho("HexFrame.let.frameBoard", frameBoard, debugmode);
        debugEcho("HexFrame.let.screwHoles", screwHoles, debugmode);

        debugEcho(str("module_name is ","HexFrame()", 
            ", frameRadius = ", frameSize.x, 
            ", frameBoardDimension = ", frameBoard,
            ", screwHoles = ", screwHoles
            ));   

        // echo(HexFrame="HexFrame", frameRadius=frameRadius, frameBoardDimension=frameBoardDimension);

        difference()
        {
            union()
            {
                translate([0,0,-frameBoard.y/2])
            linear_extrude(height = frameBoard.y)
                {
                    difference()
                    {
                        circle(r=frameSize.x, $fn = 6);
                        circle(r=frameSize.x - frameBoard.x, $fn = 6);
                    }                   
                }        
            }     
        
            if (len(screwHoles) != undef)
            {
                debugEcho(str("module_name is ","HexFrame()", 
                    ", screwHoleCount = ", screwHoles[enumScrewCount], 
                    ", screwHoleOD = ", screwHoles[enumScrew_OD]
                    ));               
                
                assert(screwHoles[enumScrewCount] < 4, "max value for screw holes is 3.");

                for(i = [0 : screwHoles[enumScrewCount]-1])
                {
                    // echo(info = [ 90, 0, screwAngle(i = i)]);
                    rotate([90, 0, screwAngle(i = i)])
                    cylinder(d=screwHoles[enumScrew_OD], h= 2 * (frameSize.x + frameBoard.x), center=true);
                }
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
    debugEcho("HexFrameCutter(frameProperties)", frameProperties, getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug"));

    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        debugmode = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "debug")
    )
    {  
        debugEcho("HexFrameCutter.let.frameDictionary", frameDictionary, debugmode);
        debugEcho("HexFrameCutter.let.frameSize", frameSize, debugmode);
        debugEcho("HexFrameCutter.let.frameBoard", frameBoard, debugmode);
        debugEcho("HexFrameCutter.let.screwHoles", screwHoles, debugmode);

        debugEcho(str("module_name is ","HexFrameCutter()", 
            ", frameRadius = ", frameSize.x, 
            ", frameBoardDimension = ", frameBoard
            ), debugmode);      

        union()
        {
            translate([0,0,-frameBoard.y/2])
            linear_extrude(height = frameBoard.y)
            {
                difference()
                {
                    circle(r=2 * frameSize.x, $fn = 6);
                    circle(r=frameSize.x + 0.01, $fn = 6);
                }                   
            }        
        }
    }
} 