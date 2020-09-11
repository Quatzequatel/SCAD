/*
    Lib for construction type objects
    note put any constants in constants.scad
*/
use <convert.scad>;
use <ObjectHelpers.scad>;
use <vectorHelpers.scad>;
use <TrigHelpers.scad>;
use <ShapesByPoints.scad>;

include <constants.scad>;


function sq(value) = value * value;
function hypotenuse(side1, side2) = sqrt(sq(side1) + sq(side2));
function insideHypotenuse(side1, side2, board) = sqrt(sq(side1 - getValue(board, enThickness)) + sq(side2 - getValue(board, enThickness)));
CONSTRUCTION_DEBUG_ECHO = false;
polyBoardAngle_DEBUG = true;
ROOF_DEBUG = true;
//orientation  origin i

function frame(p0, h, l, board) = 
let( tp0 = Add2Z(p0, h)) echo(tp0 = tp0, p0 = p0, h = h, l = l, board = board)
let
    (
        flatBoard = [board.y, board.x],
        result = 
        [
            ["bottom", [getCenter(p0, flatBoard), getCenter([p0.x + l, p0.y, p0.z], flatBoard)]],
            ["left", [getCenter([p0.x, p0.y, p0.z + board.x], flatBoard), getCenter([p0.x, p0.y, p0.z + h], flatBoard)]],
            ["top",  [getCenter(p0, flatBoard), getCenter([p0.x + l, p0.y, p0.z], flatBoard)]],
            ["right", [tp0, Add2X(tp0, l - board.x)]]
        ]
    )
    let( foo = fargsEcho("frame()=>", result) )
result;

module drawFrame(p0, h, l, board)
{
    let(pointCollection = frame(p0, h, l, board))
    {
        // echo(section = pointCollection[i].x, p0=pointCollection[i].y.x, p1 = pointCollection[i].y.y);
        // for(i = [0: len(pointCollection)-1])
        for(i = [0: 1])
        {
            echo(section = pointCollection[i].x, p0=pointCollection[i].y.x, p1 = pointCollection[i].y.y);
            let
            (
                section = pointCollection[i].x, 
                pstart = pointCollection[i].y.x, 
                pend = pointCollection[i].y.y
            )
            {
                echo(section = section, mod = i % 2, pstart=pstart, pend = pend); 
                if(section == "bottom")
                {
                    point_square1(size = [board.y,board.y], p1 = pstart, p2 = pend, height = board.x);
                }
                else
                {
                    point_square1(size = board, p1 = pstart, p2 = pend, height = board.y);   
                    // !point_square(size = board, p1 = pstart, p2 = pend, height = board.y, center = true) ;               
                }
            
            }

        }
    }
}

function getCenter(p0, board) = 
let( foo = fargsEcho("getCenter([0]=p0, [1]=board", [p0, board]))
let(result = vSetValue(AddPoints(p1 = p0, p2 = midpoint( p1 =p0 , p2 = [board.x, board.y, p0.z] )), 2, p0.z))
result;

Board2x4 = newVector(v = [], p1 = convert_in2mm(1.5), p2 = convert_in2mm(3.5), p3 = convert_ft2mm(8));
angle = 44.3;

// Build();
isDebugMode = false;

module Build()
{
    // House();
    rotate([90, 0, 90])
    Wall(
        wallOD = [convert_ft2mm(16), Board2x4.y, convert_in2mm(72)], 
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = convert_in2mm(16),
        finished = true,
        ascending = true
        );

    translate([8* Board2x4.y, 0,0])
    rotate([90, 0, 90])
    Wall(
        wallOD = [convert_ft2mm(16), Board2x4.y, convert_in2mm(72)], 
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = convert_in2mm(16),
        finished = true,
        ascending = false
        );
    // Roof
    // (
    //     roofOD = [convert_ft2mm(16), Board2x4.y, convert_in2mm(72), 45], //[x,y,z,angle]
    //     board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
    //     spacing = convert_in2mm(16),
    //     includeHeader = true,
    //     includeStuds = true,
    //     finished = true, 
    //     ascending = false
    // );

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
module Wall(wallOD, board, spacing, includeStuds = true, finished = false, ascending = true)
{
    // echo(str("Wall()", parseArgsToString(args)));
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
            for(i = ascending == true ? [0 : 1 : wallOD.x/spacing - 1] : [wallOD.x/spacing - 1 : -1 : 0] )
            {
                debugEcho(str(i = i ));
                xyVerticalBoard(board = board, startlocation = [i * spacing ,board.x, 0], color = ascending ? "blue" : "skyblue" );
            }
            
            if(ascending)
            {
                // xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [wallOD.x - board.x ,board.x, 0], color = finishedColor);
                xyVerticalBoard(board = board, startlocation = [wallOD.x - 2*board.x , board.x, 0], color = "yellow");
            }
            else
            {
                xyVerticalBoard(board = board, startlocation = [0 , board.x, 0], color = "yellow");
            }            
        }
        else
        {
            if(board.z != wallOD.z - board.x) echo(CAUTION = "STUD boards cut required. board is ", convert_mm2Inch(board.z), "but needs to be ", convert_mm2Inch(wallOD.z - board.x));
            //studs
            for(i = ascending == true ? [0 : 1 : wallOD.x/spacing] : [wallOD.x/spacing - 1 : -1 : 0] )
            {
                debugEcho(str(i = i ));
                xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [i * spacing ,board.x, 0], color = ascending ? finishedColor : "skyblue");
            }
            if(ascending)
            {
                xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [wallOD.x - board.x ,board.x, 0], color = finishedColor );
            }
            else
            {
                xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [wallOD.x - board.x ,board.x, 0], color = finishedColor );
                xyVerticalBoard(board = vSetValue(board, 2, wallOD.z - board.x), startlocation = [0 ,board.x, 0],  color = ascending ? finishedColor : "yellow");
            }
            
        }        
    }
}

