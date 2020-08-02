/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

//greenhouse
use <transformations.scad>;
use <Foundation.scad>;
use <GeoThermal.scad>;
use <Fence.scad>;

function gdv(obj, property) = getDictionaryValue(obj, property);
function getOD(length) = length + convert_in2mm(4 * 2);//(footer_width - block_width)/2;
// function getID(length) = getOD(length) - footer_width;
function getID(length) = length - convert_in2mm(12 * 2);

HouseWidth = convert_ft2mm(ft = 16); //192"
HouseLength = convert_ft2mm(ft = 11.25); //135"
entry_width = convert_in2mm(60);
entry_length = convert_in2mm(48);
house_length_with_entry = HouseLength + entry_length;
block_width = convert_in2mm(8);
block_length = convert_in2mm(16);
block_height = convert_in2mm(8);
footer_width = convert_in2mm(16);
form_board_depth = convert_in2mm(0.75);

FoundationWidth_od = getOD(HouseWidth);
FoundationWidth_id = getID(HouseWidth);

FoundationLength_od =  getOD(HouseLength);
FoundationLength_id = getID(HouseLength);

entry_width_od = getOD(entry_width);
entry_width_id = getID(entry_width);
special_entry_width = convert_in2mm(66);

entry_length_od =  getOD(entry_length);
entry_length_id = getID(entry_length);

//have to add 2nd entry_length so /2 is correct on transform
house_length_with_entry_od = getOD(house_length_with_entry + entry_length);
house_length_with_entry_id = getID(house_length_with_entry);

echo( lengthof1A = convert_mm2Inch(FoundationWidth_od));
echo( lengthof1B = convert_mm2Inch(FoundationWidth_id));

echo( lengthof2A = convert_mm2Inch(FoundationLength_od));
echo( lengthof2B = convert_mm2Inch(FoundationLength_id));

echo( lengthof3A = convert_mm2Inch(FoundationLength_od));
echo( lengthof3B = convert_mm2Inch(FoundationLength_id));

echo( lengthof4A = convert_mm2Inch(special_entry_width));
echo( lengthof4B = convert_mm2Inch(special_entry_width));

echo( lengthof5A = convert_mm2Inch(special_entry_width));
echo( lengthof5B = convert_mm2Inch(special_entry_width));

echo( lengthof6A = convert_mm2Inch(entry_length));
echo( lengthof6B = convert_mm2Inch(entry_length));

echo( lengthof7A = convert_mm2Inch(entry_length));
echo( lengthof7B = convert_mm2Inch(entry_length));

echo( lengthof8A = convert_mm2Inch(entry_width_od));
echo( lengthof8B = convert_mm2Inch(entry_width_id));



// // echo(board_1A);
// echo
//     (
//         HouseWidth = convert_mm2Inch(HouseWidth), 
//         HouseLength = convert_mm2Inch(HouseLength), 
//         westwall_1a = convert_mm2Inch(FoundationWidth_od),
//         westwall_1b = convert_mm2Inch(FoundationWidth_id),
//         FoundationWidth_od = convert_mm2Inch(FoundationWidth_od), 
//         FoundationWidth_id = convert_mm2Inch(FoundationWidth_id),
//         block_width = convert_mm2Inch(block_width),
//         footer_width = convert_mm2Inch(footer_width)
//     );

// echo
//     (
//         FoundationWidth_od_inches = convert_mm2Inch(FoundationWidth_od), 
//         FoundationWidth_id_inches = convert_mm2Inch(FoundationWidth_id),
//         HouseWidth = convert_mm2Inch(HouseWidth)
//     );

// echo
//     (
//         FoundationLength_od_inches = convert_mm2Inch(FoundationLength_od), 
//         FoundationLength_id_inches = convert_mm2Inch(FoundationLength_id),
//         HouseWidth = convert_mm2Inch(HouseWidth),
//         HouseLength = convert_mm2Inch(HouseLength),
//         entry_width_od = convert_mm2Inch(entry_width_od),
//         entry_length_od = convert_mm2Inch(entry_length_od),
//         FoundationWidth_od = convert_mm2Inch(FoundationWidth_od)
//     );

block_1 = 
[
    "block_1",
    ["length" , block_length],
    ["depth" , block_width],
    ["height", block_height],
    ["move", [0, HouseLength/2 - block_width/2, 0]],
    ["rotate", [0,0, 0]]
];

footing1 = 
[
    "footing1",
    ["length" , footer_width],
    ["depth" , footer_width],
    ["height", block_height],
    ["move", [-footer_width - 20, FoundationLength_od/2 - footer_width/2 , 0]],
    ["rotate", [0,0, 0]]
];

block_2 = 
[
    "block_2",
    ["length" , block_length],
    ["depth" , block_width],
    ["height", block_height],
    ["move", [- HouseWidth/2 + block_width/2, 0, 0]],
    ["rotate", [0,0, 90]]
];

board_1A = 
[
    "board 1A",
    ["length" , FoundationWidth_od],
    ["depth" , form_board_depth],
    ["move", [0, FoundationLength_od/2, 0]],
    ["rotate", [0,0, 0]]
];

board_1B = 
[
    "board 1B",
    ["length" , FoundationWidth_id],
    ["depth" , form_board_depth],
    ["move", [0, FoundationLength_id/2, 0]],
    ["rotate", [0,0, 0]]
];

board_2A = 
[
    "board 2A",
    ["length" , FoundationLength_od],
    ["depth" , form_board_depth],
    ["move", [FoundationWidth_od/2, 0, 0]],
    ["rotate", [0,0, 90]]    
];

