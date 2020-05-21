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
    LatticeDimension = setDimension([], depth = WallThickness(count = 2), thickness = layers2Height(8)); 
    ScrewHoles = [woodScrewShankDiaN_8, 2];
    IntervalCount =2;    
    //[minframeRadius, maxframeRadius, enumCircleCount, enumCircleSeed]
    CirclesTrellisData = ["circlestrellisdata", [convert_in2mm(1),175, 8, PI]];
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

    // CircleLattice(frameProperties = frameProperties );
    DrawBubbles
    (
        frameProperties = frameProperties        
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
        assert(circlesTrellisData != undef, str("circlestrellisdata or bublestrellis, dictionary not found in frameProperties"));
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
                        echo(diameter= frameBoard.x, latticeDimension = latticeDimension);

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
    // debugEcho("lattice.scad::CircleLattice(inputs)", [radius, latticeDimension]);
    // r = frameBoard.x/2;
    // circlesTrellisData = getKeyValue(frameProperties, "circlestrellisdata");
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