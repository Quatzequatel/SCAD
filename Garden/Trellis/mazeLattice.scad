
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
FrameBoardDimension = [WallThickness(count = 8), convert_in2mm(0.5)];
LatticeDimension = [WallThickness(count = 3), layers2Height(8)];
ScrewHoles = [woodScrewShankDiaN_8, 2]; //diameter, count/side.
// Diameter = 2;
// Points = [[0,0]];
// Panels = [1,2];

test();
module test(showFrame = true)
{
    difference()
    {
        union()
        {
           if(showFrame)
            {
                if(FrameType == enumFrameTypeSquare)
                {
                    SquareFrame
                    (
                        frameDimension = FrameDimension,
                        frameBoardDimension = FrameBoardDimension,
                        screwHoles = ScrewHoles
                    );
                }
            }

            //translate([FrameBoardDimension.x - FrameDimension.x/2, FrameBoardDimension.x - FrameDimension.y/2, 0])
            translate([-FrameDimension.x/2, -FrameDimension.y/2, 0])
            linear_extrude(height = LatticeDimension.y)
            DrawMazeFrame(frameDimension = FrameDimension, frameBoardDimension = FrameBoardDimension, latticeDimension = LatticeDimension);
        }

        if(showFrame)
        {
                if(FrameType == enumFrameTypeSquare)
                {
                    SquareFrameCutter(frameDimension = FrameDimension, frameBoardDimension = FrameBoardDimension);
                }
        }
    }
 
}