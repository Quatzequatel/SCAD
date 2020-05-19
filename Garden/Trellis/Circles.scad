/*
    Generate cirles for printing to be assembled
    into a trellis.
*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <Frame.scad>;
use <convert.scad>;
use <TrellisFunctions.scad>;
use <TrigHelpers.scad>;
use <lattice.scad>;

$fn=100;

Test();

module Test() 
{
    //Global Properties
    FrameBoardDimension = [WallThickness(count = 4), convertInches2mm(0.5)]; 
    FrameDimension = [convertInches2mm(12) - FrameBoardDimension.y, convertInches2mm(12) - FrameBoardDimension.y];
    LatticeDimension = setDimension([], depth =WallThickness(count = 2), thickness = layers2Height(8)); 
    ScrewHoles = [woodScrewShankDiaN_8, 2];
    IntervalCount =2;    
    //[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
    CirclesTrellisData = [convert_in2mm(1),175, 5, PI];
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
        Includes,               //[5] enumPropertyInclude.
        CirclesTrellisData      //[6] enumPropertyTrellisSpecific
    ];

    // CirclesTrellis(frameProperties);
    BubblesTrellis(frameProperties);
}

module CirclesTrellis
    (
        frameProperties
    )
{
    for( i = [frameProperties[enumPropertyTrellisSpecific][enumCircleMinRadius] : 4*frameProperties[enumPropertyFrameBoard].x : frameProperties[enumPropertyTrellisSpecific][enumCircleMaxRadius]])
    {
        CircleFrame
        (
            frameProperties = frameProperties
        );
    }
}

module BubblesTrellis
    (
        frameProperties
    )
{
    echo(enumPropertyTrellisSpecific = frameProperties[enumPropertyTrellisSpecific]);
    for( i = [frameProperties[enumPropertyTrellisSpecific][enumCircleMinRadius] : 4*frameProperties[enumPropertyFrameBoard].x : frameProperties[enumPropertyTrellisSpecific][enumCircleMaxRadius]])
    {

        CircleLattice(frameProperties = frameProperties);
    }
}

function RandomPoint(min_value = 0, max_value = 0, value_count = 4, seed = PI) = 
    rands(
            min_value = min_value, 
            max_value = max_value, 
            value_count = 4, 
            seed = seed
        );