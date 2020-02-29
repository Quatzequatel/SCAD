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

GA_height = 8.5;
GA_width = 11.8;
CavetyDepth = 6;

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
        InsertTab(GA_width, GA_height, CavetyDepth);

    }
    else
    {
        basic();
    }
    
}

module InsertTab(width, height, depth, handle = true)
{
        handleHeight = 1.5 * depth;
        union()
        {
            cube(size=[width, height, depth], center=true);
            if(handle == true)
            {
                translate([0,0,depth])
                cylinder(r=2, h=handleHeight, center=true);                    
            }      
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
                //translate([Cavety1Width,FullCavetyDepth-ShellDepth,0])
                translate([0, FullCavetyDepth-ShellDepth, 0])
                cube([Cavety3Width + 2 * Cavety1Width, GaurdDepth + ShellDepth, Cavety2Height], center=false);

                translate([2 * Cavety1Width + Cavety3Width,0,0])
                CavetyOne("left");
            }
            translate([ Cavety3Width + 2 * Cavety1Width, GaurdDepth + ShellDepth + FullCavetyDepth, 0])
            rotate([0,0,180])
            trangle(GaurdDepth, Cavety2Height);

            #translate([ 0, 2 * FullCavetyDepth + 2 , Cavety2Height])
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