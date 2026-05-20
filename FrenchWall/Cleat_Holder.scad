include <constants.scad>;

use <kvpairs.scad>;
use <convert.scad>;

Cleat_Bracket_Store =  
[
    ["description", "dimension properties for cleat seperator"],
    // ["Cleat_seperator_width", convert_in2mm(5)],
    ["Cleat_seperator_depth", 10],
    ["Bracket_edge_to_cleat_width", convert_in2mm(0.25)],
    ["Cleat_depth", 7.5],
    ["Cleat_width", 14],
    ["Space_between_cleats_width", 30],
    ["linear_extrude_height", 15],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]    
];

echo(Cleat_Bracket_Store = Cleat_Bracket_Store);
Draw_Cleat_Bracket(Cleat_Bracket_Store);

/*
    width properties are on the x-axis and depth properties are on the y-axis.
*/
module Draw_Cleat_Bracket(properties = Cleat_Bracket_Store)
{
    A = kv_get(properties, "Bracket_edge_to_cleat_width");
    B = A + kv_get(properties, "Cleat_width");
    C = B + kv_get(properties, "Space_between_cleats_width");
    D = C + kv_get(properties, "Cleat_width");
    E = D + A;  // E is total width of cleat seperator.                 
    F = kv_get(properties, "Cleat_depth"); // F is depth of trench for cleat. 
    G = kv_get(properties, "Cleat_seperator_depth"); // G is depth of seperator.

    nimb_diameter = 1;
    fn = 30;

    points = 
    [
        [0, 0],
        [A, 0],
        [A, F],
        [B, F],
        [B, 0],
        [C, 0],
        [C, F],
        [D, F],
        [D, 0],
        [E, 0],
        [E, G],
        [0, G]
    ];

    linear_extrude(height = kv_get(properties, "linear_extrude_height"), center = false, convexity = 10)
    union()
    {
        polygon(points);

        translate([A, 0, 0]) 
        circle(d=nimb_diameter, $fn=fn);

        translate([B, 0, 0]) 
        circle(d=nimb_diameter, $fn=fn);

        translate([C, 0, 0]) 
        circle(d=nimb_diameter, $fn=fn);

        translate([D, 0, 0]) 
        circle(d=nimb_diameter, $fn=fn);
    }

}
    