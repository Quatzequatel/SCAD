include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

/*
    Modules for drawing simple objects,
    usally from dictionaries (maps)
*/


module drawSquareShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    //move to xy location
    // translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);
}

/*
    draws cylinder object so edge is [0, y/2] and [x/2, 0]
*/
module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "move"))
    rotate(gdv(properties, "rotate"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}

function GetTrayCellLength(v) = ( gdv(v, "x") - gdv(v, "rows") * gdv(v, "spacing") ) / gdv(v, "rows") ;
function GetTrayCellWidth(v, columns) = ( gdv(v, "y") - gdv(v, "columns") * gdv(v, "spacing") )  / gdv(v, "columns") ;

module drawArrayOfCircleShapes(array, bitInfo)
{
    properties_echo(array);
    properties_echo(bitInfo);
    rows = gdv(array, "rows");
    columns = gdv(array, "columns");
    xDistance = GetTrayCellLength(array);
    yDistance = GetTrayCellWidth(array);
    echo(xDistance=xDistance, yDistance=yDistance);
    translate(gdv(array,"move"))
    {
        union()
        {
            for (row=[0:rows-1]) 
            {
                for (col=[0:columns-1]) 
                {
                    echo(ponits =[row * xDistance, col * yDistance, 0]);
                    translate([row * xDistance, col * yDistance, 0])
                    drawCircleShape(bitInfo);
                }        
            }          
        }        
    }  
}

///
/// Draw parallelogram from dictionary values
///
/*
    Dictionary template
    
    cleat = 
    ["cleat values", 
        ["x", gdv(tray, "x")],
        ["y", NozzleWidth * 8],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75) ],
        ["parallelogram thickness", NozzleWidth * 8],
        ["angle", 135],
        ["extrude height", gdv(tray, "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];
*/
module draw_parallelogram(properties)
{
    /* visual
    
       D----------C
    A----------B

    height distance between lines AB and CD
    angle is angle of AB and AD
    baselength is where point D intersects line AB.
    */
    // properties_echo(properties);

    length = gdv(properties, "parallelogram length");
    height = gdv(properties, "parallelogram thickness");
    angle = gdv(properties, "angle");    
    base_length = height/tan(angle);
    hypotenuse = sqrt(pow(height, 2) + pow(base_length, 2));
    // echo(length=length, height=height, hypotenuse=hypotenuse);

    A = [ 0, 0 ];
    B = [ length, 0 ];
    C = [ length + base_length, height];
    D = [ base_length, height];

    points = [A, B, C, D];
    // echo(points = points);
    color(gdv(properties, "color"), 0.5)

    translate([0, 0, -hypotenuse])
    rotate([angle - 90, 0, 0])
    rotate([0,90,0])
    linear_extrude(height = gdv(properties, "extrude height"), center=false)
    polygon(points=points); 
}

/*
    first draws a 2D polygon from points [A,B,C,D].
    A is assumed to be [0,0], then B,C,D is counter-clockwise order,
    A to B to C to D to A
    then extrudes to height
*/
module draw_simple_4sided_polyhedron(args) 
{
    // properties_echo(args=args);
    points = [gdv(args, "A"), gdv(args, "B"), gdv(args, "C"), gdv(args, "D")];

    color(gdv(args, "color"), 0.5)
    translate(gdv(args, "move"))
    rotate(gdv(args, "rotate"))

    linear_extrude(height = gdv(args, "length"))
    polygon(points=points);    

}

module draw_trapizoid(cleat_properties)
{
    /*
    A is point origin point [0,0]
    B is point length of bottom from origin [length, 0]
    x is length of triangle side at the bottom of trapizoid. Where
    2x + length of top = length of bottom
    C is point of top [x, h]
    D is last point [length - x, h]
    points visually:
                C   D
              A       B
    */
    properties_echo(cleat_properties);
    inverted_trapizoid = gdv(cleat_properties, "inverted trapizoid");
    length = gdv(cleat_properties, "bottom length");
    height = gdv(cleat_properties, "height");
    angle = gdv(cleat, "angle");    
    base_length = height/tan(angle);

    points = trapizoid_points(length, height, base_length, inverted_trapizoid);

    echo(points = points);

    color(gdv(cleat_properties, "color"), 0.5)

    rotate([0, 90, 0])
    rotate([0, 0, angle])
    translate([0, -height,0])
    linear_extrude(height = gdv(cleat_properties, "extrude height"), center=false)
    polygon(points=points);    
}

//parameters are
function trapizoid_points(length, height, base_length, inverted = false) = 
    inverted==false ? 
        //[A, B, D, C]
        [ [ 0, 0 ], [ length, 0 ], [ length - base_length, height ], [ base_length, height ]  ] : 
        //for inverted [A, B, C, D]
        [ [ base_length, 0 ], [ length - base_length, 0 ], [ length, height ], [ 0, height ] ];

