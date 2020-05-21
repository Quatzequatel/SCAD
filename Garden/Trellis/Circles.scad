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

    LatticeProperties = 
    [
        "lattice properties",
        [
            ["width", WallThickness(count = 2)],
            ["depth", layers2Height(8)],
            ["height", 0]
        ]
    ]; 

    //[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
    CirclesTrellisData = 
        [
            "circlestrellisdata", 
            [
                ["minRadius", convert_in2mm(1)],
                ["maxRadius", 175],
                ["circleCount", 18],
                ["Seed", PI],
                LatticeProperties,
                ["debug", true]
            ]
        ];

    //Frame type Properties
    FrameProperties = 
    [
        FrameDimensionProperties,
        CirclesTrellisData 
    ];

    // CirclesTrellis(frameProperties);
    BubblesTrellis(FrameProperties);
}

module CirclesTrellis
(
    frameProperties
)
{
    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties"),
        frameSize = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frame dimension"),
        frameBoard = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "frameboard dimension"),
        screwHoles = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "screw holes"),
        featuresDictionary = getKeyValue(getKeyValue(frameProperties, "framedimensionproperties"), "trellisfeatures"),
        latticeDictionary = getKeyValue(frameProperties, "bublestrellis")
        // debugmode = getKeyValue(getKeyValue(frameProperties, "squaretrellisproperties"), "debug")
    )    
    {
        let
        (
            minRadius = getKeyValue(latticeDictionary, "minRadius"),
            maxRadius = getKeyValue(latticeDictionary, "maxRadius"),
            circleCount = getKeyValue(latticeDictionary, "circleCount"),
            Seed = getKeyValue(latticeDictionary, "Seed"),
            debugmode = getKeyValue(latticeDictionary, "debug")
        )
        {
            for( i = [minRadius : 4*frameBoard.x : maxRadius])
            {
                CircleFrame
                (
                    frameProperties = frameProperties
                );
            }            
        }
    }

}

module BubblesTrellis
    (
        frameProperties
    )
{
    DrawBubbles(frameProperties);

}

function RandomPoint(min_value = 0, max_value = 0, value_count = 4, seed = PI) = 
    rands(
            min_value = min_value, 
            max_value = max_value, 
            value_count = 4, 
            seed = seed
        );