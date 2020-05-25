/*

*/

include <constants.scad>;
use <vectorHelpers.scad>;
use <TrigHelpers.scad>;
use <shapesByPoints.scad>;
use <polyline2d.scad>;
$fn = 100;

build();


module build() 
{
    anglebracket
        (
            angle = 35, 
            len1 = 2 * mmPerInch, 
            len2 = 2 * mmPerInch, 
            thickness = 5, 
            width = 2.5 * mmPerInch
        );
}

module anglebracket(angle, len1, len2, thickness, width)
{
    let
        ( 
            points = pointsAngleBracket(angle, len1, len2), 
            topPoints = 
                vvAddToAxis
                    (
                        v = pointsAngleBracket(angle, len1, len2), 
                        axis = 2,  //z
                        value = width
                    )
        )
    {
        let(
            midpoint = midpoint(points[1], topPoints[0]),
            focusPoint = midpoint(points[0], topPoints[2])
            )
        {
            // echo(midpoint = midpoint, focusPoint = focusPoint);
            debugEcho
            (   
                lable = "anglebracket [angle, len1, len2, thickness, width, midpoint, points, topPoints]", 
                args = 
                [
                    angle, len1, len2, thickness, width, midpoint, points, topPoints
                ]
                // ,mode = true
            );
            difference()
            {
                linear_extrude(height = width)
                {
                    polyline2d
                        (
                            points = points, 
                            width = thickness,
                            endingStyle = "CAP_ROUND"
                        );   
                }        

                union()
                {
                    for (i=[0:2:2]) 
                    {
                        let(midpoint = midpoint(points[1], topPoints[i]))
                        {
                            // # screwhole(point1 = points[1], point2=topPoints[i], length = width) ; 
                            if(i == 0)
                            {
                                #point_sphere
                                ( 
                                    diameter = woodScrewShankDiaN_8,
                                    p1 = Add2Y(midpoint, thickness), 
                                    p2 = Add2Y(midpoint, -thickness)
                                );     
                            }   
                            else
                            {
                                #point_sphere
                                ( 
                                    diameter = woodScrewShankDiaN_8,
                                    p1 = Add2Y(midpoint, thickness), 
                                    p2 = directionPoint(p=midpoint, angle=-angle, length=2*thickness)
                                );     
                            }                                                
                        }
                    }                                  
                }
            }        
        }        
    }
}

module screwhole(point1, point2, length) 
{
    let
    (
        midpoint = midpoint(point1, point2)
    )
    {
        point_sphere
            (
                diameter = woodScrewShankDiaN_8, 
                p1 =vAddToAxis(midpoint, 1, -length), 
                p2 =vAddToAxis(midpoint, 1, length)
            );        
    }
}

function pointsAngleBracket(angle, len1, len2) = 
[
    [-len1,0,0],
    [0,0,0],
    [cos(angle) * len2, sin(angle) * len2,0]
];
