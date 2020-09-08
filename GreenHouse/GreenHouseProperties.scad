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
Board2x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 1.5), width = convert_in2mm(in = 3.5), length = convert_ft2mm(ft = 8));
Board4x4 = setBoardProperty(board = [], thickness = convert_in2mm(in = 3.5), width = convert_in2mm(in = 3.5), length = convert_ft2mm(ft = 8));
Board2x6 = setBoardProperty(board = [], thickness = convert_in2mm(in = 1.5), width = convert_in2mm(in = 5.5), length = convert_ft2mm(ft = 8));

BoardDimensions = [convert_in2mm(in = 2), convert_in2mm(in = 4), convert_ft2mm(ft = 8)];
Stud = Board2x4;
Rafter = Board2x6;
Post = Board4x4;

/*
    Since i am always confusing myself.
    Dimensions are listed [x, y, z] in english width by length by height.
    The greenhouse door is the front of the house and therefore the width is 16'.
    The length of the house is 11.25' plus the entry way.
*/

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

RoofWidth = HouseLength/2; //((Width - in2ft(Board2x4.x))/2);
RoofHeight = RoofWidth * sin(RoofAngle);
RoofLength = hypotenuse(RoofHeight, RoofWidth);

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

RoofProperties = 
[
    "roof properties",
        ["angle", RoofAngle],
        ["width", HouseWidth],
        ["length", HouseLength],
        ["height", convert_in2mm(60.777)],
        ["overhang depth", RoofOverHangDepth],
        ["overhang height", sideAaB(side_b = RoofOverHangDepth, aB = AngleOpposite(RoofAngle))],
        ["overhang length", sideC_B(side_b = RoofOverHangDepth, aA = RoofAngle)],
        ["rafter length", sideC_B(side_b = HouseLength/2, aA = RoofAngle) + sideC_B(side_b = RoofOverHangDepth, aA = RoofAngle)],
        ["spacing", StudSpacing]
];

CenterBeamProperties = 
[
    "CenterBeamProperties",
        ["width", Board2x6.x],
        ["depth", Board2x6.y],
        ["length", HouseWidth],
        ["location", [-Board2x6.x/2, -HouseWidth/2, gdv(RoofProperties, "height") - Board2x6.y]],
        ["color", "red"]
];

Rafter_South = 
[
    "Rafter_North",
        ["angle", RoofAngle],
        ["width", Board2x4.x],
        ["depth", Board2x4.y],
        ["length", gdv(RoofProperties, "rafter length")] ,
        ["location", [0, -convert_in2mm(in = 32.5), gdv(RoofProperties, "height")/2 - convert_in2mm(in = 2.5)]],
        ["rotate", [RoofAngle, 0, 0]],
        ["color", "blue"]
];

Rafter_North = 
[
    "Rafter_North",
        ["angle", 90 - RoofAngle],
        ["width", Board2x4.x],
        ["depth", Board2x4.y],
        ["length", convert_in2mm(in = 90.830209248)] ,
        ["location", [0, convert_in2mm(in = 32), convert_in2mm(in = 55/2)]],
        ["rotate", [-RoofAngle, 0, 0]],
        ["color", "yellow"]
];

Rafter_Test = 
[
    "Rafter_Test",
        ["angle", 42],
        ["angle step", -10],
        ["width", convert_in2mm(in = 1.5)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 90.830209248)] ,
        ["location", [0, -convert_in2mm(in = 32), convert_in2mm(in = 56/2)]],
        ["rotate", [42, 0, 0]],
        ["color", "green"],
        ["brace color", "yellow"]
];

Brace_One = 
[
    "Brace_One",
        ["angle", 32],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 96)],
        ["location", [0, -convert_in2mm(in = 26.75), convert_in2mm(in = 24)]],
        ["rotate", [32, 0, 0]],
        ["color", "yellow"]    
];

Brace_Two = 
[
    "Brace_Two",
        ["angle", 25],
        ["width", convert_in2mm(in = 0.75)],
        ["depth", convert_in2mm(in = 3.5)],
        ["length", convert_in2mm(in = 100)],
        ["location", [0, -convert_in2mm(in = 20), convert_in2mm(in = 20)]],
        ["rotate", [25, 0, 0]],
        ["color", "Aqua"]    
];

concrete_footing_properties = 
[
    "footing properties",
        ["width", convert_in2mm(16)],  
        ["height", convert_in2mm(8)],  
        ["start", -1 * (frost_line + convert_in2mm(2))],
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

house_foundation_properties = 
[
    "house foundation properties",  
        ["width", convert_in2mm(8)],  
        ["height", convert_in2mm(8)],  
        ["start", 
            getDictionaryValue(concrete_footing_properties, "start") + 
            getDictionaryValue(concrete_footing_properties, "height")
        ],
        ["layers", 4]
];

crushed_rock_properties = 
[
    "crushed rock properties",
        ["width", getDictionaryValue(concrete_footing_properties, "width") + convert_in2mm(4)],
        ["height", convert_in2mm(4)],
        ["start", (getDictionaryValue(concrete_footing_properties, "start") - convert_in2mm(4))],
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
            -1 * (HouseWidth/2 - convert_in2mm(3)), 
            1 * (HouseLength/2 - convert_in2mm(36)), 
            getDictionaryValue(concrete_footing_properties, "start")
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
            -1 * (HouseWidth/2 - convert_in2mm(3)), 
            -1 * (HouseLength/2 - convert_in2mm(36)), 
            getDictionaryValue(concrete_footing_properties, "start")
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
        ["width", HouseWidth + getDictionaryValue(SouthColdFrame, "width") + getDictionaryValue(crushed_rock_properties, "width")/2],    
        ["length", HouseLength + EntryLength + getDictionaryValue(crushed_rock_properties, "width")/2],  
        ["frost line", frost_line],
];

insulation_properties =
[
    "insulation_properties",
    ["width" , convert_in2mm(2)],
    ["height" , convert_in2mm(16)],
    ["start" , [0,0,0]],
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

Fence_Properties = 
[
    "fence properties",
        ["width", convert_ft2mm(103.24)],
        ["length", convert_in2mm(4)],
        ["height", convert_in2mm(72)],
        ["easement", -1 * convert_ft2mm(12)],
];

module Info()
{
    echo();
    echo("*** GreenHouseProperties::Info()");
    echo();
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