/*

*/

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

Height = InchTomm(1.75);
BracketThickness = 6 * NozzleWidth;
BracketWidth = InchTomm(4) + BracketThickness;
ScrewHoleRadius = 2;
ScrewHoleCount = 3;


BracketProperties = 
[
    "bracket",
        ["bracketHeight", Height],
        ["bracketDepth", BracketWidth],
        ["bracketThickness", BracketThickness],
        ["screwHoleCount", ScrewHoleCount],
        ["screwHoleRadius", ScrewHoleRadius],
        ["screwHoleDepth", 2 * BracketThickness], 
        ["holes along axis", true],
        ["include support", true]
];


Build("Bracket");
debugEcho("BracketProperties", BracketProperties, true);



module Build(args) 
{
    if(args == "CornerBracket")
    {
        CornerBracket( properties = BracketProperties );        
    }
    else if(args == "Bracket")
    {
        Bracket( properties = BracketProperties );            
    }
}

module CornerBracket( properties = "")
{
    bracketHeight = getDictionaryValue(properties, "bracketHeight");
    bracketDepth = getDictionaryValue(properties, "bracketDepth");
    bracketThickness = getDictionaryValue(properties, "bracketThickness");
    screwHoleCount = getDictionaryValue(properties, "screwHoleCount");
    screwHoleRadius = getDictionaryValue(properties, "screwHoleRadius"); 
    screwHoleDepth = 2 * getDictionaryValue(properties, "bracketThickness");

    difference()
    {
        union()
        {
            Bracket(properties);
            translate([0,0, - bracketHeight])
            cube(
                size = 
                [ 
                    bracketDepth, 
                    bracketDepth, 
                    bracketThickness
                ], center=false);
        }       

        moveX = getMoveX(screwCount = screwHoleCount, screwRadius = screwHoleRadius, depth = bracketDepth);
        moveY = getMoveY(screwCount = screwHoleCount, screwRadius = screwHoleRadius, depth = bracketDepth);

        translate([moveX, moveY, -bracketThickness/2])
        cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);   
        
        translate([moveY, moveX, -bracketThickness/2])
        cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true); 
    }

    function getMoveX(screwCount, screwRadius, depth) = screwCount > 1 ? depth / 2 : depth - 3 * screwRadius;
    function getMoveY(screwCount, screwRadius, depth) = screwCount > 1 ? depth - 3 * screwRadius : depth - 3 * screwRadius;
}

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
        [bracketDepth, 0], 
        [0, bracketDepth]
    ];

    moveX = bracketDepth / 2 + bracketThickness;
    moveY = bracketThickness - bracketThickness / 2;
    moveZ = bracketHeight / screwHoleCount;
    startZ = moveZ / 2;

    union()
    {
        if(addSupport)
        {
            linear_extrude(height = bracketThickness, center = false, convexity=10, twist=0) 
            polygon(points = supportPoints);            
        }
    
        difference()
        {
            linear_extrude(height = bracketHeight, center = false, convexity=10, twist=0) 
            {
                polygon(points = bracketPoints);        
            }
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

module screwHoles( 
                    forXside = true, 
                    parallel = true,
                    screwHoleCount = ScrewHoleCount,
                    screwHoleRadius = ScrewHoleRadius, 
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
                translate([moveX/2 * (i + 1), moveY, moveZ + startZ]) 
                rotate([90, 0, 0]) 
                cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);  
            }
            else
            {
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

