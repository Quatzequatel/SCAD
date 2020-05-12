/*
    Generate cirles for printing to be assembled
    into a trellis.
*/
include <constants.scad>;
use <vectorHelpers.scad>;
use <shapesByPoints.scad>;
use <Frame.scad>;
use <convert.scad>;
use <TrellisFunctions.scad>;
$fn=100;

CirclesTrellis();

module CirclesTrellis
    (
        minframeRadius = convert_in2mm(1),
        maxframeRadius = 175,
        frameBoardDimension = [WallThickness(count = 4), convert_in2mm(0.5)]
    )
{
    for( i = [minframeRadius : 4*frameBoardDimension.x : maxframeRadius])
    {
        CircleFrame
        (
            frameRadius = i,
            frameBoardDimension = frameBoardDimension,
            screwHoles = [5, 8]
        );
    }
}