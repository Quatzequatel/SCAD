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
    circlesTrellisData = getKeyValue(frameProperties, "circlestrellisdata");
    // assert(circlesTrellisData == undef, str("circlestrellisdata, key not found in frameProperties"))
    echo(circlesTrellisData = circlesTrellisData);
    echo(frameProperties = frameProperties);
    points = rands2Points
        (
            v = randomVector
                (
                    3 * circlesTrellisData[enumCircleCount], 
                    circlesTrellisData[enumCircleMinRadius], 
                    circlesTrellisData[enumCircleMaxRadius], 
                    circlesTrellisData[enumCircleSeed]
                )
        );
    // echo(points = points)
    translate([-circlesTrellisData[enumCircleMaxRadius]/2, -circlesTrellisData[enumCircleMaxRadius]/2,0])
    union()
    {
        for( i = [0: 2: 2*(circlesTrellisData[enumCircleCount] - 1)])
        {
            let( diameter = Distance(p1 = [points[i].x, points[i].y], p2 = [points[i + 1].x, points[i + 1].y]))
            {
                echo(diameter= frameProperties[enumPropertyFrameBoard].x, latticeDimension = frameProperties[enumPropertyLattice]);

                translate([points[i].x, points[i].y, 0]) 
                CircleLattice
                (
                    radius = diameter/2,
                    latticeDimension = frameProperties[enumPropertyLattice]                 
                );
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
    // r = frameProperties[enumPropertyFrameBoard].x/2;
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