module Roof(roofOD, board, spacing, includeHeader = true, includeFacet = true, includeStuds = true, finished = false, ascending = true)
{
    finishedColor = "slategray" ;
    debugEcho("Roof([0]=House.y, [1]=house.x, [2]=height, [3]=RoofAngle)", roofOD, CONSTRUCTION_DEBUG_ECHO || ROOF_DEBUG);
    debugEcho("Roof([0]=roofOD.in, [1]=board.in, [2]=spacing.in)", [convertV_mm2Inch(roofOD), convertV_mm2Inch(board), convert_mm2Inch(spacing)], CONSTRUCTION_DEBUG_ECHO || ROOF_DEBUG);
    debugEcho("Roof([0]=includeHeader, [1]=includeFacet, [2]=includeStuds, [3]=finished)", [includeHeader, includeFacet, includeStuds, finished], CONSTRUCTION_DEBUG_ECHO || ROOF_DEBUG);
    let(pitch = roofOD[3])
    let(roofHeight = Height(x=roofOD.x/2, angle = pitch))
    rotate([pitch,0,0])
    {    
        union()
        {
            if (includeHeader) 
            {
                //top
                translate([0, roofOD.z - board.y , roofHeight])
                rotate([-pitch, 0, 0])
                if(finished)
                {
                    xyHorizontalBoard(board = vSetValue(board, enZ, roofOD.x), startlocation = [0,0,0], color = finishedColor);
                }
                else
                {
                    xyHorizontalBoard(board = board, startlocation = [0 ,0, 0], color = "green");  
                }                      
            }        
            
            if(includeFacet)
            {
                //base
                if(finished)
                {
                    xyHorizontalBoard(board = vSetValue(board, enZ, roofOD.x), startlocation = [0,0,0], color = finishedColor);
                }
                else
                {
                    xyHorizontalBoard(board = board, startlocation = [0,0,0], color = "red");
                }            
            }

            if(includeStuds)
            {
                //studs
                if(finished)
                {
                    for(i = ascending == true ? [0 : 1 : roofOD.x/spacing - 1] : [roofOD.x/spacing - 1 : -1 : 0] )
                    {
                        xyVerticalBoard(board = vSetValue(board, enZ, roofOD.z - board.x), startlocation = [i * spacing ,board.x, 0], angle = roofOD[3], color = finishedColor);
                    }
                    xyVerticalBoard(board = vSetValue(board, enZ, roofOD.z - board.x), startlocation = [roofOD.x - board.x ,board.x, 0], angle = roofOD[3], color = finishedColor);
                }
                else
                {
                    let(stop = roofOD.x/spacing - 1, thecolor = !finished ? "blue" : finishedColor)
                    for(i = ascending == true ? [0 : 1 : stop] : [stop : -1 : 0] )
                    {
                        // debugEcho(str("module_name is ","Roof()", ", i = ",i ));
                        xyVerticalBoard(board = board, startlocation = [i * spacing ,board.x, 0], angle = pitch, color = i == 0 ? "yellow" :thecolor);
                    }
                    xyVerticalBoard(board = board, startlocation = [roofOD.x - 1*board.x ,board.x, 0], angle = pitch, color = "yellow");                 
                }
                        
            }
        }
    }
}

module xyVerticalBoard(board, startlocation, color = "blue", angle)
{
    debugEcho("xyVerticalBoard([0]=board, [1]=startlocation, [2]=color, [3]=angle)",[board, startlocation, color, angle], CONSTRUCTION_DEBUG_ECHO);
    if(angle == undef)
    {
        polyBoard(board = transpose2xzy(b = board), startlocation = startlocation, color = color );
    }
    else
    {
        debugEcho("xyVerticalBoard([0]=board, [1]=startlocation, [2]=color, [3]=angle)",[board, startlocation, color, angle], CONSTRUCTION_DEBUG_ECHO);
        polyBoardAngle(board = transpose2xzy(b = board), startlocation = startlocation, angle = angle, color = color );
    }    
}

module xyHorizontalBoard(board, startlocation, color = "red", angle)
{
    debugEcho("xyHorizontalBoard([0]=board, [1]=startlocation, [2]=color, [3]=angle)", [board, startlocation, color, angle], CONSTRUCTION_DEBUG_ECHO);
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
    debugEcho("polyBoardAngle([0]=board, [1]=startlocation, [2]=color, [3]=angle)", [board, startlocation, color, angle], CONSTRUCTION_DEBUG_ECHO || polyBoardAngle_DEBUG);
    // debugEcho(str("module is = polyBoardAngle() ", ", startlocation = ", startlocation, 
    //         ", board = ", board, ",  cubePoints = ", cubePoints(o = startlocation, d = board)));
    color(color)
    difference()
    {
        polyhedron(points =  cubePoints(o = startlocation, d = board), faces = cubeFaces(), convexity = 1);

        translate(
            [
                startlocation.x + board.x-0.5,
                startlocation.y + board.y - board.z,
                startlocation.z + board.z])
        rotate([0,180,0])
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