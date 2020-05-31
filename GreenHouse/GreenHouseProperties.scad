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
Board2x4 = setBoardProperty(board = [], thickness = convert_in2in(in = 2), width = convert_in2in(in = 4), length = convert_feet2feet(feet = 8));
Board4x4 = setBoardProperty(board = [], thickness = convert_in2in(in = 4), width = convert_in2in(in = 4), length = convert_feet2feet(feet = 8));
Board2x6 = setBoardProperty(board = [], thickness = convert_in2in(in = 2), width = convert_in2in(in = 6), length = convert_feet2feet(feet = 8));

BoardDimensions = [convert_in2in(in = 2), convert_in2in(in = 4), convert_feet2feet(feet = 8)];
Stud = Board2x4;
Rafter = Board2x6;
Post = Board4x4;


//all in mm
HouseWidth = convert_feet2feet(feet = 12);
HouseLength = convert_feet2feet(feet = 15);
HouseWallHeight = convert_feet2feet(feet = 8);
//ideal seattle  summer/winter [66/18] avg = 42
RoofAngle = 42;
EntryRoofAngle = 30;

EntryWidth = convert_feet2feet(feet = 5);
EntryLength = convert_feet2feet(feet = 4);
MaxHeight = convert_feet2feet(feet = 15);
// HouseDimensions = [Width, Length, WallHeight];
// EntryDimensions = [EntryWidth, EntryLength, WallHeight];
StudSpacing = convert_in2in(24);


// RoofAngle = 45;
// RoofWidth = Width/2; //((Width - in2ft(Board2x4.x))/2);
// RoofHeight = RoofWidth * sin(RoofAngle);
// RoofLength = hypotenuse(RoofHeight, RoofWidth);

StudProperties = 
[
    "StudProperties",
    [
        ["thickness", Board2x4.x],
        ["depth", Board2x4.y],
        ["length", Board2x4.z]
    ]
];

RafterProperties = 
[
    "RafterProperties",
    [
        ["thickness", Board2x6.x],
        ["depth", Board2x6.y],
        ["length", Board2x6.z]
    ]
];

HouseDimensions = 
[
    "HouseDimensions",
    [
        ["width", HouseWidth],    
        ["length", HouseLength],  
        ["wall height", HouseWallHeight],  
        ["peak height", HouseWallHeight + Height(x= HouseWidth/2, angle = RoofAngle)], 
        ["angle", RoofAngle ]
    ]
];

// RoofDimensions = 
// [
//     "RoofDimensions",
//     [
//         ["width", HouseWidth/2],    
//         ["length", HouseLength],  
//         ["height", Height(x= HouseWidth/2, angle = RoofAngle)], 
//         ["angle", RoofAngle ]
//     ]
// ];

EntryRoofDimensions = 
[
    "EntryRoofDimensions",
    [
        ["width", EntryWidth/2],    
        ["length", EntryLength + HouseWallHeight * tan(EntryRoofAngle) + convert_in2in(in = 4)],  
        ["height", Height(x= EntryWidth/2, angle = EntryRoofAngle)], 
        ["rafter length", sideC(side_a = EntryWidth/2, aA = EntryRoofAngle)],
        ["angle", EntryRoofAngle ]
    ]
];
                                        //angle

RoofProperties = 
[
    "roof properties",
    [
        ["angle", RoofAngle],
        ["width", HouseWidth/2],
        ["length", HouseLength],
        ["height", sideB(side_a = HouseWidth/2, aA = RoofAngle)],
        ["rafter length", sideC(side_a = HouseWidth/2, aA = RoofAngle)],
    ]
];

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