include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build(args = []);

module build(args) 
{

    points = [
        // 0,45,
        [0,0],
        [60,0],
        // [60,2],
        // [0,2],
        [60,120],
        [62,120],
        [62,-2],
        [-2,-2],
        [-2,47],
        [4,47],
        [4,45],
        [0,45],
        // [-2,47],
        [0,0],
        ];

    linear_extrude(height=20)
    polygon(points=points);
}