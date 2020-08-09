/*

*/
include <constants.scad>;
use <dictionary.scad>;

$fn=100;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

BracketThickness = 3 * NozzleWidth;
simple_corner_bracket = 
[
    "bracket",
        ["bracketHeight", InchTomm(3.5)],
        ["bracketDepth", InchTomm(1.5) + BracketThickness],
        ["bracketThickness", 6 * NozzleWidth],
        ["screwHoleCount", 3],
        ["screwHoleRadius", 2],
        ["screwHoleDepth", 2 * ( 6 * NozzleWidth)], 
        ["screwHole first offset", -InchTomm(0.25)],
        ["holes along axis", false],
        ["include support", false],
        ["support height", layers2Height(16)],
        ["support length", InchTomm(3.5)]        
];

exterior_corner_bracket = 
[
    "bracket",
        ["bracketHeight", InchTomm(1)],
        ["bracketDepth", InchTomm(3.5) + BracketThickness],
        ["bracketThickness", BracketThickness],
        ["screwHoleCount", 2],
        ["screwHoleRadius", 2],
        ["screwHoleDepth", 2 * BracketThickness], 
        ["screwHole first offset", InchTomm(1.25)],
        ["holes along axis", true],
        ["include support", false],
        ["support height", layers2Height(16)],
        ["support length", InchTomm(3.5)]        
];

/*
    this needs refactoring, the screw holes are wrong.
    screw holes should take into account thee first hole offset and evenly
    divide by distance.
*/
braced_inner_corner_4x4_bracket = 
[
    "bracket",
        ["bracketHeight", InchTomm(1.75)],
        ["bracketDepth", InchTomm(3.5) + BracketThickness],
        ["bracketThickness", 6 * NozzleWidth],
        ["screwHoleCount", 3],
        ["screwHoleRadius", 2],
        ["screwHoleDepth", 2 * BracketThickness], 
        ["screwHole first offset", InchTomm(1.25)],
        ["holes along axis", true],
        ["include support", true],
        ["support height", layers2Height(16)],
        ["support length", InchTomm(3.5)]
];

// BracketProperties = 
// [
//     "bracket",
//         ["bracketHeight", InchTomm(1)],
//         ["bracketDepth", InchTomm(3.5) + BracketThickness],
//         ["bracketThickness", BracketThickness],
//         ["screwHoleCount", 2],
//         ["screwHoleRadius", 2],
//         ["screwHoleDepth", 2 * BracketThickness], 
//         ["screwHole first offset", InchTomm(1.25)],
//         ["holes along axis", true],
//         ["include support", false],
//         ["support height", layers2Height(16)],
//         ["support length", InchTomm(3.5)]        
// ];

BracketProperties = simple_corner_bracket;

Build("BracketProperties");
debugEcho("BracketProperties", BracketProperties, true);

module Build(args) 
{
    if(args == "BracketProperties")
    {
        Bracket( properties = BracketProperties );        
    }
    // else if(args == "Bracket")
    // {
    //     Bracket( properties = BracketProperties );            
    // }
}

//this needs work.
// module CornerBracket( properties = "")
// {
//     bracketHeight = getDictionaryValue(properties, "bracketHeight");
//     bracketDepth = getDictionaryValue(properties, "bracketDepth");
//     bracketThickness = getDictionaryValue(properties, "bracketThickness");
//     screwHoleCount = getDictionaryValue(properties, "screwHoleCount");
//     screwHoleRadius = getDictionaryValue(properties, "screwHoleRadius"); 
//     screwHoleDepth = 2 * getDictionaryValue(properties, "bracketThickness");

//     difference()
//     {
//         union()
//         {
//             Bracket(properties);
//             translate([0,0, - bracketHeight])
//             cube(
//                 size = 
//                 [ 
//                     bracketDepth, 
//                     bracketDepth, 
//                     bracketThickness
//                 ], center=true);
//         }       

//         moveX = getMoveX(screwCount = screwHoleCount, screwRadius = screwHoleRadius, depth = bracketDepth);
//         moveY = getMoveY(screwCount = screwHoleCount, screwRadius = screwHoleRadius, depth = bracketDepth);

//         translate([moveX, moveY, -bracketThickness/2])
//         cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);   
        
