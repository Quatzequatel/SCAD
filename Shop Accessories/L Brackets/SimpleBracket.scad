/*

*/
$fn=100;
NozzleWidth = 1.2;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

Height = InchTomm(3.5);
BracketThickness = 6 * NozzleWidth;
BracketWidth = InchTomm(1.5) + BracketThickness;
ScrewHoleRadius = 2;
ScrewHoleCount = 3;


Build("Bracket");



module Build(args) 
{
    if(args == "CornerBracket")
    {
        CornerBracket(
                    bracketHeight = Height, 
                    bracketDepth = BracketWidth, 
                    bracketThickness = BracketThickness,
                    screwHoleCount = ScrewHoleCount,
                    screwHoleRadius = ScrewHoleRadius, 
                    screwHoleDepth = 2 * BracketThickness        
                );        
    }
    else if(args == "Bracket")
    {
        Bracket(
                    bracketHeight = Height, 
                    bracketDepth = BracketWidth, 
                    bracketThickness = BracketThickness,
                    screwHoleCount = ScrewHoleCount,
                    screwHoleRadius = ScrewHoleRadius, 
                    screwHoleDepth = 2 * BracketThickness        
                );            
    }

}

module CornerBracket( 
                bracketHeight = Height, 
                bracketDepth = BracketWidth, 
                bracketThickness = BracketThickness,
                screwHoleCount = ScrewHoleCount,
                screwHoleRadius = ScrewHoleRadius, 
                screwHoleDepth = 2 * BracketThickness
                )
{
    difference()
    {
        union()
        {
            Bracket();
            translate([0,0, -bracketThickness])
            cube(size=[bracketDepth, bracketDepth, bracketThickness], center=false);
        }       

        moveX = screwHoleCount > 1 ? bracketDepth / 2 : bracketDepth - 3 * screwHoleRadius;
        moveY = screwHoleCount > 1 ? bracketDepth - 3 * screwHoleRadius : bracketDepth - 3 * screwHoleRadius;

        translate([moveX, moveY, -bracketThickness/2])
        cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);   
        
        translate([moveY, moveX, -bracketThickness/2])
        cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true); 
    }
}

module Bracket( 
                bracketHeight = Height, 
                bracketDepth = BracketWidth, 
                bracketThickness = BracketThickness,
                screwHoleCount = ScrewHoleCount,
                screwHoleRadius = ScrewHoleRadius, 
                screwHoleDepth = 2 * BracketThickness
                )
{
    bracketPoints = 
    [
        [0,0], 
        [bracketDepth,0], 
        [bracketDepth, bracketThickness], 
        [bracketThickness,bracketThickness], 
        [bracketThickness, bracketDepth], 
        [0, bracketDepth]
    ];
    moveX = bracketDepth / 2 + bracketThickness;
    moveY = bracketThickness - bracketThickness / 2;
    moveZ = bracketHeight / screwHoleCount;
    startZ = moveZ / 2;

    difference()
    {
        linear_extrude(height = bracketHeight, center = false, convexity=10, twist=0) 
        {
            polygon(points = bracketPoints);        
        }
        screwHoles(forXside = false, 
                    screwHoleCount = screwHoleCount, 
                    screwHoleRadius = screwHoleRadius,  
                    screwHoleDepth = screwHoleDepth,
                    moveX = moveX,
                    moveY = moveY,
                    moveZ = moveZ,
                    startZ = startZ
                    );

        screwHoles(forXside = true,
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

module screwHoles( 
                    forXside = true, 
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
        if(!forXside)
        {
            translate([moveY, moveX, moveZ * i  + startZ]) 
            rotate([0, 90, 0]) 
            cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);            
        }
        else
        {
            translate([moveX, moveY, moveZ * i  + startZ]) 
            rotate([90, 0, 0]) 
            cylinder(r=screwHoleRadius, h= screwHoleDepth, center=true);             
        }
    }
}

