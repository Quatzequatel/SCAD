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
Length = convert_ft2mm(feet = 16);
Width = convert_ft2mm(feet = 12);
MaxHeight = convert_ft2mm(feet = 12);
RoofAngle = 45;
RoofWidth = Width/2; //((Width - in2ft(getValue(Board, enThickness)))/2);
RoofHeight = RoofWidth * sin(RoofAngle);
RoofLength = sqrt((RoofHeight * RoofHeight) + (RoofWidth * RoofWidth));
WallHeight = MaxHeight - RoofHeight;


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

}

module SideView()
{
    echo(Board = Board);
    verticalBoard(setBoardProperty(board = Board, length = WallHeight), [0,0,getValue(Board, enThickness)]);
    verticalBoard(setBoardProperty(board = Board, length = WallHeight), [Width - getValue(Board, enThickness), 0, getValue(Board, enThickness)]);
    verticalBoard
    (
        setBoardProperty
        (
            board = Board, 
            length = (MaxHeight)), 
            [
                (Width)/2 - getValue(Board, enThickness)/2, 
                0, 
                getValue(Board, enThickness)
            ]
    );
    HorizontalBoard(setBoardProperty(board = Board, length = (Width)), [0, 0, 0]);
    HorizontalBoard(setBoardProperty(board = Board, length = (Width)), [0, 0, (WallHeight) + getValue(Board, enThickness)]);

    AngleBoard
        (
            setBoardProperty(board = Board, length = (RoofLength)), 
            angle = -RoofAngle, 
            location = 
                [
                    0,
                    0,
                    (WallHeight) + getValue(Board, enThickness)
                ]
        );
    AngleBoard
        (
            setBoardProperty(board = Board, length = (RoofLength)), 
            angle = -((90 - RoofAngle) + 90), 
            location = 
                [
                    (Width) ,
                    0,
                    (WallHeight) +  getValue(Board, enThickness)
                ]
        );
}

module verticalBoard(boardDimensions, location)
{
    echo(location = location);
    translate(location)
    cube(size=boardDimensions);
}

module HorizontalBoard(boardDimensions, location)
{
    // echo(location = setValue(v = location, enum = enZ, value = getValue(boardDimensions, enThickness)));
    translate(addValue(v = location, enum = enZ, value = getValue(boardDimensions, enThickness)))
    rotate([0,90,0])
    color("blue") 
    cube(size=boardDimensions);
}

module AngleBoard(boardDimensions, angle, location)
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
                        value = (cos(-angle) * getValue(boardDimensions, enLength)/2)
                    ), 
                enum = enY, 
                value = getValue(boardDimensions, enThickness)
            ),
            enum = enZ,
            value = (sin(-angle) * getValue(boardDimensions, enLength)/2)
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
                        value = (cos(-angle) * getValue(boardDimensions, enLength)/2)
                    ), 
                enum = enY, 
                value = getValue(boardDimensions, enThickness)
            ),
            enum = enZ,
            value = (sin(-angle) * getValue(boardDimensions, enLength)/2)
        )
    )
    rotate([0,angle,0])
    // translate([0,0,getValue(boardDimensions, enThickness)])
    rotate([0,90,0])
    color("yellow") 
    cube(size=boardDimensions, center = true);
}


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


