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

Board2x4 = newVector(v = [], p1 = convert_in2mm(1.5), p2 = convert_in2mm(3.5), p3 = convert_ft2mm(8));
angle = 44.3;

Build();
isDebugMode = false;

module Build()
{
    // House();
    // Wall(
    //     wallOD = [convert_ft2mm(16), Board2x4.y, convert_in2mm(72)], 
    //     board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
    //     spacing = convert_in2mm(16),
    //     finished = true
    //     );
    Roof
    (
        roofOD = [convert_ft2mm(16), Board2x4.y, convert_in2mm(72), 45], //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = convert_in2mm(16),
        includeHeader = true,
        includeStuds = true,
        finished = true
    );

    // board = Board2x4; //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x)
    // startlocation = [0,0,0];

    // xyVerticalBoard(board = board, startlocation = startlocation, angle = 45, color = "yellow");

    // difference()
    // {
    //     xyVerticalBoard(board = board, startlocation = startlocation, color = "yellow");

    //     translate([0,board.z - board.y,0])
    //     polyhedron(points =  prismPoints(startlocation,  l = board.x + 0.1, w = board.y, h = board.y), faces = prismFaces(), convexity = 1);        
    // }

}


module House()
{
    
    // verticalBoard(Board2x4, startlocation = [0,0,getValue(Board2x4, enThickness)], color = "blue");
    // verticalBoard(Board2x4, startlocation = [getValue(Board2x4, enLength) - getValue(Board2x4, enThickness),0,getValue(Board2x4, enThickness)], color = "blue");
    verticalBoard(Board2x4, startlocation = [0 - getValue(Board2x4, enThickness), 0, 0], color = "blue");
    verticalBoard(Board2x4, startlocation = [getValue(Board2x4, enLength) , 0, 0], color = "blue");
    xyHorizontalBoard(Board2x4, startlocation = [0, 0, 0], color = "red");
    xyHorizontalBoard(Board2x4, startlocation = [0, 0, getValue(Board2x4, enLength) + getValue(Board2x4, enThickness)], color = "red");
    xyHorizontalBoard(Board2x4, startlocation = [0, 0, getValue(Board2x4, enLength) -getValue(Board2x4, enThickness)  ], color = "red");
    AngleBoard
    (
        board = setValue
            (
                v = Board2x4, 
                enum = enZ, 
                value = hypotenuse
                    (
                        side1 = getValue(Board2x4, enLength) , 
                        side2 = getValue(Board2x4, enLength) 
                        // side1 = getValue(Board2x4, enLength) + (getValue(Board2x4, enThickness) * cos(angle) / 2), 
                        // side2 = getValue(Board2x4, enLength) + (getValue(Board2x4, enThickness) * sin(angle) / 2)
                    )
            ), 
        angle = -angle, 
        // location = [0, 0, 0], 
        location = [-getValue(Board2x4, enThickness) , 0, 0 ], 
        color = "yellow"
    );

    AngleBoard
    (
        board = setValue
            (
                v = Board2x4, 
                enum = enZ, 
                value = insideHypotenuse
                    (
                        side1 = getValue(Board2x4, enLength) , 
                        side2 = getValue(Board2x4, enLength) ,
                        board = Board2x4
                        // side1 = getValue(Board2x4, enLength) + (getValue(Board2x4, enThickness) * cos(angle) / 2), 
                        // side2 = getValue(Board2x4, enLength) + (getValue(Board2x4, enThickness) * sin(angle) / 2)
                    )
            ), 
        angle = angle, 
        // location = [0, 0, 0], 
        location = [-getValue(Board2x4, enThickness) , 0, getValue(Board2x4, enLength) ], 
        color = "pink"
    );
}

/*
    visualize creating a wall frame on the ground.
    then picking it up and putting into place.
    note2self:
        z should always be 0. from origion y is the wallod.z
*/
module Wall(wallOD, board, spacing, includeStuds = true, finished = false)
{
    finishedColor = "slategray" ;
    // echo(module_name = "Wall", wallOD = wallOD, board = board, spacing = spacing);
    if(!finished)
    {
        //base
        xyHorizontalBoard(board = board, startlocation = [0,0,0], color = "red");
        //top
        xyHorizontalBoard(board = board, startlocation = [0 ,wallOD.z, 0], color = "green");
    }
    else
    {
        if(board.z != wallOD.x) echo(CAUTION = "BASE and Top board cut required. board is ", convert_mm2Inch(board.z), "but needs to be ", convert_mm2Inch(wallOD.x));
        //base
        xyHorizontalBoard(board = vSetValue(board, 2, wallOD.x), startlocation = [0,0,0], color = finishedColor);
        //top
        xyHorizontalBoard(board = vSetValue(board, 2, wallOD.x), startlocation = [0 ,wallOD.z, 0], color = finishedColor);
    }

    if(includeStuds)
    {
        if(!finished)
        {
            //studs
            for(i = [0 : 1 : wallOD.x/spacing - 1])
            {
                debugEcho(str(i = i ));
                xyVerticalBoard(board = board, startlocation = [i * spacing ,board.x, 0], color = "blue");
            }
            xyVerticalBoard(board = board, startlocation = [wallOD.x - 2*board.x ,board.x, 0], color = "yellow");
        }
        else
        {
            if(board.z != wallOD.z - board.x) echo(CAUTION = "STUD boards cut required. board is ", convert_mm2Inch(board.z), "but needs to be ", convert_mm2Inch(wallOD.z - board.x));
            //studs
            for(i = [0 : 1 : wallOD.x/spacing])
            {
                debugEcho(str(i = i ));
                xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [i * spacing ,board.x, 0], color = finishedColor);
            }
            xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [wallOD.x - board.x ,board.x, 0], color = finishedColor);
        }        
    }
}

