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
    FrameDimension = [175, 175];

    FrameDimensionProperties = 
    [
        "framedimensionproperties",
        [
            ["frame type", enumFrameTypeHex],
            ["frame dimension", FrameDimension],
            ["frameboard dimension", FrameBoardDimension],
            ["screw holes", [woodScrewShankDiaN_4, 1]],
            ["debug", false]
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
                ["debug", false]
            ]
        ];

    //Frame type Properties
    FrameProperties = 
    [
        FrameDimensionProperties,
        CirclesTrellisData 
    ];

    CirclesTrellis(FrameProperties);
    BubblesTrellis(FrameProperties);
}

module CirclesTrellis
(
    frameProperties
)
{
    let
    (
        frameDictionary = getKeyValue(frameProperties, "framedimensionproperties")
    )
    {
        let
        (
            frameSize = getKeyValue(frameDictionary, "frame dimension"),
            frameBoard = getKeyValue(frameDictionary, "frameboard dimension"),
            screwHoles = getKeyValue(frameDictionary, "screw holes"),
            // featuresDictionary = getKeyValue(frameDictionary, "trellisfeatures"),
            latticeDictionary = getKeyValue(frameProperties, "circlestrellisdata") != undef ?
                getKeyValue(frameProperties, "circlestrellisdata") :
                getKeyValue(frameProperties, "bublestrellis")  
            // debugmode = getKeyValue(frameDictionary, "debug")
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
                    debugEcho("CirclesTrellis()", [["minRadius", minRadius], ["step size", 4*frameBoard.x],  ["maxRadius", maxRadius], ["i", i]], debugmode);
                    CircleFrame
                    (
                        frameProperties = frameProperties
                    );
                }            
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