/*
    this is the design for the greenhouse.
    preliminary constraints:
        max 200 ft^2
        max height is 12 ft.
    Dimensions are therefore
        width = 16 ft.
        depth = 12 ft.
        wall height = 6.8038 ft or 81.64617 in
        roof height with 60 degree angle = 5.196 ft or 62.35383 in
*/
// include <TrellisEnums.scad>;
include <constants.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;
use <Construction.scad>;

use <box_extrude.scad>;


function getBoardProperty(board, enum) = getValue(v = board, enum = enum);
function setBoardProperty(board, thickness, width, length) =
[
    thickness == undef ? board[enThickness] : thickness, 
    width == undef ? board[enWidth] : width, 
    length == undef ? board[enLength] : length
];

//board is in mm
Board2x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 2), width = convert_in2mm(in = 4), length = convert_ft2mm(feet = 8));
Board4x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 4), width = convert_in2mm(in = 4), length = convert_ft2mm(feet = 8));
Board2x6 = setBoardProperty(board = [], thickness = convert_in2mm(in = 2), width = convert_in2mm(in = 6), length = convert_ft2mm(feet = 8));

BoardDimensions = [convert_in2mm(in = 2), convert_in2mm(in = 4), convert_ft2mm(feet = 8)];


//all in mm
Length = convert_ft2mm(feet = 15);
Width = convert_ft2mm(feet = 12);
WallHeight = convert_ft2mm(feet = 8);
RoofAngle = 45;
EntryRoofAngle = 45;

EntryLength = convert_ft2mm(feet = 4);
EntryWidth = convert_ft2mm(feet = 5);
MaxHeight = convert_ft2mm(feet = 15);
HouseDimensions = [Width, Length, WallHeight];
EntryDimensions = [EntryWidth, EntryLength, WallHeight];

// RoofAngle = 45;
// RoofWidth = Width/2; //((Width - in2ft(Board2x4.x))/2);
// RoofHeight = RoofWidth * sin(RoofAngle);
// RoofLength = hypotenuse(RoofHeight, RoofWidth);

RoofDimensions = [
        HouseDimensions.x/2,    
        HouseDimensions.y,  
        HouseDimensions.x/2 * sin(RoofAngle), 
        RoofAngle ];

EntryRoofDimensions = [
    EntryDimensions.x/2,                                        //width
    EntryDimensions.y + HouseDimensions.z * cos(RoofAngle) + convert_in2mm(in = 4),   //length
    EntryDimensions.x * sin(EntryRoofAngle),                  //height
    EntryRoofAngle ];                                           //angle

// EntryRoofWidth = EntryWidth/2; //((Width - in2ft(Board2x4.x))/2);
// EntryRoofHeight = EntryRoofWidth * sin(RoofAngle);
// EntryRoofLength = hypotenuse(EntryRoofHeight, EntryRoofWidth);// sqrt((EntryRoofHeight * EntryRoofHeight) + (EntryRoofWidth * EntryRoofWidth));
// WallHeight = MaxHeight - RoofHeight;
// EntryDimensions = [Length, Width, MaxHeight];
// EntryRoofDimensions = [Width/2, RoofLength,  hypotenuse(RoofHeight, RoofWidth), RoofAngle ];


Build();

module Build(args) 
{
    echo("Base Dimensions:");
    echo(Length = convert_mm2Feet(mm = HouseDimensions.y));
    echo(Width = convert_mm2Feet(mm = HouseDimensions.x));
    echo(Height = convert_mm2Feet(mm = HouseDimensions.z + RoofDimensions.z));
    echo(RoofAngle = RoofAngle);
    echo(RoofHeight = convert_mm2Feet(mm = RoofDimensions.z));
    echo(RoofWidth = convert_mm2Feet(mm = RoofDimensions.x));
    echo(WallHeight = convert_mm2Feet(mm = HouseDimensions.z));
    echo(RoofLength = convert_mm2Feet(mm = RoofDimensions.y));
    echo(EntryRoofDimensions_inches = convertV_mm2Inch(mm = EntryRoofDimensions));
    echo(EntryRoofAngle = EntryRoofDimensions[3]);
    // echo(sin45 = sin(45));

    // SideView();
    // translate([Width/2,0,0])
    // rotate([0,0, 90])
    // simpleView(true, true, false);

    // HouseFrame();
    // EntryFrame();
    // RoofFrame();

    HouseFrame2();
    EntryFrame2();

}

