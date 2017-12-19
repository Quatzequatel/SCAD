
Build_SpacerJig = 1;
Build_AngleBracket = 2;
Build_BracketWithGrove = 3;
Build_AttachemtnSpacer =4;
Build_CeilingBracket=5;
Build_hookBracket=6;
Build_PowerStripHolder=7;
Build = Build_PowerStripHolder;


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
function AddExtra(item, extra) = item+extra;
function Middle(length) = length/2;
function AddWall2(length)=length + 4.0;
ScrewDiameter2 = 3.5;
function DoubleLength(value=DoubleLength) = (value==DoubleLength)? value: value*2;
function SpacerHeight(extra=0) = SpacerHeight+extra;
function SpacerLength(extra=0) = SpacerLength+extra;
function SpacerWidth(extra=0) = SpacerWidth+extra;

module squareTube(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo("squareTube()",OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight),wallThickness);
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([Build != Build_SpacerJig ? wallThickness : wallThickness+SpacerHeight, wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}

module squareTube2(innerWidth, innerDepth, innerHeight, wallThickness)
{
    difference()
    {
    echo("squareTube()",OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight));
    cube([OuterWidth(innerWidth), OuterLength(innerDepth), OuterHeight(innerHeight)], false);
    translate([Build != Build_SpacerJig ? wallThickness : wallThickness+SpacerHeight, wallThickness,-1])
        cube([innerWidth, innerDepth, OuterHeight(innerHeight)+2], false);
    }
}


//Changed to be immutable method.
module angleBracket(width,length,height,wallThickness)
{
        //do the final placement so it does not have to be adjusted everytime in Cura.
    translate([0,0,DoubleLength])
    rotate([0,180,0])
    difference()
    {
        union()
        {    
            translate([OuterWidth(width),0,DoubleLength()])
            rotate([0,90,0])
            squareTube(width,length,height,wallThickness);
            squareTube(width,length,AddWall(2*height),wallThickness);
        }
//this is a hack, but need to get it done quickly.        
//remove the top of the bracket so wood can be placed in after otherside is attached.
    translate([OuterWidth(width),wallThickness,OuterHeight(height)-0.5])
        {
        cube([OuterWidth(width)+1, length, wallThickness+1], false);
        }
    }
}

module hookBracket()
{
        //do the final placement so it does not have to be adjusted everytime in Cura.
    translate([0,0,DoubleLength])
    rotate([0,180,0])
    difference()
    {
        union()
        {   //squareTube
            //             22.5               
            translate([0,0,AddWall(Height)])
            rotate([0,-90,0])
            squareTube2(Width,Length,AddWall2(2*Height),WallThickness);
            
            translate([-Middle(DoubleLength),Middle(AddWall(Width)),11.5]) 
            rotate([0,0,90])
            linear_extrude(height = AddWall(Height), center = true, convexity = 10, scale=[4.3,8.6], $fn=100)
            circle(r = 2.6);            
        }
        #translate([ -Middle(DoubleLength), Middle(OuterWidth(Width)),0])
        cylinder($fn=100,h=20,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    }
}

module Groove(grooveLength,grooveWidth, thickness, headLength)
{
        //Insert Grove
        translate([-thickness-1,Middle(AddWall(headLength))-Middle(AddExtra(grooveWidth,2.0)),-1])
        rotate([0,0,90])
        rotate([90,0,0])
        spacer(AddExtra(grooveWidth,2.0), AddExtra(grooveLength,2),thickness*2);

        //Add bottom bevel
        translate([-AddWall(0)+1,-1.8,-5])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([headLength,headLength,AddWall(0)]);
        
        //Add top bevel
        translate([-AddWall(0)+1,-1.8,AddExtra(grooveLength,5)])
        rotate([0,45,90])
        rotate([90,0,0])
        cube([headLength,headLength,AddWall(0)]);
}

//Changed to be immutable method.
module BracketWithGrove(width,length,height,wallThickness,grooveLength,grooveWidth, thickness)
{
        difference()
    {
    angleBracket(width,length,height,wallThickness);
        Groove(grooveLength,grooveWidth, wallThickness,length);

    }
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
                translate([-AddWall(Width),0,0]) cube([3*AddWall(Width),AddWall(Length),DoubleLength(WallThickness)]);
                
                translate([-AddWall(Width),WallThickness,DoubleLength(WallThickness)])
                rotate([90,0,0])
                cube([AddWall(Width),AddWall(Length),WallThickness]);
                
                translate([-AddWall(Width),AddWall(Width),DoubleLength(WallThickness)])
                rotate([90,0,0])
                cube([AddWall(Width),AddWall(Length),WallThickness]);

                translate([AddWall(Width),WallThickness,DoubleLength(WallThickness)])
                rotate([90,0,0])
                cube([AddWall(Width),AddWall(Length),WallThickness]);
                
                translate([AddWall(Width),AddWall(Width),DoubleLength(WallThickness)])
                rotate([90,0,0])
                cube([AddWall(Width),AddWall(Length),WallThickness]);
            }
        translate([-Middle(AddWall(Width)),Middle(AddWall(Length)),-1]) 
        cylinder($fn=100,h=SpacerHeight(2),d1=ScrewDiameter,d2=ScrewDiameter,center=false);
        
