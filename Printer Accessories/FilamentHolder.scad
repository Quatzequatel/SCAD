padWidth=13;
padLength=26;
padThickness=3;

function radius(x=screwDiameter)=x/2;
function screwLength(x=padThickness)=x+2;
function center(x=padWidth)=x/2;
function rightEdge()=padLength-(4+1.96) ;

module pad()
{
    
    difference()
    {
    cube([padWidth,padLength,padThickness],false);
    screwHole1();
    fastenerSquare();
    }

}

screwDiameter=2.91;
headDiameter=5.3;
filamentTubeDiameter = 6.1;
filamentDiameter = 2.5;

module tube(diameter, length, transparam, rotateparam)
{
    translate(transparam)
    rotate(a=rotateparam)
        cylinder($fn=100, 
            h=length,
            d1=diameter, 
            d2=diameter, 
            center=false);    
}

module screwHole1()
{
        union()
    {
        tube(screwDiameter,screwLength(),[center(),1.96,-1],noChange());
        tube(headDiameter,center(padThickness)+2,[center(),1.96,center(padThickness)],noChange());
    }
}

module fastenerSquare()
{
    //1.96, 4.0;
    translate([center()-2,rightEdge(),-1])
    cube([4,4,6], false);
}

function transFilamentHolderShell()=[center(padWidth),headDiameter+filamentTubeDiameter,center(cleanerDiameter)+padThickness];
function transFilamentHolderVoid()= [center(padWidth)-3,headDiameter+filamentTubeDiameter,center(cleanerDiameter)+padThickness];
function transFilamentVoid()= [center(padWidth)-3,headDiameter+filamentTubeDiameter,center(cleanerDiameter)+padThickness];

function onSide()=[0,90,0];
function noChange()=[0,0,0];

module filamentHolder()
{
    difference()
    {
        tube(filamentTubeDiameter+2,center(),transFilamentHolderShell(),onSide());
        tube(filamentTubeDiameter,center(),transFilamentHolderVoid(),onSide());
        tube(filamentDiameter,10,transFilamentVoid(),onSide());
    }
}

cleanerHeight = 21;
cleanerDiameter = 15.5;

function transCleanerShell()=[padWidth,headDiameter+filamentTubeDiameter,radius(cleanerDiameter)+padThickness];
function transCleanerVoid()=[padWidth-1,headDiameter+filamentTubeDiameter,radius(cleanerDiameter)+padThickness];
function transFilamentVoid2()= [center(padWidth)-3,headDiameter+filamentTubeDiameter,center(cleanerDiameter)+padThickness];
module cleanerHolder()
{
    difference()
    {
    tube(cleanerDiameter+2,cleanerHeight,transCleanerShell(),onSide());
    tube(cleanerDiameter,cleanerHeight-2,transCleanerVoid(),onSide());
    #tube(filamentDiameter,40,transFilamentVoid2(),onSide());
    }
}

module cleanerHolderPad()
{
    translate(
        [padWidth,
        headDiameter+filamentTubeDiameter-center(5),
        0])
    cube([cleanerHeight,5,padThickness], false);
}

module filamentBlock()
{
    translate([padWidth/2,headDiameter+filamentTubeDiameter-center(5),padThickness])
    cube([padWidth/2,5,4.5]);
}

module unit()
{
    union()
    {
        pad();
        filamentHolder();
        cleanerHolder();
        cleanerHolderPad();
        filamentBlock();
    }
}

unit();