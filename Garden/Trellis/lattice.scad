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

test();
module test()
{
    // CircleLattice(diameter= 40, latticeDimension = [2, 2]);
    BubblesTrellis
    (
        minframeRadius = convert_in2mm(1),
        maxframeRadius = 175,
        latticeDimension = [4, convert_in2mm(0.5)],
        count =5,
        seed = PI        
    );
}

module BubblesTrellis
(
    minframeRadius = convert_in2mm(1),
    maxframeRadius = 175,
    latticeDimension = [4, convert_in2mm(0.5)],
    count = 5,
    seed = PI
)
{
    points = rands2Points(v = randomVector(3 * count, minframeRadius, maxframeRadius, seed));
    echo(points = points)
    translate([-maxframeRadius/2, -maxframeRadius/2,0])
    union()
    {
        for( i = [0: 2: 2*(count - 1)])
        {
            let( diameter = Distance(p1 = [points[i].x, points[i].y], p2 = [points[i + 1].x, points[i + 1].y]))
            {
                echo(diameter= diameter, latticeDimension = latticeDimension);
                // translate(AddPoints([-maxframeRadius/2, -maxframeRadius/2], [points[i].x, points[i].y]))
                translate([points[i].x, points[i].y, 0]) 
                CircleLattice(diameter= diameter, latticeDimension = latticeDimension);
            }
        }        
    }

}

module CircleLattice
(
    diameter = 20,
    latticeDimension = [2, 4]
)
{
    r = diameter/2;
    rotate_extrude(angle = 360)
    {
        translate([r,0,0])
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