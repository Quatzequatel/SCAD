BoxTopLength=197;
BoxTopWidth=197;
BoxHeight=190;
LipHeight=4;
LipThickness=2;
LipOverHangWidth=25;
BoxTopThickness=2;
BoxThickness=2;
IsOpenTop=true;

/*
    NOTE: Med drawer is 404 mm wide.
*/
DrawerWidth = 403;
/*
Project Box
These are sold at Costco.
*/
ProjectBoxWidth=315;
ProjectBoxHeight = 55;

/*
Project Types
*/

TreadSpoilDia = 19.2;
TreadSpoilHeight = 58;

ShortTreadSpoilDia = 35;
ShortTreadShoilHeight = 46; 

LgMedTray = false;
Md1MedTray = false;
Md2MedTray = false;
SmMedTray = false;
//PB = ProjectBox;
PB_SpoilHorizontalShallow = false;
PB_ShortSpoilHorizontalShallow = true;

//When true completes for the width of the drawer.
Complement = true;
Shell = true;

/*
Using just the cube to draw a box allows control of the
top and wall thickness to be defined in the slicer.
using 0% infill, # of walls and # of top layers will make it an tray.
*/
module Box(x,y,wall, height)
{
    b_floor = wall;
    //resize([0,0,0]) 
    //translate([x/2,y/2,0]) 
    union()
    {
        cube([x,y,b_floor],true); //box floor
        BoxWalls(x,y,wall,height);
    }

}

module ShellBox(width,depth,height)
{
    translate([width/2,depth/2,height/2])
    cube([width,depth,height],true);
}

module BoxWalls(x,y,wall, height)
{
     translate([x/2,y/2,height/2]) difference()
    {
    cube([x,y,height],true);
    cube([x-wall,y-wall,height+1], true);
    }
}

module drawTray(trayType)
{
    if(trayType=="LgMedTray"){if (!Complement) Box(76,225,2,35); else Box(76,DrawerWidth-225,2,35);}
    if(trayType=="Md1MedTray"){if (!Complement) Box(65,200,2,35); else Box(65,DrawerWidth-200,2,35);}
    if(trayType=="Md2MedTray"){if (!Complement) Box(47,196,2,35); else Box(47,DrawerWidth-196,2,35);}
    if(trayType=="SmMedTray"){if (!Complement) Box(35,225,2,35); else Box(35,DrawerWidth-225,2,35);}
    if(trayType=="PB_SpoilHorizontalShallow")
        if (Shell)
            ShellBox(ProjectBoxWidth/3,(TreadSpoilHeight+(TreadSpoilDia/6)),(TreadSpoilDia*.8));
            else
            Box(ProjectBoxWidth/3,(TreadSpoilHeight+(TreadSpoilDia/6)),1.2,(TreadSpoilDia*.8));
            
    if(trayType=="PB_ShortSpoilHorizontalShallow")
        if (Shell)
            ShellBox(ProjectBoxWidth/3,(ShortTreadShoilHeight+(ShortTreadSpoilDia/6)),(ShortTreadSpoilDia*.8));
            else
            Box(ProjectBoxWidth/3,(ShortTreadShoilHeight+(ShortTreadSpoilDia/6)),1.2,(ShortTreadSpoilDia*.8));
        
}

drawTray();

//translate([0,(TreadShoilHeight+(TreadSpoilDia/6))+4,0]) drawTray();