        translate([Middle(AddWall(Width)),Middle(AddWall(Length)),-1]) 
        cylinder($fn=100,h=SpacerHeight(2),d1=ScrewDiameter,d2=ScrewDiameter,center=false);
        
        translate([Middle(3*AddWall(Width)),Middle(AddWall(Length)),-1]) 
        cylinder($fn=100,h=SpacerHeight(2),d1=ScrewDiameter,d2=ScrewDiameter,center=false);
        
        translate([-AddWall(Width),WallThickness+1,4]) 
        rotate([0,-45,0])
        rotate([90,0,0])
        cube([2*AddWall(Width),2*AddWall(Length),DoubleLength(WallThickness)]);
        
        translate([-AddWall(Width),AddWall(Length)+1,4]) 
        rotate([0,-45,0])
        rotate([90,0,0])
        cube([2*AddWall(Width),2*AddWall(Length),DoubleLength(WallThickness)]);
        
        translate([2*AddWall(Width),WallThickness+1,4]) 
        rotate([0,-45,0])
        rotate([90,0,0])
        cube([2*AddWall(Width),2*AddWall(Length),DoubleLength(WallThickness)]);
        
        translate([2*AddWall(Width),AddWall(Length)+1,4]) 
        rotate([0,-45,0])
        rotate([90,0,0])
        cube([2*AddWall(Width),2*AddWall(Length),DoubleLength(WallThickness)]);
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


module PowerStripHolder()
{
    baseWidth = 74.0;
    baseHeight=23.0;
    basePlugDepth = 35.0;
    basePlugLipDepth=29.5;
    baseTopDepth=41;
    baseSeamDepth=19.0;
    seamToBevelDepth=16.0;
    powerCordDiameter=9.5;
    
    //PowerStripHolderBottom(baseWidth,baseHeight,basePlugDepth,WallThickness, Width,Length);
    PowerStripHolderTop(baseWidth,baseHeight,baseTopDepth,WallThickness, Width,Length,powerCordDiameter);
}
module PowerStripHolderBottom(width, height, depth, wallThickness, widthBracket, depthBracket)
{
    union()
    {
        squareTube(width, depth, height, wallThickness);
        translate([wallThickness,wallThickness,0])
        cube([width,depth,2]);
        
        difference()
        {
            //Right Bracket
            translate([OuterWidth(width),Middle(depth)/2,0])
            squareTube(widthBracket,depthBracket,height,wallThickness);    
            //Groove for Right Bracket
            translate([OuterWidth(width)+OuterWidth(widthBracket),Middle(depth)/2,1])
            Groove(AddExtra(height,2), SpacerWidth, WallThickness, Width);  
        }
        
        difference()
        {
            //Left Bracket
            translate([-OuterWidth(widthBracket),Middle(depth)/2,0])
            squareTube(widthBracket,depthBracket,height,wallThickness);    
            //Groove for Left Bracket
            translate([-OuterWidth(widthBracket)+2,Middle(depth)/2,1])
            Groove(AddExtra(height,2), SpacerWidth, WallThickness, Width); 
        }            
    }
}
module PowerStripHolderTop(width, height, depth, wallThickness, widthBracket, depthBracket, powerCordDiameter)
{
    difference()
    {
        PowerStripHolderBottom(width, height, depth, wallThickness, widthBracket, depthBracket);
        translate([Middle(width), Middle(depth),0])
        cylinder($fn = 100,h=20, d=powerCordDiameter,center=true);
        
        translate([Middle(width), depth-5,0])
        rotate([90,0,0])
        cylinder($fn = 100,h=Middle(depth)+7, d=powerCordDiameter,center=true);
        
        translate([Middle(width), depth+3,Middle(depth)])
        rotate([0,0,90])
        cylinder($fn = 100,h=depth, d=powerCordDiameter,center=true);
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
            translate([(Grovelength+5)*x,(SpacerLength(7))*y,0]) SpacerJig();
        }
        if(Build == Build_AngleBracket) 
        {
            translate([(Grovelength+5)*x,(SpacerLength(7))*y,0]) 
                angleBracket(Width,Length,Height,WallThickness);
        }    
        if(Build == Build_BracketWithGrove) 
        {
            translate([(Grovelength+5)*x,(SpacerLength(7))*y,0])
                BracketWithGrove(Width,Length,Height,WallThickness, DoubleLength(), SpacerHeight());
        }    
        if(Build == Build_AttachemtnSpacer) 
            {
                translate([(SpacerWidth+5)*x,(SpacerLength(5))*y,0])attachmentSpacer();
            }    
        if(Build == Build_CeilingBracket) 
            {
                translate([(AddWall(Width)*3+1)*x,(SpacerLength(6))*y,0]) CeilingBracket();
            }    
        if(Build == Build_hookBracket)
        {
            difference()
            {
            hookBracket();
            rotate([0,90,0])
            Groove(Grovelength, SpacerWidth, WallThickness, Width);
            }
        }
        if(Build==Build_PowerStripHolder)
        {
            PowerStripHolder();
        }
    }
}


main();