board_2B = 
[
    "board 2B",
    ["length" , FoundationLength_id],
    ["depth" , form_board_depth],
    ["move", [FoundationWidth_id/2, 0, 0]],
    ["rotate", [0,0, 90]]    
];

board_3A = 
[
    "board 3A",
    ["length" , FoundationLength_od],
    ["depth" , form_board_depth],
    ["move", [-FoundationWidth_od/2, 0, 0]],
    ["rotate", [0,0, 90]]    
];

board_3B = 
[
    "board 3B",
    ["length" , FoundationLength_id],
    ["depth" , form_board_depth],
    ["move", [-FoundationWidth_id/2, 0, 0]],
    ["rotate", [0,0, 90]]    
];

board_4A = 
[
    "board 4A",
    ["length" , special_entry_width],
    ["depth" , form_board_depth],
    ["move", [FoundationWidth_od/2 - special_entry_width/2, - FoundationLength_od/2, 0]],
    ["rotate", [0,0, 0]]    
];
board_4B = 
[
    "board 4B",
    ["length" , special_entry_width],
    ["depth" , form_board_depth],
    ["move", [FoundationWidth_id/2 - special_entry_width/2, - FoundationLength_id/2, 0]],
    ["rotate", [0,0, 0]]    
];

board_5A = 
[
    "board 5A",
    ["length" , special_entry_width],
    ["depth" , form_board_depth],
    ["move", [-FoundationWidth_od/2 + special_entry_width/2, - FoundationLength_od/2, 0]],
    ["rotate", [0,0, 0]]    
];
board_5B = 
[
    "board 5B",
    ["length" , special_entry_width],
    ["depth" , form_board_depth],
    ["move", [-FoundationWidth_id/2 + special_entry_width/2, - FoundationLength_id/2, 0]],
    ["rotate", [0,0, 0]]    
];

board_6A = 
[
    "board 6A",
    ["length" , entry_length],
    ["depth" , form_board_depth],
    ["move", 
        [
            entry_width_od/2, 
            - FoundationLength_od/2 - entry_length/2, 
            0
        ]
    ],
    ["rotate", [0,0, 90]]    
];
board_6B = 
[
    "board 6B",
    ["length" , entry_length],
    ["depth" , form_board_depth],
    ["move", 
        [
            (entry_width_od/2 - footer_width), 
            - FoundationLength_od/2 - entry_length/2 + footer_width, 
            0
        ]
    ],
    ["rotate", [0,0, 90]]    
];

board_7A = 
[
    "board 7A",
    ["length" , entry_length],
    ["depth" , form_board_depth],
    ["move", 
        [
            - (entry_width_od/2), 
            - FoundationLength_od/2 - entry_length/2, 
            0
        ]
    ],
    ["rotate", [0,0, 90]]    
];
board_7B = 
[
    "board 7B",
    ["length" , entry_length],
    ["depth" , form_board_depth],
    ["move", 
        [
            - (entry_width_od/2 - footer_width), 
            - FoundationLength_od/2 - entry_length/2 + footer_width, 
            0
        ]
    ],
    ["rotate", [0,0, 90]]    
];

board_8A = 
[
    "board 8A",
    ["length" , entry_width_od],
    ["depth" , form_board_depth],
    ["move", 
        [
            0, 
            - house_length_with_entry_od/2, 
            0
        ]
    ],
    ["rotate", [0,0, 0]]    
];
board_8B = 
[
    "board 8B",
    ["length" , entry_width_id],
    ["depth" , form_board_depth],
    ["move", 
        [
            0, 
            // - FoundationLength_id/2 - entry_length_od, 
            - (house_length_with_entry_od/2 - footer_width),
            // - HouseLength/2 - entry_length,
            0
        ]
    ],
    ["rotate", [0,0, 0]]    
];

build();

// echo(thevalue = convert_mm2Inch((FoundationWidth_od/2) - (entry_width_od/2)));



module build(args) 
{
    add_floor() ;
    add_block(footing1);    
    // // move(footing1) 
    // // board_rotate(footing1) 
    // translate([0, convert_in2mm(4)])
    // translate([0, HouseLength/2])
    // translate([0, -footer_width/2])
    // board(footing1);

    add_block(block_1);
    add_block(block_2);



    add_board(board_1A);
    add_board(board_1B);

    add_board(board_2A);
    add_board(board_2B);

    add_board(board_3A);
    add_board(board_3B);

    add_board(board_4A);
    add_board(board_4B);

    add_board(board_5A);
    add_board(board_5B);

    // #move(board_8A) board_rotate(board_8A) board(board_8A)
    add_board(board_8A);
    add_board(board_8B);

    add_board(board_6A);
    add_board(board_6B);

    add_board(board_7A);
    add_board(board_7B);

}

module add_floor() 
{
    %translate([-HouseWidth/2, -HouseLength/2])
    square([HouseWidth, HouseLength]);

    %translate([0, -1 * (HouseLength/2 + entry_length/2 )])
    square([entry_width, entry_length], center = true);
}

module add_board(dimensions)
{
    move(dimensions) board_rotate(dimensions) board(dimensions);
}

module add_block(dimensions)
{
    color("LightGrey") move(dimensions) board_rotate(dimensions) board(dimensions);    
}

module board(dimensions)
{
    square(size=[gdv(dimensions, "length"), gdv(dimensions, "depth")], center=true);
}

module board_rotate(dimensions)
{
    rotate(gdv(dimensions, "rotate")) children();
    
}

module move(dimensions)
{
    translate(gdv(dimensions, "move")) children();
}