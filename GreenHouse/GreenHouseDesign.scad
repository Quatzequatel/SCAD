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
// include <TrellisEnums.scad>;
include <constants.scad>;
include <GreenHouseProperties.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;
use <Construction.scad>;

use <box_extrude.scad>;

// ISDEBUGEMODE = false;


//Note: moved definitions to GreenHouseProperties.scad



// EntryRoofWidth = EntryWidth/2; //((Width - in2ft(Board2x4.x))/2);
// EntryRoofHeight = EntryRoofWidth * sin(RoofAngle);
// EntryRoofLength = hypotenuse(EntryRoofHeight, EntryRoofWidth);// sqrt((EntryRoofHeight * EntryRoofHeight) + (EntryRoofWidth * EntryRoofWidth));
// WallHeight = MaxHeight - RoofHeight;
// EntryDimensions = [Length, Width, MaxHeight];
// EntryRoofDimensions = [Width/2, RoofLength,  hypotenuse(RoofHeight, RoofWidth), RoofAngle ];


Build();

module Build(args) 
{
    echo("Base Dimensions:");
    echo(Length = convert_mm2Feet(mm = HouseDimensions.y));
    echo(Width = convert_mm2Feet(mm = HouseDimensions.x));
    echo(Height = convert_mm2Feet(mm = HouseDimensions.z + RoofDimensions.z));
    echo(RoofAngle = RoofAngle);
    echo(RoofHeight = convert_mm2Feet(mm = RoofDimensions.z));
    echo(RoofWidth = convert_mm2Feet(mm = RoofDimensions.x));
    echo(WallHeight = convert_mm2Feet(mm = HouseDimensions.z));
    echo(RoofLength = convert_mm2Feet(mm = RoofDimensions.y));
    echo(EntryRoofDimensions_inches = convertV_mm2Inch(mm = EntryRoofDimensions));
    echo(EntryRoofAngle = EntryRoofDimensions[3]);
    // echo(sin45 = sin(45));

    // SideView();
    // translate([Width/2,0,0])
    // rotate([0,0, 90])
    simpleView(true, true, false);

    // HouseFrame();
    // EntryFrame();
    // RoofFrame();

    HouseFrame2();
    EntryFrame2();
    // RoofFrame2();
    // EntryRoofFrame2();

}

