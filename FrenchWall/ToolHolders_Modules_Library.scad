include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <../libraries/kvpairs.scad>;

/*
    Modules for drawing simple objects using key-value pair stores.
    This library uses kvpairs.scad for key-value storage and retrieval.
*/


module drawSquareShape(properties)
{
    color(kv_get(properties, "color"), 0.5)
    rotate(kv_get(properties, "rotate"))
    translate(kv_get(properties, "move"))
    //move to xy location
    // translate([kv_get(properties, "x")/2, kv_get(properties, "y")/2])
    linear_extrude(kv_get(properties, "z"))
    square(size=[kv_get(properties, "x"), kv_get(properties, "y")], center=false);
}

module drawSquareShape2(properties)
{
    // color(kv_get(properties, "color"), 0.5)
    // rotate(kv_get(properties, "rotate"))
    // translate(kv_get(properties, "move"))
    //move to xy location
    // translate([kv_get(properties, "x")/2, kv_get(properties, "y")/2])
    linear_extrude(kv_get(properties, "z"))
    square(size=[kv_get(properties, "x"), kv_get(properties, "y")], center=true);
}

/*
    draws cylinder object so edge is [0, y/2] and [x/2, 0]
*/
module drawCircleShape(properties)
{
    // color(kv_get(properties, "color"), 0.5)
    translate(kv_get(properties, "move"))
    rotate(kv_get(properties, "rotate"))
    translate([kv_get(properties, "x")/2, kv_get(properties, "y")/2])
    linear_extrude(kv_get(properties, "z"))
    circle(d=kv_get(properties, "x"), $fn = kv_get(properties, "fragments"));
}

module drawCircleShape2(properties)
{
    // color(kv_get(properties, "color"), 0.5)
    // translate(kv_get(properties, "move"))
    // rotate(kv_get(properties, "rotate"))
    // translate([kv_get(properties, "x")/2, kv_get(properties, "y")/2])
    // linear_extrude(kv_get(properties, "z"))
    circle(d=kv_get(properties, "x"), $fn = kv_get(properties, "fragments"));
}

function GetTrayCellLength(v) = 
    ( 
        kv_get(v, "x") - kv_get(v, "rows") * kv_get(v, "spacing") 
    ) 
    / 
    kv_get(v, "rows") ;
function GetTrayCellWidth(v, columns) = ( kv_get(v, "y") - kv_get(v, "columns") * kv_get(v, "spacing") )  / kv_get(v, "columns") ;

module drawArrayOfCircleShapes(array, bitInfo)
{
    properties_echo(array);
    properties_echo(bitInfo);
    rows = kv_get(array, "rows");
    columns = kv_get(array, "columns");
    xDistance = GetTrayCellLength(array);
    yDistance = GetTrayCellWidth(array);
    echo(xDistance=xDistance, yDistance=yDistance);
    translate(kv_get(array,"move"))
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

function GetDiameter(cellwidth, cellheight, spacing) = 
    (cellwidth <= cellheight) ? (cellwidth - 2*spacing) : (cellheight - 2*spacing);

function GetDelta(rowcol, diameter, spacing) = rowcol*(diameter + 2*spacing) + (diameter/2 + spacing);

module drawArrayOfCircleShapes2(rows, columns, width, height, spacing, fn = 100)
{
    cellwidth = width/rows;
    cellheight = height/columns;
    diameter = (cellwidth <= cellheight) ? (cellwidth - 2*spacing) : (cellheight - 2*spacing);
    echo(cellwidth=cellwidth, cellheight=cellheight, diameter=diameter);
    {
        union()
        {
            for (row=[0:rows-1]) 
            {
                for (col=[0:columns-1]) 
                {
                    echo(points =[GetDelta(row, diameter, spacing), GetDelta(col, diameter, spacing), 0]);
                    translate([GetDelta(row, diameter, spacing), GetDelta(col, diameter, spacing), 0])
                    circle(d=diameter, $fn = fn);
                }        
            }          
        }        
    }  
}

module draw_Cleat_for_Back_Wall(properties)
{
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([kv_get(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,0,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        //draw cleat
        translate([0, kv_get(properties,"y"), kv_get(properties,"z")])
        draw_parallelogram(kv_get(properties, "cleat"));
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

    length = kv_get(properties, "parallelogram length");
    height = kv_get(properties, "parallelogram thickness");
    angle = kv_get(properties, "angle");    
    base_length = height/tan(angle);
    hypotenuse = sqrt(pow(height, 2) + pow(base_length, 2));
    // echo(length=length, height=height, hypotenuse=hypotenuse);

    A = [ 0, 0 ];
    B = [ length, 0 ];
    C = [ length + base_length, height];
    D = [ base_length, height];

    points = [A, B, C, D];
    // echo(points = points);
    color(kv_get(properties, "color"), 0.5)

    translate([0, 0, -hypotenuse])
    rotate([angle - 90, 0, 0])
    rotate([0,90,0])
    linear_extrude(height = kv_get(properties, "extrude height"), center=false)
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
    points = [kv_get(args, "A"), kv_get(args, "B"), kv_get(args, "C"), kv_get(args, "D")];

    color(kv_get(args, "color"), 0.5)
    translate(kv_get(args, "move"))
    rotate(kv_get(args, "rotate"))

    linear_extrude(height = kv_get(args, "length"))
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
    inverted_trapizoid = kv_get(cleat_properties, "inverted trapizoid");
    length = kv_get(cleat_properties, "bottom length");
    height = kv_get(cleat_properties, "height");
    angle = kv_get(cleat, "angle");    
    base_length = height/tan(angle);

    points = trapizoid_points(length, height, base_length, inverted_trapizoid);

    echo(points = points);

    color(kv_get(cleat_properties, "color"), 0.5)

    rotate([0, 90, 0])
    rotate([0, 0, angle])
    translate([0, -height,0])
    linear_extrude(height = kv_get(cleat_properties, "extrude height"), center=false)
    polygon(points=points);    
}

//parameters are
function trapizoid_points(length, height, base_length, inverted = false) = 
    inverted==false ? 
        //[A, B, D, C]
        [ [ 0, 0 ], [ length, 0 ], [ length - base_length, height ], [ base_length, height ]  ] : 
        //for inverted [A, B, C, D]
        [ [ base_length, 0 ], [ length - base_length, 0 ], [ length, height ], [ 0, height ] ];

