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
HouseWidth = convert_ft2mm(ft = 16);
HouseLength = convert_ft2mm(ft = 11.25);
HouseWallHeight = convert_ft2mm(ft = 8);
//ideal seattle  summer/winter [66/18] avg = 42
RoofAngle = 42;
EntryRoofAngle = 45;
RoofOverHangDepth = convert_in2mm(1);

EntryWidth = convert_ft2mm(ft = 5);
EntryLength = convert_ft2mm(ft = 4);
MaxHeight = convert_ft2mm(ft = 15);

StudSpacing = convert_in2mm(24);

EntryColdFrame_width = (HouseWidth-EntryWidth)/2;
EntryColdFrame_length = EntryLength;

frost_line = convert_in2mm(14);


// RoofAngle = 45;
// RoofWidth = Width/2; //((Width - in2ft(Board2x4.x))/2);
// RoofHeight = RoofWidth * sin(RoofAngle);
// RoofLength = hypotenuse(RoofHeight, RoofWidth);

StudProperties = 
[
    "stud properties",
        ["thickness", Board2x4.x],
        ["depth", Board2x4.y],
        ["length", Board2x4.z]
];

RafterProperties = 
[
    "rafter properties",
        ["thickness", Board2x6.x],
        ["depth", Board2x6.y],
        ["length", Board2x6.z]
];

HouseDimensions = 
[
    "house dimensions",
        ["width", HouseWidth],    
        ["length", HouseLength],  
        ["wall height", HouseWallHeight],  
        ["peak height", HouseWallHeight + Height(x= HouseWidth/2, angle = RoofAngle)], 
        ["angle", RoofAngle ],
        ["wall thickness", convert_in2mm(4)],  
];

footing_properties = 
[
    "footing properties",
        ["width", convert_in2mm(16)],  
        ["height", convert_in2mm(8)],  
        ["start", -1 * (frost_line + convert_in2mm(2))],
];

crushed_rock_properties = 
[
    "crushed rock properties",
        ["width", convert_in2mm(16) + convert_in2mm(4)],
        ["height", convert_in2mm(4)],
        ["start", (getDictionaryValue(footing_properties, "start") - convert_in2mm(4))],
];

house_foundation_properties = 
[
    "house foundation properties",  
        ["width", convert_in2mm(8)],  
        ["height", convert_in2mm(8)],  
        ["start", 
            getDictionaryValue(footing_properties, "start") + 
            getDictionaryValue(footing_properties, "height")
        ],
];

drainage_properties =
[
    "drainage properties",
    ["diameter", convert_in2mm(4)],
    ["radius", convert_in2mm(2)],
    ["corner_r", convert_in2mm(8)],
    ["distance from wall", (getDictionaryValue(crushed_rock_properties, "width") - convert_in2mm(8))],
    ["vertical start", getDictionaryValue(crushed_rock_properties, "start")],
];

electric_conduit = 
[
    "electric conduit",
    ["diameter", convert_in2mm(4)],
    ["radius", convert_in2mm(2)],
    ["length", convert_in2mm(36)], 
    ["location", 
        [ 
            -1 * HouseWidth/2, 
            1 * (HouseLength/2 - convert_in2mm(36)), 
            getDictionaryValue(footing_properties, "start")
        ] 
    ] 
];

water_conduit = 
[
    "water conduit",,
    ["diameter", convert_in2mm(4)],
    ["radius", convert_in2mm(2)],
    ["length", convert_in2mm(36)], 
    ["location", 
        [ 
            -1 * HouseWidth/2, 
            -1 * (HouseLength/2 - convert_in2mm(36)), 
            getDictionaryValue(footing_properties, "start")
        ] 
    ]
];

EntryDimensions = 
[
    "entry dimensions",
        ["width", EntryWidth],    
        ["length", EntryLength],  
        ["height", Height(x= EntryWidth/2, angle = EntryRoofAngle)],
        ["wall thickness", convert_in2mm(4)],  
        ["foundation height", convert_in2mm(4)],          
];

EntryRoofDimensions = 
[
    "entry roof dimensions",
        ["width", getDictionaryValue(EntryDimensions, "width")],    
        ["length", getDictionaryValue(EntryDimensions, "length")],  
        ["height", getDictionaryValue(EntryDimensions, "height")], 
        ["rafter length", sideC_B(side_b = EntryWidth/2, aA = EntryRoofAngle)],
        ["angle", EntryRoofAngle ]
];

EntryColdFrame = 
[
    "entry cold frame",
        ["width", EntryColdFrame_width],    
        ["length", EntryColdFrame_length],  
        ["height", getDictionaryValue(EntryDimensions, "height")],
        ["wall thickness", convert_in2mm(4)],  
        ["foundation height", convert_in2mm(4)],  
];

SouthColdFrame = 
[
    "south cold frame",
        ["width", EntryLength],    
        ["length", HouseLength + EntryLength],  
        ["height", getDictionaryValue(EntryDimensions, "height")],
        ["wall thickness", convert_in2mm(4)],  
        ["foundation height", convert_in2mm(4)],  
];

foundationProperties = 
[
    "foundation properties",
        ["width", HouseWidth + getDictionaryValue(SouthColdFrame, "width")],    
        ["length", HouseLength + EntryLength],  
        ["insulation thickness", convert_in2mm(2)],
        ["insulation height", convert_in2mm(16)],
        ["frost line", frost_line],
];

thermo_column_properties =
[
    "thermal column properties",
    ["radius", convert_in2mm(12)],
    ["height per turn", convert_in2mm(2)],
    ["turns", 30],
    ["height", convert_in2mm(60)],
    ["pipe diameter", convert_in2mm(0.75)],
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