module Roof(roofOD, board, spacing, includeHeader = true, includeFacet = true, includeStuds = true, finished = false)
{
    finishedColor = "slategray" ;
    debugEcho(str("module_name is ","Roof()", ", roofOD = ", roofOD, ", board = ", board, ", spacing = ", spacing ));
    debugEcho(str("module_name is ","Roof()", ", includeHeaders = ", includeHeader, ", includeStuds = ", includeStuds, ", finished = ", finished ));
    rotate([roofOD[3],0,0])
    if(!finished)
    {
        if (includeHeader) 
        {
            //top
            translate([0, roofOD.z - board.y , board.x * sin(roofOD[3])])
            rotate([-roofOD[3], 0, 0])
            xyHorizontalBoard(board = board, startlocation = [0 ,0, 0], color = "green");            
        }        
        
        if(includeFacet)
        {
            //base
            xyHorizontalBoard(board = board, startlocation = [0,0,0], color = "red");

        }

        if(includeStuds)
        {
            //studs
            for(i = [0 : 1 : roofOD.x/spacing - 1])
            {
                debugEcho(str("module_name is ","Roof()", ", i = ",i ));
                xyVerticalBoard(board = board, startlocation = [i * spacing ,board.x, 0], angle = roofOD[3], color = "blue");
            }
            xyVerticalBoard(board = board, startlocation = [roofOD.x - 2*board.x ,board.x, 0], angle = roofOD[3], color = "yellow");            
        }
    }
    else
    {
        if(includeHeader)
        {
            //top
            translate([0, roofOD.z - board.y , board.x * sin(roofOD[3])])
            rotate([-roofOD[3], 0, 0])
            xyHorizontalBoard(board = vSetValue(board, 2, roofOD.x), startlocation = [0,0,0], color = finishedColor);
        }
        
        if(includeFacet)
        {
            //base
            xyHorizontalBoard(board = vSetValue(board, 2, roofOD.x), startlocation = [0,0,0], color = finishedColor);
        }
        
        if(includeStuds)
        {
            //studs
            for(i = [0 : 1 : roofOD.x/spacing - 1])
            {
                xyVerticalBoard(board = vSetValue(board, 2, roofOD.z - board.x), startlocation = [i * spacing ,board.x, 0], angle = roofOD[3], color = finishedColor);
            }
            xyVerticalBoard(board = vSetValue(board, 2, roofOD.z - board.x), startlocation = [roofOD.x - board.x ,board.x, 0], angle = roofOD[3], color = finishedColor);
        }
    }

}

module xyVerticalBoard(board, startlocation, color = "blue", angle)
{
    debugEcho(str("module_name is ","xyVerticalBoard()", ", board = ", board, ", startlocation = ", startlocation, ", angle = ", angle));
    if(angle == undef)
    {
        polyBoard(board = transpose2xzy(b = board), startlocation = startlocation, color = color );
    }
    else
    {
        polyBoardAngle(board = transpose2xzy(b = board), startlocation = startlocation, angle = angle, color = color );
    }    
}

module xyHorizontalBoard(board, startlocation, color = "red", angle)
{
    debugEcho(str("module_name is ","xyHorizontalBoard()", ", board = ", board, ", startlocation = ", startlocation));
    // polyBoard(board = transpose2zxy(b = board), startlocation = startlocation, color = color );
    if(angle == undef)
    {
        polyBoard(board = transpose2zxy(b = board), startlocation = startlocation, color = color );
    }
    else
    {
        rotate([angle,0,0])
        polyBoardAngle(board = transpose2zxy(b = board), startlocation = startlocation, angle = angle, color = color );
    }
}

//[2,4,72] board drawn [72,2,4] in xy plane horizontal
function transpose2zxy(b) = [b.z, b.x, b.y];
//[2,4,72] board drawn [2,72,4] in xy plane vertical
function transpose2xzy(b) = [b.x, b.z, b.y];

module polyBoard(board, startlocation, color = "green")
{
    debugEcho(str(module_name = "polyBoard", startlocation = startlocation, board = board, cubePoints = cubePoints(o = startlocation, d = board)));
    color(color)
    polyhedron(points = cubePoints(o = startlocation, d = board), faces = cubeFaces(), convexity = 1);
}

module polyBoardAngle(board, startlocation, angle, color = "green")
{
    debugEcho(str("module is = polyBoardAngle() ", ", startlocation = ", startlocation, 
            ", board = ", board, ",  cubePoints = ", cubePoints(o = startlocation, d = board)));
    color(color)
    difference()
    {
        polyhedron(points =  cubePoints(o = startlocation, d = board), faces = cubeFaces(), convexity = 1);

        translate([-0.5,board.y - board.z,0])
        polyhedron(points =  prismPoints(startlocation,  l = board.x + 1, w = board.z + 1, h = tan(angle) * board.z), faces = prismFaces(), convexity = 1);       
    }

}

// o = origin, d = dimension
function cubePoints(o, d) = //echo(function_name = "cubePoints", o=o, d=d)
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

function prismPoints(o, l, w, h) =
[
    o, 
    [o.x + l, o.y, o.z], 
    [o.x + l, o.y + w, o.z], 
    [o.x, o.y + w, o.z], 
    [o.x, o.y + w,  o.z + h], 
    [o.x + l, o.y + w,  o.z + h]
];

function prismFaces() = 
[
    [0,1,2,3],
    [5,4,3,2],
    [0,4,5,1],
    [0,3,4],
    [5,2,1]
];

function cubeFaces() = 
[
    [0,1,2,3],  //bottom
    [4,5,1,0], //front
    [7,6,5,4], //top
    [5,6,2,1], //right
    [6,7,3,2], //back
    [7,4,0,3], //left
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