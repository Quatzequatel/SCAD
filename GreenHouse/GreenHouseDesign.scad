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
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;

//enums
enThickness = 0;
enWidth = 1; 
enLength = 2;

enX = 0;
enY = 1;
enZ = 2;

function getBoardProperty(board, enum) = getValue(v = board, enum = enum);
function setBoardProperty(board, thickness, width, length) =
[
    thickness == undef ? board[enThickness] : thickness, 
    width == undef ? board[enWidth] : width, 
    length == undef ? board[enLength] : length
];

//board is in mm
Board = setBoardProperty(board = [], thickness = convert_in2mm(in = 2), width = convert_in2mm(in = 4), length = convert_ft2mm(feet = 1));

//all in mm
Length = convert_ft2mm(feet = 12);
Width = convert_ft2mm(feet = 15);
EntryDepth = convert_ft2mm(feet = 4);
EntryWidth = convert_ft2mm(feet = 8);
MaxHeight = convert_ft2mm(feet = 15);
RoofAngle = 45;
RoofWidth = Width/2; //((Width - in2ft(Board.x))/2);
RoofHeight = RoofWidth * sin(RoofAngle);
RoofLength = sqrt((RoofHeight * RoofHeight) + (RoofWidth * RoofWidth));
WallHeight = MaxHeight - RoofHeight;

EntryRoofWidth = EntryWidth/2; //((Width - in2ft(Board.x))/2);
EntryRoofHeight = EntryRoofWidth * sin(RoofAngle);
EntryRoofLength = hypotenuse(EntryRoofHeight, EntryRoofWidth);// sqrt((EntryRoofHeight * EntryRoofHeight) + (EntryRoofWidth * EntryRoofWidth));
// WallHeight = MaxHeight - RoofHeight;


Build();

module Build(args) 
{
    echo("Base Dimensions:");
    echo(Length = convert_mm2Feet(mm = Length));
    echo(Width = convert_mm2Feet(mm = Width));
    echo(MaxHeight = convert_mm2Feet(mm = MaxHeight));
    echo(RoofAngle = RoofAngle);
    echo(RoofHeight = convert_mm2Feet(mm = RoofHeight));
    echo(RoofWidth = convert_mm2Feet(mm = RoofWidth));
    echo(WallHeight = convert_mm2Feet(mm = WallHeight));
    echo(RoofLength = convert_mm2Feet(mm = RoofLength));
    echo(sin45 = sin(45));

    SideView();
    translate([Width/2,0,0])
    rotate([0,0, 90])
    simpleView(false, true, false);

}

module simpleView(showentry = true, showRoof = true, showwalls = true)
{
    if(showwalls)
    {
        //sides
        linear_extrude(height=WallHeight)
        square(size=[Width, Length], center=true);
    }
    if(showRoof)
    {
        //roof
        translate([0,0,WallHeight])
        linear_extrude(height=RoofHeight, scale=[1,0.01])
        square(size=[Width, Length], center=true);
    }
    if(showentry)
    {
        //entry
        translate([0, Length/2 - EntryDepth/2,0])
        rotate([0, 0, 90])
        union()
        {
            linear_extrude(height=WallHeight)
            square(size=[3*EntryDepth, EntryWidth], center=true);

            //entry roof
            translate([0,0,WallHeight])
            linear_extrude(height=EntryRoofHeight, scale=[1,0.01])
            square(size=[3*EntryDepth, EntryWidth], center=true);        
        }
    }

}

module SideView()
{
    
}

// module SideView()
// {
//     echo(Board = Board);
//     verticalBoard(setBoardProperty(board = Board, length = WallHeight), [0,0,Board.x]);
//     verticalBoard(setBoardProperty(board = Board, length = WallHeight), [Width - Board.x, 0, Board.x]);
//     verticalBoard
//     (
//         setBoardProperty
//         (
//             board = Board, 
//             length = (MaxHeight)), 
//             [
//                 (Width)/2 - Board.x/2, 
//                 0, 
//                 Board.x
//             ]
//     );
//     HorizontalBoard(setBoardProperty(board = Board, length = (Width)), [0, 0, 0]);
//     HorizontalBoard(setBoardProperty(board = Board, length = (Width)), [0, 0, (WallHeight) + Board.x]);

//     AngleBoard
//         (
//             setBoardProperty(board = Board, length = (RoofLength)), 
//             angle = -RoofAngle, 
//             location = 
//                 [
//                     0,
//                     0,
//                     (WallHeight) + Board.x
//                 ]
//         );
//     AngleBoard
//         (
//             setBoardProperty(board = Board, length = (RoofLength)), 
//             angle = -((90 - RoofAngle) + 90), 
//             location = 
//                 [
//                     (Width) ,
//                     0,
//                     (WallHeight) +  Board.x
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


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


