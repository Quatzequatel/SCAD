
/*
 library for drawing common lattice designs.
*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <Frame.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <circles.scad>;
use <trigHelpers.scad>;
use <TrellisFunctions.scad>;
use <Maze.scad>;

FrameType = enumFrameTypeSquare;
FrameDimension = [300,300];
FrameBoardDimension = [WallThickness(count = 12), convert_in2mm(0.5)];
LatticeDimension = [WallThickness(count = 3), layers2Height(8)];
ScrewHoles = [woodScrewShankDiaN_8, 2]; //diameter, count/side.

test();
module test(showFrame = true)
{
    MazeLattice
    (
        frameType = enumFrameTypeCircle,
        frameDimension = FrameDimension,
        frameBoardDimension = FrameBoardDimension,
        latticeDimension = LatticeDimension,
        screwHoles = ScrewHoles,
        showFrame = showFrame
    );
}

module MazeLattice
(
    frameType,
    frameDimension,
    frameBoardDimension,
    latticeDimension,
    screwHoles,
    showFrame = false
)
{
    echo(frameType = frameType, showFrame = showFrame);

    difference()
    {
        union()
        {
           if(showFrame)
            {
                if(frameType == enumFrameTypeSquare)
                {
                    echo(frameType = "enumFrameTypeSquare", frameBoardDimension=frameBoardDimension);

                    SquareFrame
                    (
                        frameDimension = frameDimension,
                        frameBoardDimension = FrameBoardDimension,
                        screwHoles = ScrewHoles
                    );
                }

                if(frameType == enumFrameTypeCircle)
                {
                    echo(frameType = "enumFrameTypeCircle", frameBoardDimension=frameBoardDimension);

                    translate([0,0, frameBoardDimension.y/2])
                    CircleFrame
                    (
                        frameRadius = frameDimension.x,
                        frameBoardDimension = frameBoardDimension,
                        screwHoles = screwHoles
                    );
                }

                if(frameType == enumFrameTypeHex)
                {
                    echo(frameType = "enumFrameTypeHex", frameBoardDimension=frameBoardDimension);

                    translate([0,0, frameBoardDimension.y/2])
                    HexFrame
                    (
                        frameRadius = frameDimension.x,
                        frameBoardDimension = frameBoardDimension,
                        screwHoles = screwHoles
                    );
                }                                
            }

            translate([-frameDimension.x/2, -frameDimension.y/2, 0])
            linear_extrude(height = latticeDimension.y)
            DrawMazeFrame
                (
                    frameDimension = frameDimension, 
                    frameBoardDimension = frameBoardDimension, 
                    latticeDimension = latticeDimension
                );
        }

        if(showFrame)
        {
            if(FrameType == enumFrameTypeSquare)
            {
                SquareFrameCutter
                    (
                        frameDimension = frameDimension, 
                        frameBoardDimension = frameBoardDimension
                    );
            }
            
            if(frameType == enumFrameTypeCircle)
            {
                CircleFrameCutter
                (
                            frameRadius = frameDimension.x,
                            frameBoardDimension = frameBoardDimension
                ) ;
            }

            if(frameType == enumFrameTypeHex)
            {
                HexFrameCutter
                (
                            frameRadius = frameDimension.x,
                            frameBoardDimension = frameBoardDimension
                ) ;
            } 
        }
    }
}