module HouseFrame2()
{
    isFinished = true;
    //back wall
    translate([0, 0, 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [HouseDimensions.y, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }

    //right side wall
    translate([Board2x4.y, HouseDimensions.y, 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [HouseDimensions.x - Board2x4.y, HouseDimensions.y, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }
    
    //left side wall
    translate([Board2x4.y, Board2x4.y, 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [HouseDimensions.x - Board2x4.y, HouseDimensions.y, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }

    //front wall  left side
    translate([HouseDimensions.x, 0, 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [HouseDimensions.y/2 - EntryDimensions.x/2, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }

    //front wall  right side
    translate([HouseDimensions.x, HouseDimensions.y - (HouseDimensions.y/2 - EntryDimensions.x/2), 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [HouseDimensions.y/2 - EntryDimensions.x/2, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }
}

module EntryFrame2()
{
    isFinished = true;
    //left side wall
    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            HouseDimensions.y - (HouseDimensions.y/2 - EntryDimensions.x/2) + Board2x4.y, 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x - Board2x4.y, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }

    //right side wall
    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            (HouseDimensions.y/2 - EntryDimensions.x/2), 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x - Board2x4.y, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            finished = isFinished
        );        
    }

    //Doorway
    translate
    (
        [
            HouseDimensions.x + EntryDimensions.x - Board2x4.y, 
            (HouseDimensions.y/2 - EntryDimensions.x/2), 
            0
        ]
    )
    rotate([90, 0, 90]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = convert_in2mm(16),
            includeStuds = false,
            finished = isFinished
        );        
    }    
}

module simpleView(showentry = true, showRoof = true, showwalls = true)
{
    {
        sidePoints = housePoints(houseDi = HouseDimensions, roofDi = RoofDimensions, p0 = [0,0]);

        // echo(sidePoints = sidePoints);
        // echo(sidePoints = convertVPts_mm2Inch(sidePoints));

        translate([0,HouseDimensions.y,0])
        rotate([90,0,0])
        %linear_extrude(height = HouseDimensions.y)
        polygon(points=sidePoints);

    }
    if(showentry)
    {
            entryPoints = housePoints(houseDi = EntryDimensions, roofDi = EntryRoofDimensions, p0 = [0,0]);
            echo(entryPoints = entryPoints);
            echo(EntryDimensions = EntryDimensions, EntryRoofDimensions = EntryRoofDimensions);

            translate([HouseDimensions.x - (EntryRoofDimensions.y - EntryDimensions.x), HouseDimensions.y/2 - EntryDimensions.x/2,0])
            rotate([90,0,90])
            difference()
            {
                linear_extrude(height = EntryRoofDimensions.y)
                polygon(points=entryPoints);

                union()
                {
                    linear_extrude(height = EntryRoofDimensions.y/2)
                    square([EntryDimensions.x + 1,EntryDimensions.z + 1], center = false);
                    tripoints = [
                        [0,EntryDimensions.z],
                        [EntryRoofDimensions.y/2,EntryDimensions.z],
                        [0, EntryRoofDimensions.y/2 ]
                        ];
                        echo(tripoints=tripoints);
                        echo(tripoints=convertVPts_mm2Inch(tripoints));
                    // translate([0,EntryDimensions.z,0])
                    // !#rotate([0,-90,90])
                    // translate([0,-EntryDimensions.z,0])
                    // linear_extrude(height = EntryDimensions.x)
                    // polygon(points=tripoints);
                }
            }


            //left garden box
            translate([HouseDimensions.x, 0, 0])
            // linear_extrude(height = EntryRoofDimensions.y)
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([EntryDimensions.x,(HouseDimensions.y - EntryDimensions.x)/2], center = false);

            //right garden box
            translate([HouseDimensions.x, HouseDimensions.y - (HouseDimensions.y - EntryDimensions.x)/2 , 0])
            // linear_extrude(height = EntryRoofDimensions.y)
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([EntryDimensions.x,(HouseDimensions.y - EntryDimensions.x)/2], center = false);
    }

}

module HouseFrame()
{
    p1 = [0,0,0];
    p2 = [p1.x, HouseDimensions.y, p1.z];
    p3 = [HouseDimensions.x, p2.y, p1.z];
    p4 = [p3.x, p1.y, p1.z];

    p5 = [p1.x, p1.y, HouseDimensions.z];
    p6 = [p2.x, p2.y, HouseDimensions.z];
    p7 = [p3.x, p3.y, HouseDimensions.z];
    p8 = [p4.x, p4.y, HouseDimensions.z];

    echo(HouseFrame = "Floor");
    color("red") point_square(size = Board2x4, p1 = p1, p2 = p2, height = Board2x4.x, center = true);
    color("blue") point_square(size = Board2x4, p1 = p2, p2 = p3, height = Board2x4.x);
    color("yellow") point_square(size = Board2x4, p1 = p3, p2 = p4, height = Board2x4.x);
    color("green") point_square(size = Board2x4, p1 = p4, p2 = p1, height = Board2x4.x, center = true);

    echo(HouseFrame = "ceiling");
    color("red") point_square(size = Board2x4, p1 = p5, p2 = p6, height = Board2x4.x, center = true);
    color("blue") point_square(size = Board2x4, p1 = p6, p2 = p7, height = Board2x4.x);
    color("yellow") point_square(size = Board2x4, p1 = p7, p2 = p8, height = Board2x4.x);
    color("green") point_square(size = Board2x4, p1 = p8, p2 = p5, height = Board2x4.x, center = true);

    echo(HouseFrame = "corners");
    color("red") point_square(size = Board4x4, p1 = p1, p2 = p5, height = Board2x4.x);
    color("blue") point_square(size = Board4x4, p1 = p2, p2 = p6, height = Board2x4.x);
    color("yellow") point_square(size = Board4x4, p1 = p3, p2 = p7, height = Board2x4.x);
    color("green") point_square(size = Board4x4, p1 = p4, p2 = p8, height = Board4x4.y);

}

module EntryFrame()
{
    p1 = 
        [
            HouseDimensions.x,
            HouseDimensions.y/2 - EntryDimensions.x/2 + Board4x4.y,
            0
        ];
    p2 = [p1.x, p1.y + EntryDimensions.y, p1.z];
    p3 = [p1.x + EntryDimensions.x, p2.y, p1.z];
    p4 = [p3.x, p1.y, p1.z];

    p5 = [p1.x, p1.y, EntryDimensions.z];
    p6 = [p2.x, p2.y, EntryDimensions.z];
    p7 = [p3.x, p3.y, EntryDimensions.z];
    p8 = [p4.x, p4.y, EntryDimensions.z];

    echo(EntryFrame = "Floor");
    color("red") point_square(size = Board2x4, p1 = p1, p2 = p2, height = Board2x4.y, center = true);
    color("blue") point_square(size = Board2x4, p1 = p2, p2 = p3, height = Board2x4.y);
    color("yellow") point_square(size = Board2x4, p1 = p3, p2 = p4, height = Board2x4.y);
    color("green") point_square(size = Board2x4, p1 = p4, p2 = p1, height = Board2x4.y, center = true);

    echo(EntryFrame = "ceiling");
    color("red") point_square(size = Board2x4, p1 = p5, p2 = p6, height = Board2x4.y, center = true);
    color("blue") point_square(size = Board2x4, p1 = p6, p2 = p7, height = Board2x4.y);
    color("yellow") point_square(size = Board2x4, p1 = p7, p2 = p8, height = Board2x4.y);
    color("green") point_square(size = Board2x4, p1 = p8, p2 = p5, height = Board2x4.y, center = true);

    echo(EntryFrame = "corners");
    color("red") point_square(size = Board4x4, p1 = p1, p2 = p5, height = Board2x4.y);
    color("blue") point_square(size = Board4x4, p1 = p2, p2 = p6, height = Board2x4.y);
    color("yellow") point_square(size = Board4x4, p1 = p3, p2 = p7, height = Board2x4.y);
    color("green") point_square(size = Board4x4, p1 = p4, p2 = p8, height = Board4x4.y);
}

module RoofFrame()
{
    p1 = [ 0, 0,HouseDimensions.z ];
    p2 = [ HouseDimensions.x/2, p1.y, p1.z + HouseDimensions.x/2 * sin(RoofAngle) ];
    p3 = [HouseDimensions.x, p1.y, p1.z];

    p4 = [ p1.x, p1.y + HouseDimensions.y, p1.z ];
    p5 = [p2.x, p4.y, p2.z ];
    p6 = [p3.x, p4.y, p3.z];    

    p7 = [p2.x, p2.y, HouseDimensions.z];
    p8 = [p5.x, p5.y, HouseDimensions.z];

    echo(RoofFrame = "Roof1");
    color("red") point_square(size = Board2x4, p1 = p1, p2 = p2, height = Board2x4.y, center = true);
    color("blue") point_square(size = Board2x4, p1 = p2, p2 = p3, height = Board2x4.y);
    color("yellow") point_square(size = Board2x4, p1 = p3, p2 = p1, height = Board2x4.y);

    echo(RoofFrame = "Roof2");
    color("red") point_square(size = Board2x4, p1 = p4, p2 = p5, height = Board2x4.y, center = true);
    color("blue") point_square(size = Board2x4, p1 = p5, p2 = p6, height = Board2x4.y);
    color("yellow") point_square(size = Board2x4, p1 = p6, p2 = p4, height = Board2x4.y);;

    echo(RoofFrame = "king post");
    color("red") point_square(size = Board4x4, p1 = p7, p2 = p2, height = Board4x4.y);
    color("blue") point_square(size = Board4x4, p1 = p8, p2 = p5, height = Board4x4.y);

    echo(RoofFrame = "Roof spine");
    color("deepskyblue") point_square(size = Board2x6, p1 = p2, p2 = p5, height = Board2x6.y);
}

// module SideView()
// {
//     echo(Board2x4 = Board2x4);
//     verticalBoard(setBoardProperty(board = Board2x4, length = WallHeight), [0,0,Board2x4.x]);
//     verticalBoard(setBoardProperty(board = Board2x4, length = WallHeight), [Width - Board2x4.x, 0, Board2x4.x]);
//     verticalBoard
//     (
//         setBoardProperty
//         (
//             board = Board2x4, 
//             length = (MaxHeight)), 
//             [
//                 (Width)/2 - Board2x4.x/2, 
//                 0, 
//                 Board2x4.x
//             ]
//     );
//     HorizontalBoard(setBoardProperty(board = Board2x4, length = (Width)), [0, 0, 0]);
//     HorizontalBoard(setBoardProperty(board = Board2x4, length = (Width)), [0, 0, (WallHeight) + Board2x4.x]);

//     AngleBoard
//         (
//             setBoardProperty(board = Board2x4, length = (RoofLength)), 
//             angle = -RoofAngle, 
//             location = 
//                 [
//                     0,
//                     0,
//                     (WallHeight) + Board2x4.x
//                 ]
//         );
//     AngleBoard
//         (
//             setBoardProperty(board = Board2x4, length = (RoofLength)), 
//             angle = -((90 - RoofAngle) + 90), 
//             location = 
//                 [
//                     (Width) ,
//                     0,
//                     (WallHeight) +  Board2x4.x
//                 ]
//         );
// }

// module verticalBoard(boardDimensions, location)
// {
//     echo(location = location);
//     translate(location)
//     cube(size=boardDimensions);
// }

// module HorizontalBoard(boardDimensions, location)
// {
//     // echo(location = setValue(v = location, enum = enZ, value = getValue(boardDimensions, enThickness)));
//     translate(addValue(v = location, enum = enZ, value = getValue(boardDimensions, enThickness)))
//     rotate([0,90,0])
//     color("blue") 
//     cube(size=boardDimensions);
// }

// module AngleBoard(boardDimensions, angle, location)
// {
//     echo(
//         location = addValue
//         (
//             v = addValue
//             (
//                 v = addValue
//                     (
//                         v = location, 
//                         enum = enX, 
//                         value = (cos(-angle) * getValue(boardDimensions, enLength)/2)
//                     ), 
//                 enum = enY, 
//                 value = getValue(boardDimensions, enThickness)
//             ),
//             enum = enZ,
//             value = (sin(-angle) * getValue(boardDimensions, enLength)/2)
//         )
//         );
//     translate
//     (
//         addValue
//         (
//             v = addValue
//             (
//                 v = addValue
//                     (
//                         v = location, 
//                         enum = enX, 
//                         value = (cos(-angle) * getValue(boardDimensions, enLength)/2)
//                     ), 
//                 enum = enY, 
//                 value = getValue(boardDimensions, enThickness)
//             ),
//             enum = enZ,
//             value = (sin(-angle) * getValue(boardDimensions, enLength)/2)
//         )
//     )
//     rotate([0,angle,0])
//     // translate([0,0,getValue(boardDimensions, enThickness)])
//     rotate([0,90,0])
//     color("yellow") 
//     cube(size=boardDimensions, center = true);
// }

function housePoints(houseDi, roofDi, p0) = 
[
    p0,                             //p0
    [houseDi.x, p0.y],           //p1
    [houseDi.x, houseDi.z],   //p2
    [houseDi.x/2, houseDi.z + roofDi.z],   //p3
    [p0.x, houseDi.z]           //p4
];


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


