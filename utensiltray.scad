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

module drawTray()
{

Box(630,120,1,50);
}

drawTray();