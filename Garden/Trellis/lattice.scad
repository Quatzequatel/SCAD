/*
 library for drawing common lattice designs.
*/
include <TrellisEnums.scad>;
include <constants.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <circles.scad>;
use <trigHelpers.scad>;
use <TrellisFunctions.scad>;

test();
module test()
{
    //Global Properties
    FrameBoardDimension = [WallThickness(count = 4), convert_in2mm(0.5)]; 
    FrameDimension = [convert_in2mm(12) - FrameBoardDimension.y, convert_in2mm(12) - FrameBoardDimension.y];

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

    LatticeDimension = setDimension([], depth = WallThickness(count = 2), thickness = layers2Height(8)); 

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

    DrawBubbles
    (
        frameProperties = FrameProperties
    );
}

module DrawBubbles
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
        // latticeDictionary = getKeyValue(frameProperties, "bublestrellis")
        latticeDictionary = getKeyValue(frameProperties, "circlestrellisdata") != undef ?
            getKeyValue(frameProperties, "circlestrellisdata") :
            getKeyValue(frameProperties, "bublestrellis")  
        // debugmode = getKeyValue(getKeyValue(frameProperties, "squaretrellisproperties"), "debug")
    )    
    {
        assert(latticeDictionary != undef, str("circlestrellisdata or bublestrellis, dictionary not found in frameProperties"));
        let
        (
            minRadius = getKeyValue(latticeDictionary, "minRadius"),
            maxRadius = getKeyValue(latticeDictionary, "maxRadius"),
            circleCount = getKeyValue(latticeDictionary, "circleCount"),
            Seed = getKeyValue(latticeDictionary, "Seed"),
            latticeDimension = getLatticeSize(latticeDictionary),
            debugmode = getKeyValue(latticeDictionary, "debug")
        )
        {
            debugEcho("minRadius", minRadius, debugmode);
            debugEcho("maxRadius", maxRadius, debugmode);
            debugEcho("circleCount", circleCount, debugmode);
            debugEcho("Seed", Seed, debugmode);

            points = rands2Points
                (
                    v = randomVector
                        (
                            3 * circleCount, 
                            minRadius, 
                            maxRadius, 
                            Seed
                        )
                );
            // echo(points = points)
            translate([-maxRadius/2, -maxRadius/2,0])
            union()
            {
                for( i = [0: 2: 2*(circleCount - 1)])
                {
                    let( diameter = Distance(p1 = [points[i].x, points[i].y], p2 = [points[i + 1].x, points[i + 1].y]))
                    {
                        debugEcho("DrawBubbles()", [["diameter", diameter], ["p1", [points[i].x, points[i].y]], ["p2", [points[i + 1].x, points[i + 1]]]], debugmode);

                        translate([points[i].x, points[i].y, 0]) 
                        CircleLattice
                        (
                            radius = diameter/2,
                            latticeDimension = latticeDimension                 
                        );
                    }
                }        
            }
        }
    }



}

module CircleLattice
(
    radius,
    latticeDimension
)
{
    rotate_extrude(angle = 360)
    {
        translate([radius, 0 , 0])
        {
            square(size = latticeDimension, center = true);
        }                     
    }
}

function rands2Points(v) = 
[
    for(i = [0 : 2 : len(v)-1]) [v[i], v[i+1]]
];

function randomVector(count, min, max, seed = PI) = rands( min, max, (count+1) * 2, seed);