BoxTopLength=197;
BoxTopWidth=197;
BoxHeight=190;
LipHeight=4;
LipThickness=2;
LipOverHangWidth=25;
BoxTopThickness=2;
BoxThickness=2;
IsOpenTop=true;



//meshX=26;
meshY=18;
meshZ=40;
Seedrows=4;
Seedcolumns=4;

spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;


module Box(x,y,wall, height)
{
    //resize([0,0,0]) 
    translate([x/2,y/2,0]) 
    cube([x,y,wall],true);
    difference()
    {
    BoxWalls(x,y,wall,height);
    color("blue") translate([-5,y/2,height-(meshZ/2)])
    rotate(a=180, v=[1,0,1]) cylinder(20,5,5, false);
    }
    
}

module BoxWalls(x,y,wall, height)
{
     translate([x/2,y/2,height/2]) difference()
    {
    cube([x,y,height],true);
    cube([x-wall,y-wall,height+1], true);
    }
}

module tube(length, r, r2, wall, center)
{
    difference()
    {
        color("blue") cylinder(h=length, r=r, r2=r2, center=center,$fn=100);
        //cylinder(h=length+2, r=(r-wall), r2=(r2-wall), center=center, $fn=100);
    }
}

module tubethroughwall(length, r, r2, wall, center)
{
    color("red") cylinder(h=length+2, r=(r-wall), r2=(r2-wall), center=center, $fn=100);
}

//tubes are used to display water level.

//    difference()
//    {
//        union()
//        {
//            //box
//            Box(BoxTopLength,BoxTopWidth,BoxThickness,BoxHeight);
//            //bottom tube
//            translate([-5,BoxTopWidth/2,7])rotate(a=180, v=[1,0,1]) tube(11,4.62,5.22,1,true);
//            //Top tube
//            translate([-5,BoxTopWidth/2,BoxHeight-35]) rotate(a=180, v=[1,0,1]) tube(11,4.62,5.22,1,true);
//        }
//        //tube through wall
//        //bottome tube
//        translate([-5,BoxTopWidth/2,7])rotate(a=180, v=[1,0,1]) tubethroughwall(11,4.62,5.22,1,true);
//        //top tube
//        translate([-5,BoxTopWidth/2,BoxHeight-35])rotate(a=180, v=[1,0,1])
//        tubethroughwall(11,4.62,5.22,1,true);
//    }

//union(){
//    difference(){
//        tube(11,4.62,5.22,1,true);
//        tubethroughwall(11,3.62,4.22,1,true);
//    }
    //translate ([20,0,5])

//plug
//    difference()
//    {
//        tube(11,1.62,2.22,1,true);
//        tubethroughwall(11,1.62,2.22,1,true);
//    }
    
    difference()
    {
    union()
    {
        cylinder(h=1, r=10,center=true);
        translate([0,0,-11/2]) tube(11,4.62,5.22,1,true);
        }
//plug
    difference()
    {
        tube(15,1.62,2.22,1,true);
        tubethroughwall(15,1.62,2.22,1,true);
    }
}