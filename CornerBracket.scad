
Build_SpacerJig = 1;
Build_AngleBracket = 2;
Build_BracketWithGrove = 3;
Build_AttachemtnSpacer =4;
Build_CeilingBracket=5;
Build_hookBracket=6;
Build_PowerStripHolder=7;
SubBuild_PowerStripBottom= 1;
SubBuild_PowerStripTop= 2;

Build = Build_AttachemtnSpacer;
SubBuild=SubBuild_PowerStripTop;


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
            squareTube(Width,Length,AddWall2(2*Height),WallThickness);
            
            translate([-Middle(DoubleLength),Middle(AddWall(Width)),11.5]) 
            rotate([0,0,90])
            linear_extrude(height = AddWall(Height), center = true, convexity = 10, scale=[4.3,8.6], $fn=100)
            circle(r = 2.6);            
        }
        translate([ -Middle(DoubleLength), Middle(OuterWidth(Width)),0])
        cylinder($fn=100,h=20,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    }
}

module Groove(grooveLength,grooveWidth, thickness, headLength)
{
    cubeSize=[headLength,headLength,AddWall(0)];
    grooveSize=[AddExtra(grooveWidth,2), AddExtra(grooveLength,2),thickness*2];
    rotateBevel=[90,45,90];
    bevelxMove= -AddWall(0)+1;
    bevelyMove= -1.8;
    
        //Insert Grove
        translate([-thickness-1,Middle(AddWall(headLength))-Middle(AddExtra(grooveWidth,2.0)),-1])
        rotate([90,0,90])
        cube(grooveSize);

        //Add bottom bevel
        translate([bevelxMove,bevelyMove,-5])
        rotate(rotateBevel)
        cube(cubeSize);
        
        //Add top bevel
        translate([bevelxMove,bevelyMove,AddExtra(grooveLength,5)])
        rotate(rotateBevel)
        cube(cubeSize);
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

        cube([SpacerWidth, SpacerLength,SpacerHeight]);
        
        translate([Middle(SpacerWidth), Middle(Length)],0)
            cylinder($fn=100,h=SpacerHeight,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    }
}

module CeilingBracket()
{
    difference()
    {
        union()
            {
                wallSize    = [AddWall(Width),AddWall(Length),WallThickness];
                wallRotation= [90,0,0];
                toleftWall  = -AddWall(Width);
                torightWall = AddWall(Width);
                tofrontWall = WallThickness;
                tobackWall  = AddWall(Width);
                toBottom    = DoubleLength(WallThickness);
                
                //center bracket
                squareTube(Width,Length,Height+AddWall(0),WallThickness);
                translate([-AddWall(Width),0,0]) cube([3*AddWall(Width)
                    ,AddWall(Length),DoubleLength(WallThickness)]);
                
                supportWall(wallSize, wallRotation, toleftWall,  tofrontWall, toBottom);
                supportWall(wallSize, wallRotation, toleftWall,  tobackWall,  toBottom);
                supportWall(wallSize, wallRotation, torightWall, tofrontWall, toBottom);
                supportWall(wallSize, wallRotation, torightWall, tobackWall,  toBottom);
            }
        
            leftHole=-Middle(AddWall(Width));
            centerHole=Middle(AddWall(Width));
            rightHole=Middle(3*AddWall(Width));
            toTheMiddle=Middle(AddWall(Length));

            screwHole(SpacerHeight(2),ScrewDiameter,leftHole,toTheMiddle,-1);
            screwHole(SpacerHeight(2),ScrewDiameter,centerHole,toTheMiddle,-1);
            screwHole(SpacerHeight(2),ScrewDiameter,rightHole,toTheMiddle,-1);
        
            //cut-a-ways to make brackets have an angle
            cubeSize = [2*AddWall(Width),2*AddWall(Length),DoubleLength(WallThickness)];
            rotate45 = [90,-45,0];
            toTheLeft=-AddWall(Width);
            toTheRight=2*AddWall(Width);
            toFront=WallThickness+1;
            toBack=AddWall(Length)+1;
            
            angleSupport(cubeSize,rotate45,toTheLeft,toFront,4);
            angleSupport(cubeSize,rotate45,toTheLeft,toBack,4);
            angleSupport(cubeSize,rotate45,toTheRight,toFront,4);
            angleSupport(cubeSize,rotate45,toTheRight,toBack,4);
    }
}

module supportWall(cubeSize,rotation,xMove,yMove,zMove)
{
    angleSupport(cubeSize,rotation,xMove,yMove,zMove);
}

