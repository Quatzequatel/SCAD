
/*
 library for drawing common lattice designs.
*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <TrellisFunctions.scad>;
use <Frame.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <circles.scad>;
use <trigHelpers.scad>;
use <TrellisFunctions.scad>;
use <Maze.scad>;

ShowFrame = true;

test();
module test(showFrame = true)
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

    MazeLattice
    (
        frameProperties = frameProperties,
        showFrame = showFrame
    );
}

module MazeLattice
(
    frameProperties, 
    showFrame = false
)
{
    echo(frameType = frameProperties[enumPropertyInclude][enumincludeFrameType], showFrame = showFrame);

    difference()
    {
        union()
        {
           if(showFrame)
            {
                if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeSquare)
                {
                    echo(frameType = "enumFrameTypeSquare", frameBoardDimension=frameProperties[enumPropertyFrameBoard]);

                    SquareFrame
                    (
                        frameProperties = frameProperties
                    );
                }

                if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeCircle)
                {
                    echo(frameType = "enumFrameTypeCircle", frameBoardDimension=frameProperties[enumPropertyFrameBoard]);

                    translate([0,0, frameProperties[enumPropertyFrameBoard].y/2])
                    CircleFrame
                    (
                        frameProperties = frameProperties
                    );
                }

                if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeHex)
                {
                    echo(frameType = "enumFrameTypeHex", frameBoardDimension=frameProperties[enumPropertyFrameBoard]);

                    translate([0,0, frameProperties[enumPropertyFrameBoard].y/2])
                    HexFrame
                    (
                        frameProperties = frameProperties
                    );
                }                                
            }

            translate([-frameProperties[enumPropertyFrame].x/2, -frameProperties[enumPropertyFrame].y/2, 0])
            linear_extrude(height = frameProperties[enumPropertyLattice].y)
            DrawMazeFrame
                (
                    frameProperties = frameProperties
                );
        }

        if(showFrame)
        {
            if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeSquare)
            {
                SquareFrameCutter
                    (
                        frameProperties = frameProperties
                    );
            }
            
            if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeCircle)
            {
                CircleFrameCutter
                (
                    frameProperties = frameProperties
                ) ;
            }

            if(frameProperties[enumPropertyInclude][enumincludeFrameType] == enumFrameTypeHex)
            {
                HexFrameCutter
                (
                    frameProperties = frameProperties
                ) ;
            } 
        }
    }
}