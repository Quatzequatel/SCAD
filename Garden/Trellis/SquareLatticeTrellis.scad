/*

*/

include <TrellisEnums.scad>;
include <constants.scad>;
use <TrellisFunctions.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;

test();
module test()
{
    //Global Properties
    FrameBoardDimension = [WallThickness(count = 4), convertInches2mm(0.5)]; 
    FrameDimension = [convertInches2mm(12) - FrameBoardDimension.y, convertInches2mm(12) - FrameBoardDimension.y];
    LatticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    ScrewHoles = [woodScrewShankDiaN_8, 2];
    IntervalCount = [4,0];    
    Includes = setIncludeProperty
        ([], 
            frame = true, 
            diamondStyleTrellis = false, 
            squareTrellis = true, 
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

    SquareLatticeTrellis
    (
        frameProperties = frameProperties
    );
}

module SquareLatticeTrellis
    (
        frameProperties
    )
    {
        debugEcho(lable = "SquareLatticeTrellis : frameProperties", args = frameProperties);
        debugEcho(lable = "IntervalCount.x", args = vgetIntervalCount(frameProperties).x);
        
        intervalWidth = getFrameProperty(frameProperties).x/ (vgetIntervalCount(frameProperties).x + 1);
        
        debugEcho(lable = "intervalWidth", args = intervalWidth);

        //vertical
        for(i = [1 : 1 : vgetIntervalCount(frameProperties).x-1 ])
        {
            let
            ( 
                p1 = [ i * intervalWidth, 0, 0], 
                p2 = [ i * intervalWidth, getFrameProperty(frameProperties).y, 0]
            )
            {
                point_square(size = getLatticeDimension(frameProperties), p1 = p1, p2 = p2, height = getLatticeDimension(frameProperties).y);                
            }

        }
        //horizontal
        verticalWidth = getFrameProperty(frameProperties).y / vgetIntervalCount(frameProperties).y + 1;
        debugEcho(lable = "IntervalCount.y", args = vgetIntervalCount(frameProperties).y);
        debugEcho(lable = "verticalWidth", args = verticalWidth);

        for(i = [0 : 1 :  vgetIntervalCount(frameProperties).y - 1])
        {
            let
            ( 
                p1 = [ 0,verticalWidth + i * verticalWidth, 0], 
                p2 = [ getFrameProperty(frameProperties).x, verticalWidth + i * verticalWidth, 0]
            )
            {
                // color("blue")
                point_square(size = vSwitch(getLatticeDimension(frameProperties), 0, 1), p1 = p1, p2 = p2, height = getLatticeDimension(frameProperties).y);                
            }
        }
    }