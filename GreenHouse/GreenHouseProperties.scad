/*

*/

include <constants.scad>;
use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;

function getBoardProperty(board, enum) = getValue(v = board, enum = enum);
function setBoardProperty(board, thickness, width, length) =
[
    thickness == undef ? board[enThickness] : thickness, 
    width == undef ? board[enWidth] : width, 
    length == undef ? board[enLength] : length
];


//board is in mm
Board2x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 2), width = convert_in2mm(in = 4), length = convert_ft2mm(ft = 8));
Board4x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 4), width = convert_in2mm(in = 4), length = convert_ft2mm(ft = 8));
Board2x6 = setBoardProperty(board = [], thickness = convert_in2mm(in = 2), width = convert_in2mm(in = 6), length = convert_ft2mm(ft = 8));

BoardDimensions = [convert_in2mm(in = 2), convert_in2mm(in = 4), convert_ft2mm(ft = 8)];
Stud = Board2x4;
Rafter = Board2x6;
Post = Board4x4;


//all in mm
HouseWidth = convert_ft2mm(ft = 11.25);
HouseLength = convert_ft2mm(ft = 16);
HouseWallHeight = convert_ft2mm(ft = 8);
//ideal seattle  summer/winter [66/18] avg = 42
RoofAngle = 42;
EntryRoofAngle = 45;
RoofOverHangDepth = convert_in2mm(1);

EntryWidth = convert_ft2mm(ft = 5);
EntryLength = convert_ft2mm(ft = 4);
MaxHeight = convert_ft2mm(ft = 15);
// HouseDimensions = [Width, Length, WallHeight];
// EntryDimensions = [EntryWidth, EntryLength, WallHeight];
StudSpacing = convert_in2mm(24);


// RoofAngle = 45;
// RoofWidth = Width/2; //((Width - in2ft(Board2x4.x))/2);
// RoofHeight = RoofWidth * sin(RoofAngle);
// RoofLength = hypotenuse(RoofHeight, RoofWidth);

StudProperties = 
[
    "StudProperties",
        ["thickness", Board2x4.x],
        ["depth", Board2x4.y],
        ["length", Board2x4.z]
];

RafterProperties = 
[
    "RafterProperties",
        ["thickness", Board2x6.x],
        ["depth", Board2x6.y],
        ["length", Board2x6.z]
];

HouseDimensions = 
[
    "HouseDimensions",
        ["width", HouseWidth],    
        ["length", HouseLength],  
        ["wall height", HouseWallHeight],  
        ["peak height", HouseWallHeight + Height(x= HouseWidth/2, angle = RoofAngle)], 
        ["angle", RoofAngle ]
];

EntryRoofDimensions = 
[
    "EntryRoofDimensions",
        ["width", EntryWidth/2],    
        ["length", EntryLength + HouseWallHeight * tan(EntryRoofAngle) + convert_in2mm(in = 4)],  
        ["height", Height(x= EntryWidth/2, angle = EntryRoofAngle)], 
        ["rafter length", sideC_B(side_b = EntryWidth/2, aA = EntryRoofAngle)],
        ["angle", EntryRoofAngle ]
];

RoofProperties = 
[
    "roof properties",
        ["angle", RoofAngle],
        ["width", HouseWidth/2],
        ["length", HouseLength],
        ["height", sideAaB(side_b = HouseWidth/2, aB = AngleOpposite(RoofAngle))],
        ["overhang depth", RoofOverHangDepth],
        ["overhang height", sideAaB(side_b = RoofOverHangDepth, aB = AngleOpposite(RoofAngle))],
        ["overhang length", sideC_B(side_b = RoofOverHangDepth, aA = RoofAngle)],
        ["rafter length", sideC_B(side_b = HouseWidth/2, aA = RoofAngle) + sideC_B(side_b = RoofOverHangDepth, aA = RoofAngle)],
        ["spacing", StudSpacing]
];

module Info()
{
    debugEcho("Stud", StudProperties[1], true);
    echo();
    debugEcho("Rafter", RafterProperties[1], true);
    echo();
    debugEcho("House Dimensions", HouseDimensions[1], true);
    echo();
    // debugEcho("Roof", RoofDimensions[1], true);
    echo();
    debugEcho("Entry Roof", EntryRoofDimensions[1], true);
    echo();
    debugEcho("Roof Properties", RoofProperties[1], true);
}