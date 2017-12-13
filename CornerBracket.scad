
Build_SpacerJig = 1;
Build_AngleBracket = 2;
Build_BracketWithGrove = 3;
Build_AttachemtnSpacer =4;
Build_CeilingBracket=5;
Build = Build_SpacerJig;


Width = 18.50;
Length = Width;
Height = Width;
WallThickness = (Build == Build_SpacerJig ?  8.0:2.0); //Changed for SpacerJig()
DoubleLength = 2*AddWall(Length);

ScrewDiameter = (Build == Build_SpacerJig ? 10 : 3.5);
SpacerWidth = (Build == Build_SpacerJig ? 7.5 : AddWall(ScrewDiameter)); //Changed for SpacerJig()
SpacerLength=Length;
SpacerHeight=4;
Grovelength=DoubleLength;

function OuterWidth(w) = AddWall(w);
function OuterLength(l) = AddWall(l);
function OuterHeight(h) = AddWall(h);
function AddWall(length) = length + (2*WallThickness);
function Middle(length) = length/2;
function AddWall2(length)=length + 4.0;
ScrewDiameter2 = 3.5;

module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo("squareTube()",OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight));
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([Build != Build_SpacerJig ? wallThickness : wallThickness+SpacerHeight, wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module angleBracket()
{
        //do the final placement so it does not have to be adjusted everytime in Cura.
    translate([0,0,DoubleLength])
    rotate([0,180,0])
    difference()
    {
        union()
        {    
            translate([OuterWidth(Width),0,DoubleLength])
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
//        echo("BracketWithGrove()-translate1",-Middle(SpacerHeight),Middle(AddWall(Width))-Middle(SpacerWidth+2.0),-1);
        translate([-WallThickness-1,Middle(AddWall(Width))-Middle(SpacerWidth+2.0),-1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(SpacerWidth+2.0, Grovelength+2,SpacerHeight);
//    echo("BracketWithGrove()-translate2",SpacerWidth+2.0, Grovelength+2,SpacerHeight);
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
    union()
    difference()
    {
        squareTube(Width,Length,DoubleLength,WallThickness);
        echo("SpacerJig()",Width,Length,Height,WallThickness);
        echo("SpacerJig()-translate",
            AddWall(Width)-WallThickness+SpacerHeight-0.5,
            Middle(AddWall(Width))-Middle(SpacerWidth+1.0));
        //insert groove.
        translate([AddWall(Width)-WallThickness+SpacerHeight-0.5,
                    Middle(AddWall(Width))-Middle(SpacerWidth+1.0),
                    -1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(SpacerWidth+1.0, AddWall(DoubleLength)+2,SpacerHeight +1);
        
        //insert screw head channel.
        echo("screw head channel",AddWall(ScrewDiameter)-WallThickness+SpacerHeight-0.5,
                    Middle(AddWall(Width))-Middle(SpacerWidth+1.0),
                    -1);
        translate([10,
                    11,
                    -1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(12, AddWall(DoubleLength)+2,SpacerHeight +1);
        
        //Drill hole
        translate([-1,Middle(AddWall(Length)),Middle(AddWall(DoubleLength))]) 
        rotate([0,0,90])
        rotate([90,0,0])
        cylinder($fn=100,h=2*WallThickness,d1=ScrewDiameter+2,d2=ScrewDiameter+2,center=false);
        
        //add bevel
        echo(69,35.5,35.5);
        translate([48,35.5,100]) 
        rotate([0,-135,0])
        rotate([90,0,0])
        cube([2*AddWall(Width),2*AddWall(Length),AddWall(Length)+2]);       
        //add spacer
        #translate([0,0,Middle(DoubleLength)])
        translate([AddWall(Width)-WallThickness+SpacerHeight-0.5,
            Middle(AddWall(Width))-Middle(SpacerWidth),
            -1])
        rotate([0,0,90])
        rotate([90,0,0])
        difference()
        {
            spacer(AddWall2(ScrewDiameter2), SpacerLength,SpacerHeight);
            translate([Middle(SpacerWidth), Middle(Length)],0)
            cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter2,d2=ScrewDiameter2,center=false);
        }
        

    }
    //holder
    translate([0,-0.5,Middle(DoubleLength)-SpacerLength])
    translate([AddWall(Width)-WallThickness+SpacerHeight,
    Middle(AddWall(Width))-Middle(SpacerWidth)-0.5,
    -1])
    rotate([0,0,90])
    rotate([90,0,0])
    difference()
    {
    spacer(AddWall2(ScrewDiameter2)+2, SpacerLength,SpacerHeight);
    translate([Middle(AddWall2(ScrewDiameter2)+2), Middle(Length)],0)
    cylinder($fn=100,h=Length,d1=ScrewDiameter2,d2=ScrewDiameter2,center=false);
    }
}

Rows = 1;
Columns = 1;

module main()
{
    build = Build_SpacerJig;
    for(x=[1:Rows], y=[1:Columns])
    {
        if(Build == Build_SpacerJig) 
        {
            translate([(Grovelength+5)*x,(SpacerLength+7)*y,0]) SpacerJig();
        }
        if(Build == Build_AngleBracket) 
        {
            translate([(Grovelength+5)*x,(SpacerLength+7)*y,0]) angleBracket();
        }    
        if(Build == Build_BracketWithGrove) 
        {
            translate([(Grovelength+5)*x,(SpacerLength+7)*y,0])BracketWithGrove();
        }    
        if(Build == Build_AttachemtnSpacer) 
        {
        translate([(SpacerWidth+5)*x,(SpacerLength+5)*y,0])attachmentSpacer();
        }    
        if(Build == Build_CeilingBracket) 
        {
        translate([(AddWall(Width)*3+1)*x,(SpacerLength+6)*y,0]) CeilingBracket();
        }    
    
        
    }
}


main();