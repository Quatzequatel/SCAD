/*
Description : makes shop Vac attachment for Dewalt Table saw
Notes       : While the current settings do work as for the Haitachi saw, 
              they are not the best fit.  The adapter is too long and the 
              connection is not as stable as it could be.
              This is a work in progress.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
fn=100;
PI = 4 * atan2(1,1);
HATACHI_OUTER_DIAMETER_1 = 60;
HATACHI_OUTER_DIAMETER_2 = 47;
HATACHI_INNER_DIAMETER_1 = 57;
HATACHI_INNER_DIAMETER_2 = 31;
HATACHI_ADAPTER_LENGTH = 70;

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
BUILD_BUILT_IN_VAC_ATTACHMENT = 0; //THIS IS FOR USE WITH ROUTER VACCUM ATTACHMENT.
BUILD_BUILT_IN_VAC_ADDITIONAL_ATTACHMENT=0; //The above attachment is too short.
BUILD_HATACHI_VAC_ADAPTER = 0;
BUILD_HATACHI_VAC_CONNECTOR = 1; //this is for the built in shop vac attachment.
//this lengthens the attachment; hopefully to give a more stable hold.

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();
// hatachi_Vac_Adapter2();

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
    if(BUILD_HATACHI_VAC_ADAPTER)
    {
        hatachi_Vac_Adapter();        
    }
    if(BUILD_HATACHI_VAC_CONNECTOR)
    {
        rotate([0, 180, 0])
        hatachi_Vac_Adapter2();
    }
}
/*
Version=3.0
*/

module Vaccum_Connector()
{
    tube(80, 63, 63, 57, 57);
}

module hatachi_Vac_Adapter2()
{
    // translate([0, 0,  -HATACHI_ADAPTER_LENGTH/2])
    tube(40, od1 = 64, od2=64, id1 = 60, id2 = 57);
    translate([0, 0, HATACHI_ADAPTER_LENGTH + 5])
    hatachi_Vac_Adapter(); 

}

module hatachi_Vac_Adapter() {
    //this is for connecting the builtin shop vaccum 
    //to the hatachi chop saw.
    
    // tube(ADAPTER_HEIGHT, OUTER_DIAMETER2, OUTER_DIAMETER1, INNER_DIAMETER1);
    echo();
    echo( FileName = "Hatachi_ShopVac_Connector.stl");
    echo();
    difference()
    {
        tube(HATACHI_ADAPTER_LENGTH, HATACHI_OUTER_DIAMETER_1, HATACHI_OUTER_DIAMETER_2, HATACHI_INNER_DIAMETER_1, HATACHI_INNER_DIAMETER_2, true);
        cylinder(h=HATACHI_ADAPTER_LENGTH, d1=35, d2=HATACHI_OUTER_DIAMETER_2-1, center=true, $fn=100);
    }

}

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
    attachmentHeight = 42;
    receptorDiameter = 35;
    vacuumHoseStartDia = 32;
    vacuumHoseEndDia = 33;

    tube(attachmentHeight, receptorDiameter, receptorDiameter, vacuumHoseStartDia,vacuumHoseEndDia);
}

module tube(h, od1, od2, id1, id2, center=false)
{
    difference()
    {
        cylinder(h=h, d1=od1, d2=od2, center=center, $fn=100);
        cylinder(h=h, d1=id1, d2=id2, center=center, $fn=100);
    }
}