module screwHole(height,diameter,xMove,yMove,zMove)
{
    translate([xMove,yMove,zMove]) 
    cylinder($fn=100,h=height,d=diameter,center=false);
}

module angleSupport(cubeSize,rotation,xMove,yMove,zMove)
{
    translate([xMove,yMove,zMove]) 
    rotate(rotation)
    cube(cubeSize);
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
        cube([SpacerWidth+1.0, AddWall(DoubleLength)+2,SpacerHeight +1]);
        
        //insert screw head channel.
        echo("screw head channel",AddWall(ScrewDiameter)-WallThickness+SpacerHeight-0.5,
                    Middle(AddWall(Width))-Middle(SpacerWidth+1.0),
                    -1);
        translate([10,
                    11,
                    -1])
        rotate([0,0,90])
        rotate([90,0,0])
        cube([12, AddWall(DoubleLength)+2,SpacerHeight +1]);
        
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
            cube([AddWall2(ScrewDiameter2), SpacerLength,SpacerHeight]);
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
    cube([AddWall2(ScrewDiameter2)+2, SpacerLength,SpacerHeight]);
    translate([Middle(AddWall2(ScrewDiameter2)+2), Middle(Length)],0)
    cylinder($fn=100,h=Length,d1=ScrewDiameter2,d2=ScrewDiameter2,center=false);
    }
}

module PowerStripHolder(which)
{
    baseWidth = 74.0;
    baseHeight=28.0;
    basePlugDepth = 35.0;
    basePlugLipDepth=29.5;
    baseTopDepth=41;
    baseSeamDepth=19.0;
    seamToBevelDepth=16.0;
    powerCordDiameter=11.0;
    includeBottomBracket=false;
    
    if(which == SubBuild_PowerStripBottom)
    {
        PowerStripHolderBottom(baseWidth,baseHeight,basePlugDepth,WallThickness, Width,Length,0);
        
        //Bottom Bracket
        if(includeBottomBracket)
        {
            difference()
            {
                translate([0,Middle(baseTopDepth)/2,0])
                rotate([0,90,0])
                squareTube(Width,Width,baseWidth,WallThickness); 
                translate([0,Middle(baseTopDepth)/2,-AddExtra(Width,4)])
                rotate([0,90,0])
                Groove(AddExtra(baseWidth,2), SpacerWidth, WallThickness, Width);
            }
        }
    }
    else
        PowerStripHolderTop(baseWidth,baseHeight,baseTopDepth,WallThickness, Width,Length,powerCordDiameter);
}
module PowerStripHolderBottom(width, height, depth, wallThickness, widthBracket, depthBracket, withGrooves)
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
            if(withGrooves>0)
            {
                translate([OuterWidth(width)+OuterWidth(widthBracket),Middle(depth)/2,1])
                Groove(AddExtra(height,2), SpacerWidth, WallThickness, Width);  
            }
        }
        
        difference()
        {
            //Left Bracket
            translate([-OuterWidth(widthBracket),Middle(depth)/2,0])
            squareTube(widthBracket,depthBracket,height,wallThickness);    
            
            //Groove for Left Bracket
            if(withGrooves>0)
            {
                translate([-OuterWidth(widthBracket)+2,Middle(depth)/2,1])
                Groove(AddExtra(height,2), SpacerWidth, WallThickness, Width); 
            }
        }    
        

    }
}
module PowerStripHolderTop(width, height, depth, wallThickness, widthBracket, depthBracket, powerCordDiameter)
{
    triangle_points =[[0,0],[23,0],[0,8]];
    triangle_paths =[[0,1,2]];

    difference()
    {
        union()
        {
            PowerStripHolderBottom(width, height, depth, wallThickness, widthBracket, depthBracket,0);
 
            translate([39,43,2])
            rotate([180,-90,0])
            linear_extrude(height = width, center = true, convexity = 10, scale=[1,1], $fn=100)
            polygon(triangle_points,triangle_paths,10);
        }
        
        translate([Middle(width), Middle(depth),0])
        linear_extrude(height=20, center=true, convexity=10, scale=[1,1], $fn=100)
        circle(d=powerCordDiameter,center=true);
        
        translate([Middle(width), depth-7,Middle(depth)])
        rotate([0,0,90])
        cube([Middle(depth)+7,powerCordDiameter,100], center=true);
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
            PowerStripHolder(SubBuild);
        }
    }
}


main();