//         translate([moveY, moveX, -bracketThickness/2])
//         cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true); 
//     }

//     function getMoveX(screwCount, screwRadius, depth) = screwCount > 1 ? depth / 2 : depth - 3 * screwRadius;
//     function getMoveY(screwCount, screwRadius, depth) = screwCount > 1 ? depth - 3 * screwRadius : depth - 3 * screwRadius;
// }

module Bracket( properties = "")
{
    bracketHeight = getDictionaryValue(properties, "bracketHeight");
    bracketDepth = getDictionaryValue(properties, "bracketDepth");
    bracketThickness = getDictionaryValue(properties, "bracketThickness");
    screwHoleCount = getDictionaryValue(properties, "screwHoleCount");
    screwHoleRadius = getDictionaryValue(properties, "screwHoleRadius"); 
    screwHoleDepth = 2 * getDictionaryValue(properties, "bracketThickness");
    parallel = getDictionaryValue(properties, "holes along axis");
    addSupport = getDictionaryValue(properties, "include support");
    supportLength = getDictionaryValue(properties, "support length");
    screwFirstOffset = getDictionaryValue(properties, "screwHole first offset");

    bracketPoints = 
    [
        [0,0], 
        [bracketDepth,0], 
        [bracketDepth, bracketThickness], 
        [bracketThickness,bracketThickness], 
        [bracketThickness, bracketDepth], 
        [0, bracketDepth]
    ];

    supportPoints = 
    [
        [0,0],
        [supportLength, 0], 
        [0, supportLength]
    ];

    moveX = bracketDepth / 2 + bracketThickness - screwFirstOffset;  
    moveY = bracketThickness - bracketThickness / 2;
    moveZ = parallel ? 
                bracketHeight / 2
                : bracketHeight / screwHoleCount;
    startZ = parallel ? 
                0 
                : moveZ / 2;

    union()
    {
        if(addSupport)
        {
            translate([BracketThickness,BracketThickness])
            linear_extrude(height = getDictionaryValue(properties, "support height"), center = false, convexity=10, twist=0) 
            polygon(points = supportPoints);            
        }
    
        difference()
        {
            linear_extrude(height = bracketHeight, center = false, convexity=10, twist=0) 
            {
                polygon(points = bracketPoints);        
            }

            #union()
            {
                screwHoles(forXside = false, 
                            parallel = parallel,
                            screwHoleCount = screwHoleCount, 
                            screwHoleRadius = screwHoleRadius,  
                            screwHoleDepth = screwHoleDepth,
                            moveX = moveX,
                            moveY = moveY,
                            moveZ = moveZ,
                            startZ = startZ
                            );

                screwHoles(forXside = true,
                            parallel = parallel,
                            screwHoleCount = screwHoleCount, 
                            screwHoleRadius = screwHoleRadius,  
                            screwHoleDepth = screwHoleDepth,
                            moveX = moveX,
                            moveY = moveY,
                            moveZ = moveZ,
                            startZ = startZ
                            );                
            }

        }
    }
}

module screwHoles( 
                    forXside = true, 
                    parallel = true,
                    screwHoleCount = undef,
                    screwHoleRadius = undef, 
                    screwHoleDepth = 2 * BracketThickness, 
                    moveX = 0,
                    moveY = 0,
                    moveZ = 0,
                    startZ = 0
                    )
{
    for(i = [0 : screwHoleCount - 1])
    {
        if(parallel)
        {
            if(forXside)
            {
                // echo(trans = [moveX/2 * (i + 1), moveY, moveZ + startZ]);
                #translate([moveX/2 * (i + 1), moveY, moveZ + startZ]) 
                rotate([90, 0, 0]) 
                cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);  
            }
            else
            {
                // echo(transElse = [moveY, moveX/2 * (i + 1),  moveZ + startZ]);
                translate([moveY, moveX/2 * (i + 1),  moveZ + startZ]) 
                rotate([0, 90, 0]) 
                cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);  
            }

        }
        else
        {
            if(forXside)
            {
                translate([moveX, moveY, moveZ * i  + startZ]) 
                rotate([90, 0, 0]) 
                cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);             
            }
            else
            {
                translate([moveY, moveX, moveZ * i  + startZ]) 
                rotate([0, 90, 0]) 
                cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);            
            }
        }
    }
}

