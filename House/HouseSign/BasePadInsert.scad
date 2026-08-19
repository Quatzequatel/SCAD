include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;


StorePoints =
[
    ["description", "dimension properties for tool tray"],
    ["9", [105.8, 45.63]],
    ["2", [106.8, 45.63]],
    ["6", [105.8, 45.63]],
    ["1", [76.5, 45.63]],
    ["start", [19.6, 45.63]],
    ["end", [14.6, 45.63]]
];

    points9 = 
    [
        [54, 22.5],
        [-52, 22.5],
        [-52, -22.5],
        [54, -22.5],        
    ];

build("6");

module build(args) 
{
    rotate([0, 0, 0])
    union()
    {
        translate([1, 0, -3])
        linear_extrude(height=3, center=true, convexity=10)
        square([kv_get(StorePoints, args).x + 5, kv_get(StorePoints, args).y + 5], center=true);

        translate([1, 0, 0])
        linear_extrude(height=3, center=true, convexity=10, scale=[0.97, 1.0])
        square(kv_get(StorePoints, args), center=true);

    }

}