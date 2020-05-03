/*
    Lib for construction type objects
    note put any constants in constants.scad
*/
use <convert.scad>;
use <ObjectHelpers.scad>;
use <vectorHelpers.scad>;

include <constants.scad>;

function sq(value) = value * value;
function hypotenuse(side1, side2) = sqrt(sq(side1) + sq(side2));
function insideHypotenuse(side1, side2, board) = sqrt(sq(side1 - getValue(board, enThickness)) + sq(side2 - getValue(board, enThickness)));

Board2by4 = newVector(v = [], p1 = convert_in2mm(1.5), p2 = convert_in2mm(3.5), p3 = convert_ft2mm(8));
angle = 44.3;

Build();

module Build()
{
    // House();
    polyBoardAngle(board = horizontalBoard(board = Board2by4), startlocation = [0,0,0], angle = 45, color = "green");

}

function horizontalBoard(board) = vSwitch(board, 0, 2);

module House()
{
    
    // verticalBoard(Board2by4, startlocation = [0,0,getValue(Board2by4, enThickness)], color = "blue");
    // verticalBoard(Board2by4, startlocation = [getValue(Board2by4, enLength) - getValue(Board2by4, enThickness),0,getValue(Board2by4, enThickness)], color = "blue");
    verticalBoard(Board2by4, startlocation = [0 - getValue(Board2by4, enThickness), 0, 0], color = "blue");
    verticalBoard(Board2by4, startlocation = [getValue(Board2by4, enLength) , 0, 0], color = "blue");
    HorizontalBoard(Board2by4, startlocation = [0, 0, 0], color = "red");
    HorizontalBoard(Board2by4, startlocation = [0, 0, getValue(Board2by4, enLength) + getValue(Board2by4, enThickness)], color = "red");
    HorizontalBoard(Board2by4, startlocation = [0, 0, getValue(Board2by4, enLength) -getValue(Board2by4, enThickness)  ], color = "red");
    AngleBoard
    (
        board = setValue
            (
                v = Board2by4, 
                enum = enZ, 
                value = hypotenuse
                    (
                        side1 = getValue(Board2by4, enLength) , 
                        side2 = getValue(Board2by4, enLength) 
                        // side1 = getValue(Board2by4, enLength) + (getValue(Board2by4, enThickness) * cos(angle) / 2), 
                        // side2 = getValue(Board2by4, enLength) + (getValue(Board2by4, enThickness) * sin(angle) / 2)
                    )
            ), 
        angle = -angle, 
        // location = [0, 0, 0], 
        location = [-getValue(Board2by4, enThickness) , 0, 0 ], 
        color = "yellow"
    );

    AngleBoard
    (
        board = setValue
            (
                v = Board2by4, 
                enum = enZ, 
                value = insideHypotenuse
                    (
                        side1 = getValue(Board2by4, enLength) , 
                        side2 = getValue(Board2by4, enLength) ,
                        board = Board2by4
                        // side1 = getValue(Board2by4, enLength) + (getValue(Board2by4, enThickness) * cos(angle) / 2), 
                        // side2 = getValue(Board2by4, enLength) + (getValue(Board2by4, enThickness) * sin(angle) / 2)
                    )
            ), 
        angle = angle, 
        // location = [0, 0, 0], 
        location = [-getValue(Board2by4, enThickness) , 0, getValue(Board2by4, enLength) ], 
        color = "pink"
    );
}

module verticalBoard(board, startlocation, color = "blue")
{
    polyBoard(board, startlocation, color = color );
}

module HorizontalBoard(board, startlocation, color = "red")
{

    polyBoard(board = vSwitch(board, 0, 2), startlocation, color = color );
}

module polyBoard(board, startlocation, color = "green")
{
    color(color)
    polyhedron(points = cubePoints(startlocation, board), faces = CubeFaces, convexity = 1);
}

module polyBoardAngle(board, startlocation, angle, color = "green")
{
    color(color)
    polyhedron(points = cubePointsAngle(startlocation, board, angle), faces = CubeFaces, convexity = 1);
}

// o = origin, d = dimension
function cubePoints(o, d) =
[
    [o.x, o.y, o.z],                //0
    [o.x + d.x, o.y, o.z],          //1
    [o.x + d.x, o.y + d.y, o.z],    //2
    [o.x, o.y + d.y, o.z],          //3
    [o.x, o.y, o.z + d.z],          //4
    [o.x + d.x, o.y,o.z + d.z],     //5
    [o.x + d.x, o.y + d.y, o.z + d.z], //6
    [o.x, o.y + d.y, o.z + d.z],       //7
];

// o = origin, d = dimension, a = angle
function cubePointsAngle(o, d, a) =
[
    [o.x, o.y, o.z],                //0
    [o.x + cos(a)*(d.x), o.y, o.z],          //1
    [o.x + cos(a)*(d.x), o.y + sin(a)*(d.y), o.z],    //2
    [o.x, o.y + sin(a)*(d.y), o.z],          //3
    [o.x, o.y, o.z + d.z],          //4
    [o.x + cos(a)*(d.x), o.y,o.z + d.z],     //5
    [o.x + cos(a)*(d.x), o.y + sin(a)*(d.y), o.z + d.z], //6
    [o.x, o.y + sin(a)*(d.y), o.z + d.z],       //7
];

module AngleBoard(board, angle, location, color = "yellow")
{
    echo(
        location = addValue
        (
            v = addValue
            (
                v = addValue
                    (
                        v = location, 
                        enum = enX, 
                        value = (cos(-angle) * getValue(board, enLength)/2)
                    ), 
                enum = enY, 
                value = getValue(board, enThickness)
            ),
            enum = enZ,
            value = (sin(-angle) * getValue(board, enLength)/2)
        )
        );
    translate
    (
        addValue
        (
            v = addValue
            (
                v = addValue
                    (
                        v = location, 
                        enum = enX, 
                        value = (cos(-angle) * (getValue(board, enLength) + getValue(board, enThickness) )/2)
                    ), 
                enum = enY, 
                value = getValue(board, enThickness)
            ),
            enum = enZ,
            value = (sin(-angle) * (getValue(board, enLength) + getValue(board, enThickness) ) /2)
        )
    )
    rotate([0,angle,0])
    // translate([0,0,getValue(board, enThickness)])
    rotate([0,90,0])
    color(color) 
    cube(size=board, center = true);
}

module AngleBoard2(startlocation = [0, 0, 0], board, angle, color = "pink")
{
    rotate([0,angle,0])
    // translate(startlocation])
    rotate([0,90,0])
    color(color) 
    cube(size=board, center = true);
}