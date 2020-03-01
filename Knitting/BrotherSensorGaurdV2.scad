/*
Orientation: looking at back of knitting head is Y axis.
X-> width
Y-> depth
Z-> height
*/

$fn=180;
//SG => Sensor Gaurd
GaurdDepth = 8;
ShellDepth =  2;
FullCavetyDepth = 10;
Cavety1Width = 31;
Cavety1Height = 5-0.5;
// Cavety2Width = 51;
Cavety2Height = 11;
Cavety3Width = 128;
// Cavety3Height = 5;
SlitWidth = 3;
//SH => Screw Head
SH_Height = 2;
SH_Width = 10;
SH_depth = 5;
SmSH_Height = 1;
SmSH_Width =2;
//TI => Tab Inserts 
TI_height = 8.5;
TI_width = 11.8;
TI_depth = 6;
TI_spaceBetween = 89.5;
//GB => Sensor Gaurd Bar
GB_height = 0;
GB_width = 0;
GB_depth = 0;

Build("button");
// trangle(10,10);
module Build(args) {
    if(args == "tabs")
    {
        CavetyOne("right");
        
        translate([Cavety1Width + 40,0,0])
        CavetyOne("left");
    }
    else if(args == "button")
    {
        // rotate(0,0,0)
        {
            union()
            {
                TabSpaceBetween =  TI_spaceBetween;
                Inserts(TI_width, TI_height, TI_depth, TabSpaceBetween);

                // Gaurd Bar
                GauradBarWidth = TabSpaceBetween + (2 * Cavety1Width) + (2 * TI_width);
                GauradBarZ = 2 * TI_depth;
                // echo(GauradBarWidth =GauradBarWidth, GauradBarZ=GauradBarZ);
                GauradBar( GauradBarWidth,
                        TI_height+7,
                        TI_depth,
                        -Cavety1Width,
                        -2,
                        GauradBarZ );            
            }
        }
    }
    else
    {
        basic();
    }
    
}

module GauradBar(width, height, depth, x, y, z)
{
    translate([x, y, z])
    union()
    {
        
        cube([width, height, depth], center = false);

        //Left
        translate([0, 0, depth/2])
        rotate([-90,0,0])
        cylinder(r=depth/2, h = height, center = false);
        
        //Right
        translate([width, 0, depth/2])
        rotate([-90,0,0])
        cylinder(r=depth/2, h = height, center = false);
    }
}


module Inserts(width, height, depth, spaceBetweenTabs)
{
        //Near Zero axis
        InsertTab(width, height, depth);

        // translate([width,0,0])
        // cube([spaceBetweenTabs,1,1]);
        
        //Far insert
        translate([spaceBetweenTabs + width, 0, 0])
        InsertTab(width, height, depth);
}


module InsertTab(width, height, depth)
{
    echo("InsertTab", width=width, height = height, depth = depth);
        handleHeight = 1.5 * depth;
        union()
        {
            gap = 3;

            TabTop(width, height, depth, gap);
            translate([0,0,depth])
            TabTransition(width, height, depth, gap);
            TabBottom(width, height, depth);
        }
}
module TabTransition(width, height, depth, gap)
{
    echo("TabTransition", width=width, height = height, depth = depth, gap=gap);
    difference()
    {
        // cube([width, height, depth/2], center=false);
        thisCube(width, height, depth/2, 2);
        translate([0, height, 0])
        //Cylindar center is at x=0, y=gap, z=gap 
        rotate([0,90,0])
        cylinder(r=gap, h=width, center=false);
    }
}
module TabSupport(width, height, depth, gap)
{
    translate([0, 0, depth])
    thisCube(width, height, depth, 2);
}
module TabTop(width, height, depth, gap)
{
    translate([0, 0, depth + gap])
    thisCube(width, height, 8, 2);
}
module TabBottom(width, height, depth)
{
    echo("TabBottom", width=width, height = height, depth = depth);
        echo("TabBottom", width=width, height = height, depth = depth);
    thisCube(width, height, depth, 2);
}

module thisCube(width, height, depth, mr)
{
    translate([mr/2,mr/2,mr/2])
    minkowski() 
    {
        cube([width-mr, height-mr, depth-mr], center=false);
        cylinder(mr, center=true)        ;
    }
}

module basic()
{
        rotate([-90,0,0])
        difference()
        {
            union()
            {    
                CavetyOne();

                //Main Gaurd
                translate([0, FullCavetyDepth-ShellDepth, 0])
                cube([Cavety3Width + 2 * Cavety1Width, GaurdDepth + ShellDepth, Cavety2Height], center=false);

                translate([2 * Cavety1Width + Cavety3Width,0,0])
                CavetyOne("left");
            }
            translate([ Cavety3Width + 2 * Cavety1Width, GaurdDepth + ShellDepth + FullCavetyDepth, 0])
            rotate([0,0,180])
            trangle(GaurdDepth, Cavety2Height);

            translate([ 0, 2 * FullCavetyDepth + 2 , Cavety2Height])
            rotate([180,0,0])
            trangle(GaurdDepth, Cavety2Height);
            
        }


}

module trangle(side, depth)
{
    echo(side = side, depth = depth);
    linear_extrude(height = depth)
    polygon(points=[[0,0],[side,0],[0,side]]);
}

module CavetyOne(side)
{

    if(side == "left") 
    {
        mirror([1, 0, 0]) EndTab();
    }
    else
    {
        EndTab();
    }
}

module EndTab()
{
    difference()
    {    
        union()
        {    
            cube([Cavety1Width, FullCavetyDepth+ShellDepth, Cavety1Height], center=false);
            translate([- SlitWidth, 0, 0])
            cube(size=[SlitWidth, FullCavetyDepth+ShellDepth, Cavety2Height], center=false);

        }
        translate([- SlitWidth,0,0])
        ScrewHeadInsert(FullCavetyDepth - SH_depth);
        translate([2,0,0])
        SmallScrewHeadInsert(FullCavetyDepth - SH_depth);
        }
}

module ScrewHeadInsert(depth) 
{
    cube(size=[SH_Width, depth, SH_Height]);
}

module SmallScrewHeadInsert(depth)
{
    cube(size=[SmSH_Width, depth, SmSH_Height]);
}