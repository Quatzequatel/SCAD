

Width = 18.50;
Length = Width;
Height = Width;
WallThickness = 2.0; //Changed for SpacerJig()

function OuterWidth(w) = AddWall(w);
function OuterLength(l) = AddWall(l);
function OuterHeight(h) = AddWall(h);
function AddWall(length) = length + (2*WallThickness);
function Middle(length) = length/2;


module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo(OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight));
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
        cube([OuterWidth(Width)+1, Length, WallThickness+1], false);
        }
    }
}

module BracketWithGrove()
{
        difference()
    {
    angleBracket();
        echo(-Middle(SpacerHeight),Middle(AddWall(Width))-Middle(SpacerWidth+2.0),-1);
        translate([-WallThickness-1,Middle(AddWall(Width))-Middle(SpacerWidth+2.0),-1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(SpacerWidth+2.0, Grovelength+2,SpacerHeight);
//        cube([SpacerWidth+2.0, Grovelength+2,SpacerHeight]);
    echo(SpacerWidth+2.0, Grovelength+2,SpacerHeight);
        translate([-AddWall(0)+1,-1.8,-5])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([Width,Length,AddWall(0)]);
        
        translate([-AddWall(0)+1,-1.8,Grovelength+5])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([Width,Length,AddWall(0)]);
    }

    //add a spacer for each bracket.
//    translate([0,7.5,0])rotate([0,0,90])attachmentSpacer();
}


ScrewDiameter=3.5;
SpacerWidth= AddWall(ScrewDiameter); //Changed for SpacerJig()
SpacerLength=Length;
SpacerHeight=WallThickness+2;
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

module CeilingBracket()
{
    difference()
    {
    union()
    {
    squareTube(Width,Length,Height+AddWall(0),WallThickness);
        translate([-AddWall(Width),0,0]) cube([3*AddWall(Width),AddWall(Length),2*WallThickness]);
        
        translate([-AddWall(Width),WallThickness,2*WallThickness])
        rotate([90,0,0])
        cube([AddWall(Width),AddWall(Length),WallThickness]);
        
        translate([-AddWall(Width),AddWall(Width),2*WallThickness])
        rotate([90,0,0])
        cube([AddWall(Width),AddWall(Length),WallThickness]);

        translate([AddWall(Width),WallThickness,2*WallThickness])
        rotate([90,0,0])
        cube([AddWall(Width),AddWall(Length),WallThickness]);
        
        translate([AddWall(Width),AddWall(Width),2*WallThickness])
        rotate([90,0,0])
        cube([AddWall(Width),AddWall(Length),WallThickness]);
    }
    translate([-Middle(AddWall(Width)),Middle(AddWall(Length)),-1]) 
    cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    
    translate([Middle(AddWall(Width)),Middle(AddWall(Length)),-1]) 
    cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    
    translate([Middle(3*AddWall(Width)),Middle(AddWall(Length)),-1]) 
    cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    
    translate([-AddWall(Width),WallThickness+1,4]) 
    rotate([0,-45,0])
    rotate([90,0,0])
    cube([2*AddWall(Width),2*AddWall(Length),2*WallThickness]);
    
    translate([-AddWall(Width),AddWall(Length)+1,4]) 
    rotate([0,-45,0])
    rotate([90,0,0])
    cube([2*AddWall(Width),2*AddWall(Length),2*WallThickness]);
    
    translate([2*AddWall(Width),WallThickness+1,4]) 
    rotate([0,-45,0])
    rotate([90,0,0])
    cube([2*AddWall(Width),2*AddWall(Length),2*WallThickness]);
    
    translate([2*AddWall(Width),AddWall(Length)+1,4]) 
    rotate([0,-45,0])
    rotate([90,0,0])
    cube([2*AddWall(Width),2*AddWall(Length),2*WallThickness]);
}
    
}

module SpacerJig()
{
    difference()
    {
        squareTube(Width,Length,Height,WallThickness);
        translate([AddWall(Width)-WallThickness-1,Middle(AddWall(Width))-Middle(SpacerWidth+1.0),-1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(SpacerWidth+1.0, Grovelength+2,SpacerHeight);
        
        translate([-1,Middle(AddWall(Length)),Middle(AddWall(Height))]) 
        rotate([0,0,90])
        rotate([90,0,0])
        cylinder($fn=100,h=2*WallThickness,d1=ScrewDiameter+2,d2=ScrewDiameter+2,center=false);
    }
}

Rows = 1;
Columns = 4;

module main()
{
    for(x=[1:Rows], y=[1:Columns])
    {
//        SpacerJig();
//        translate([(Grovelength+5)*x,(SpacerLength+7)*y,0]) angleBracket();
    translate([(Grovelength+5)*x,(SpacerLength+7)*y,0])BracketWithGrove();
//    translate([(SpacerWidth+5)*x,(SpacerLength+5)*y,0])attachmentSpacer();
//        translate([(AddWall(Width)*3+1)*x,(SpacerLength+6)*y,0]) CeilingBracket();
    }
}


main();