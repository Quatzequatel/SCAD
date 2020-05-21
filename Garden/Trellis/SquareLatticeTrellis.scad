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
let
(
    frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
    frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
    frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
    screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
    featuresDictionary = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "trellisfeatures"),
    latticeDictionary = getKeyValue(frameProperties, "squaretrellisproperties")
    // debugmode = getKeyValue(getKeyValue(frameProperties, "squaretrellisproperties"), "debug")
)
{
    let
    (
        rows = getKeyValue(latticeDictionary, "rows"),
        columns = getKeyValue(latticeDictionary, "columns"),
        intervalWidth = getKeyValue(latticeDictionary, "hoz width"),
        verticalWidth = getKeyValue(latticeDictionary, "vert width"),
        debugmode = getKeyValue(latticeDictionary, "debug")
    )
    {
        echo(SquareLatticeTrellis_debugmode=debugmode);

        debugEcho("rows", rows, debugmode);
        debugEcho("columns", columns, debugmode);
        debugEcho("intervalWidth", intervalWidth, debugmode);
        debugEcho("verticalWidth", verticalWidth, debugmode);
    
        {
            debugEcho("SquareLatticeTrellis : frameProperties", frameProperties);
            debugEcho("SquareLatticeTrellis : latticeDictionary", latticeDictionary);
            debugEcho("IntervalCount.x", columns);
            
            intervalWidth = intervalWidth == undef ? 
                frameSize.x/ (columns + 1)
                : intervalWidth
                ;
            
            debugEcho("intervalWidth", intervalWidth);

            //vertical
            for(i = [1 : 1 : rows ])
            {
                let
                ( 
                    p1 = [ i * intervalWidth, 0, 0], 
                    p2 = [ i * intervalWidth, frameSize.y, 0]
                )
                {
                    point_square(size = getLatticeSize(latticeDictionary), p1 = p1, p2 = p2, height = getLatticeSize(latticeDictionary).y);                
                }

            }
            //horizontal
            verticalWidth = verticalWidth == undef ?
                frameSize.y / vgetIntervalCount(frameProperties).y + 1
                : verticalWidth
                ;
                
            debugEcho("IntervalCount.y", vgetIntervalCount(frameProperties).y);
            debugEcho("verticalWidth", verticalWidth);

            for(i = [0 : 1 :  columns])
            {
                let
                ( 
                    p1 = [ 0,verticalWidth + i * verticalWidth, 0], 
                    p2 = [ frameSize.x, verticalWidth + i * verticalWidth, 0]
                )
                {
                    // color("blue")
                    // point_square(size = vSwitch(getLatticeSize(latticeDictionary), 0, 1), p1 = p1, p2 = p2, height = getLatticeSize(latticeDictionary).y);                
                    point_square(size = getLatticeSize(latticeDictionary), p1 = p1, p2 = p2, height = getLatticeSize(latticeDictionary).y);                
                }
            }
        }   
    }


     
}

