/*
Description : makes shop Vac attachment for Dewalt Table saw
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
fn=100;
PI = 4 * atan2(1,1);
OUTER_DIAMETER1 = 57.5;
OUTER_DIAMETER2 = 58.0;

INNER_DIAMETER1 = 31.0;
INNER_DIAMETER2 = 32.0;

OUTER_DIAMETER3 = OUTER_DIAMETER1;
OUTER_DIAMETER4 = 56.0;

INNER_DIAMETER3 = 31.0;
INNER_DIAMETER4 = OUTER_DIAMETER4;
ADAPTER_HEIGHT = 30;

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_SHOP_VAC_ATTACHMENT = 0;
BUILD_BUILT_IN_VAC_ATTACHMENT = 1; //THIS IS FOR USE WITH ROUTER VACCUM ATTACHMENT.
BUILD_BUILT_IN_VAC_ADDITIONAL_ATTACHMENT=1; //The above attachment is too short.
//this lengthens the attachment; hopefully to give a more stable hold.

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if (BUILD_SHOP_VAC_ATTACHMENT) 
    {
        shopVacAttachment();
    }
        if (BUILD_BUILT_IN_VAC_ATTACHMENT) 
    {
        builtInVaccumAdapter();
    }
    if(BUILD_BUILT_IN_VAC_ADDITIONAL_ATTACHMENT)
    {
        additionalTubeForBuiltInAdapter();
    }
}
/*
Version=3.0
*/

module shopVacAttachment() 
{
    union()
    {
        tube(ADAPTER_HEIGHT, OUTER_DIAMETER2, OUTER_DIAMETER1, INNER_DIAMETER1);
        translate([0,0,ADAPTER_HEIGHT])
        tube(ADAPTER_HEIGHT, OUTER_DIAMETER3, OUTER_DIAMETER4, INNER_DIAMETER3,INNER_DIAMETER4);
    }    
}

module builtInVaccumAdapter() 
{
    //35 mm diameter of attachment
    //30 mm initial dia of vacuum hose
    //31.5 mm final dia of vacuum hose
    //30 mm lenght of attachment

    attachmentHeight = 30;
    receptorDiameter = 35;
    vacuumHoseStartDia = 30;
    vacuumHoseEndDia = 31.5;

    tube(attachmentHeight, receptorDiameter-1, receptorDiameter, vacuumHoseStartDia,vacuumHoseEndDia);
}

module additionalTubeForBuiltInAdapter() 
{
    attachmentHeight = 40;
    receptorDiameter = 35;
    vacuumHoseStartDia = 31;
    vacuumHoseEndDia = 32;

    tube(attachmentHeight, receptorDiameter, receptorDiameter, vacuumHoseStartDia,vacuumHoseEndDia);
}

module tube(h, od1, od2, id1, id2)
{
    difference()
    {
        cylinder(h=h, d1=od1, d2=od2, center=false, $fn=100);
        cylinder(h=h, d1=id1, d2=id2, center=false, $fn=100);
    }
}

