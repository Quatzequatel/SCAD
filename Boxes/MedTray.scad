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

LgMedTray = false;
Md1MedTray = false;
Md2MedTray = false;
SmMedTray = true;

//When true completes for the width of the drawer.
Complement = true;

/*
Using just the cube to draw a box allows control of the
top and wall thickness to be defined in the slicer.
using 0% infill, # of walls and # of top layers will make it an tray.
*/
module Box(x,y,wall, height)
{
    b_floor = wall;
    //resize([0,0,0]) 
    translate([x/2,y/2,0]) 
    cube([x,y,height],true); //box floor
//    difference()
//    {
//    BoxWalls(x,y,wall,height);
////    color("blue") translate([-5,y/2,height-(meshZ/2)])
////    rotate(a=180, v=[1,0,1]) cylinder(20,5,5, false);
//    }
    
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
    if(LgMedTray){if (!Complement) Box(76,225,2,35); else Box(76,DrawerWidth-225,2,35);}
    if(Md1MedTray){if (!Complement) Box(65,200,2,35); else Box(65,DrawerWidth-200,2,35);}
    if(Md2MedTray){if (!Complement) Box(47,196,2,35); else Box(47,DrawerWidth-196,2,35);}
    if(SmMedTray){if (!Complement) Box(35,225,2,35); else Box(35,DrawerWidth-225,2,35);}
}

drawTray();