module HouseFrame2()
{
    isFinished = true;
    //back wall
    translate([0, 0, 0])
    rotate([90, 0, 90]) 
    {
        color("aqua")
        Wall(
            wallOD = [HouseDimensions.y, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
        // drawFrame([0,0,0], HouseDimensions.z, HouseDimensions.x, Board2x4);
    }

    //right side wall
    translate([Board2x4.y, HouseDimensions.y, 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [HouseDimensions.x - Board2x4.y, HouseDimensions.y, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }
    
    //left side wall
    translate([Board2x4.y, Board2x4.y, 0])
    rotate([90, 0, 0]) 
    {
        color("red")
        Wall(
            wallOD = [HouseDimensions.x - Board2x4.y, HouseDimensions.y, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //front wall  left side
    translate([HouseDimensions.x, 0, 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [HouseDimensions.y/2 - EntryDimensions.x/2, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //front wall  right side
    translate([HouseDimensions.x, HouseDimensions.y - (HouseDimensions.y/2 - EntryDimensions.x/2), 0])
    rotate([90, 0, 90]) 
    {
        color("blue")
        Wall(
            wallOD = [HouseDimensions.y/2 - EntryDimensions.x/2, HouseDimensions.x, HouseDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }
}

module EntryFrame2()
{
    isFinished = true;
    //left side wall
    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            HouseDimensions.y - (HouseDimensions.y/2 - EntryDimensions.x/2) + Board2x4.y, 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x - Board2x4.y, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //right side wall
    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            (HouseDimensions.y/2 - EntryDimensions.x/2), 
            0
        ]
    )
    rotate([90, 0, 0]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x - Board2x4.y, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            finished = isFinished
        );        
    }

    //Doorway
    translate
    (
        [
            HouseDimensions.x + EntryDimensions.x - Board2x4.y, 
            (HouseDimensions.y/2 - EntryDimensions.x/2), 
            0
        ]
    )
    rotate([90, 0, 90]) 
    {
        color("yellow")
        Wall(
            wallOD = [EntryDimensions.x, EntryDimensions.y, EntryDimensions.z], 
            board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
            spacing = StudSpacing,
            includeStuds = false,
            finished = isFinished
        );        
    }    
}

module RoofFrame2()
{
     
     debugEcho("RoofFrame2([0]=RoofDimensions, [1]=Board2x4, [2]=StudSpacing)",[RoofDimensions, Board2x4, StudSpacing], true);
    //back
    translate([0, 0, HouseDimensions.z + Board2x4.y])
    rotate([90, 0, 90]) 
    Roof
    (
        roofOD = RoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = false,
        includeStuds = true,
        finished = false
    );

    //front
    mirror([1,0,0])
    translate([-(HouseDimensions.x + Board2x4.y), 0, HouseDimensions.z + Board2x4.y])
    //  translate([HouseDimensions.x + Board2x4.y, HouseDimensions.y, HouseDimensions.z + Board2x4.y])
    rotate([90, 0, 90]) 
    Roof
    (
        roofOD = RoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = false,
        includeStuds = true,
        finished = true
    );
}

module EntryRoofFrame2()
{
    echo(EntryRoofFrame2 = 1, EntryRoofDimensions=EntryRoofDimensions);
    //left
    // translate([0, 0, HouseDimensions.z + Board2x4.y])
    // rotate([90, 0, 90]) 
    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            HouseDimensions.y - (HouseDimensions.y/2 - EntryDimensions.x/2) + Board2x4.y, 
            HouseDimensions.z + Board2x4.y
        ]
    )
    rotate([90, 0, 0])    
    Roof
    (
        roofOD = EntryRoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = true,
        includeStuds = true,
        finished = true
    );

    translate
    (
        [
            HouseDimensions.x + Board2x4.y, 
            (HouseDimensions.y/2 - EntryDimensions.x/2) - Board2x4.y , 
            HouseDimensions.z + Board2x4.y
        ]
    )
    mirror([0,1,0])
    rotate([90, 0, 0])    
    Roof
    (
        roofOD = EntryRoofDimensions, //[x,y,z,angle]
        board = Board2x4, //vSetValue(Board2x4, 2, convert_in2mm(72)-Board2x4.x), 
        spacing = StudSpacing,
        includeHeader = true,
        includeStuds = true,
        finished = true
    );
}

module simpleView(showentry = true, showRoof = true, showwalls = true)
{
    {
        sidePoints = housePoints(houseDi = HouseDimensions, roofDi = RoofDimensions, p0 = [0,0]);

        // echo(sidePoints = sidePoints);
        // echo(sidePoints = convertVPts_mm2Inch(sidePoints));

        translate([0,HouseDimensions.y,0])
        rotate([90,0,0])
        %linear_extrude(height = HouseDimensions.y)
        polygon(points=sidePoints);

    }
    if(showentry)
    {
            entryPoints = housePoints(houseDi = EntryDimensions, roofDi = EntryRoofDimensions, p0 = [0,0]);
            echo(entryPoints = entryPoints);
            echo(EntryDimensions = EntryDimensions, EntryRoofDimensions = EntryRoofDimensions);

            translate([HouseDimensions.x - (EntryRoofDimensions.y - EntryDimensions.x), HouseDimensions.y/2 - EntryDimensions.x/2,0])
            rotate([90,0,90])
            difference()
            {
                linear_extrude(height = EntryRoofDimensions.y)
                polygon(points=entryPoints);

                union()
                {
                    linear_extrude(height = EntryRoofDimensions.y/2)
                    square([EntryDimensions.x + 1,EntryDimensions.z + 1], center = false);
                    tripoints = [
                        [0,EntryDimensions.z],
                        [EntryRoofDimensions.y/2,EntryDimensions.z],
                        [0, EntryRoofDimensions.y/2 ]
                        ];
                        echo(tripoints=tripoints);
                        echo(tripoints=convertVPts_mm2Inch(tripoints));
                    // translate([0,EntryDimensions.z,0])
                    // !#rotate([0,-90,90])
                    // translate([0,-EntryDimensions.z,0])
                    // linear_extrude(height = EntryDimensions.x)
                    // polygon(points=tripoints);
                }
            }


            //left garden box
            translate([HouseDimensions.x, 0, 0])
            // linear_extrude(height = EntryRoofDimensions.y)
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([EntryDimensions.x,(HouseDimensions.y - EntryDimensions.x)/2], center = false);

            //right garden box
            translate([HouseDimensions.x, HouseDimensions.y - (HouseDimensions.y - EntryDimensions.x)/2 , 0])
            // linear_extrude(height = EntryRoofDimensions.y)
            color("white") box_extrude(height = convert_ft2mm(2), shell_thickness = convert_in2mm(in = 2)) 
            square([EntryDimensions.x,(HouseDimensions.y - EntryDimensions.x)/2], center = false);
    }

}

// module EntryRoofFrame2()
// {

// }

function housePoints(houseDi, roofDi, p0) = 
[
    p0,                             //p0
    [houseDi.x, p0.y],           //p1
    [houseDi.x, houseDi.z],   //p2
    [houseDi.x/2, houseDi.z + roofDi.z],   //p3
    [p0.x, houseDi.z]           //p4
];


function half(v) = 
[
   for(i = [0 : len(v)-1]) (v[i]/2) 
];


