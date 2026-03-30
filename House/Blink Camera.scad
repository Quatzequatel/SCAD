include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build(args = []);

module build(args) 
{
    thickness = 3;
    lip = 8;
    
    x1 = 60;
    x2= x1 + thickness;
    y1 = 46.5;
    y2 = y1 + thickness;
    y3 = 120;

    points = [
        // 0,45,
        [0,0],
        [x1,0],
        // [60,2],
        // [0,2],
        [x1,y3],
        [x2,y3],
        [x2,-thickness],
        [-thickness,-thickness],
        [-thickness,y2],
        [lip,y2],
        [lip,y1],
        [0,y1],
        // [-2,47],
        [0,0],
        ];

    linear_extrude(height=100)
    polygon(points=points);
}