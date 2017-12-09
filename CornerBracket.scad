Width = 18.50;
Length = Width;
Height = Width;
WallThickness = 2.0;

function OuterWidth(w) = AddWall(w);
function OuterLength(l) = AddWall(l);
function OuterHeight(h) = AddWall(h);
function AddWall(length) = length + (2*WallThickness);


module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([wallThickness,wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module main()
{
    //do the final placement so it does not have to be adjusted everytime in Cura.
    translate([0,0,2*OuterHeight(Height)])
    rotate([0,180,0])
    difference()
    {
        union()
        {    
            translate([OuterWidth(Width),0,2*OuterHeight(Height)])
            rotate([0,90,0])
            squareTube(Width,Length,Height,WallThickness);
            squareTube(Width,Length,2*Height+AddWall(0),WallThickness);
        }
//this is a hack, but need to get it done quickly.        
//remove the top of the bracket so wood can be placed in after otherside is attached.
    translate([OuterWidth(Width),WallThickness,OuterHeight(Height)-0.5])
        {
        #cube([OuterWidth(Width)+1, Length, WallThickness+1], false);
        }
    }
}

main();