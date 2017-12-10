

Width = 18.50;
Length = Width;
Height = Width;
WallThickness = 2.0;

function OuterWidth(w) = AddWall(w);
function OuterLength(l) = AddWall(l);
function OuterHeight(h) = AddWall(h);
function AddWall(length) = length + (2*WallThickness);
function Middle(length) = length/2;


module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([wallThickness,wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module angleBracket()
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

module BracketWithGrove()
{
        difference()
    {
    angleBracket();
        
        translate([-Middle(SpacerHeight),Middle(AddWall(Width))-Middle(SpacerWidth),-1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(SpacerWidth, Grovelength+2,SpacerHeight);
    
        translate([-AddWall(0)+1,-1.8,-5])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([Width,Length,AddWall(0)]);
        
                echo(sqrt(Width*Width*2)-AddWall(Width));
        translate([-AddWall(0)+1,-1.8,Grovelength+5])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([Width,Length,AddWall(0)]);
    }

}

module main()
{
    BracketWithGrove();
    //translate([5,5,0])attachmentSpacer();
}

ScrewDiameter=3.5;
SpacerWidth= AddWall(ScrewDiameter);
SpacerLength=Length;
SpacerHeight=6.0;
Grovelength=2*AddWall(Length);

module attachmentSpacer()
{
    difference()
    {

         spacer(SpacerWidth, SpacerLength,SpacerHeight);
        
        translate([Middle(SpacerWidth), Middle(Length)],0)
            cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    }
    
}

module spacer(spacerWidth, spacerLength,spacerHeight)
{
         cube([spacerWidth, spacerLength,spacerHeight]);
}



main();