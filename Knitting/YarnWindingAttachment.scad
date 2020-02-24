/*
YarnWindingAttachment
Tab
    width=10
    depth=2.25
    height1=2.5
    height2=3.0
 Cylindar
    OD=40.0
    wall=1.75
    ID=36.5
*/

YarnWindingAttachment = 1;
YarnWindingAttachmentSpindle = 2;
AttachmentANDSpindle = YarnWindingAttachment + YarnWindingAttachmentSpindle;
Designing = 0;

$fn=180;
Tab_Width=10;
Tab_Depth=3.25;
Tab_Height1=3.2;
Tab_Height2=1.6;
Tab_Adjustment_Y = 1.6;

Attachment_OD= 40.0;
Attachment_Wall=10.0;
Attachment_Height=60;
Attachment_Inside_Cone_Height = 14.8;
Attachment_Tolerance = 2;
YarnConnector_SlitWidth = 3;
YarnConnector_SlitHeightWidthRatio = 5;
YarnConnector_Height = Attachment_OD/2;
YarnConnector_Diameter = Attachment_OD;
YarnConnector_SphereDia = YarnConnector_Diameter - Attachment_Tolerance;

Spindle_OD = Attachment_OD - Attachment_Wall - Attachment_Tolerance ;
//Spindle_Wall=2.0;
Spindle_Base_OD= 2 * Attachment_OD;
Spindle_Base_Height=10;
Spindle_GapHeight = 10 * Attachment_Tolerance;
Spindle_Height=Attachment_Height +Spindle_Base_Height + Spindle_GapHeight;

Build(YarnWindingAttachment);

module Build(item)
{
    if(item == YarnWindingAttachment) 
        Attachment();
    else if(item == YarnWindingAttachmentSpindle)
        Spindle(Spindle_Height, Spindle_OD, Spindle_Base_Height, Spindle_Base_OD);
    else if(item == AttachmentANDSpindle)
    {
        Attachment();
        translate([0,0,-(Spindle_Base_Height+Spindle_GapHeight)])
        #Spindle(Spindle_Height, Spindle_OD, Spindle_Base_Height, Spindle_Base_OD);
    }
    else 
    {
        YarnConnector(YarnConnector_Height,YarnConnector_Diameter, YarnConnector_SphereDia, YarnConnector_SlitWidth, YarnConnector_SlitHeightWidthRatio);
    }

}

module Attachment()
{
    difference()
    {
        union()
        {
            //Tab 1
            translate([0,(Attachment_OD+Tab_Depth-Tab_Adjustment_Y)/2,0])
            LockingTab(Tab_Width,Tab_Depth,Tab_Height1,Tab_Height2);

            //Primary Attachment
            Tube(Attachment_Height, Attachment_OD,Attachment_Wall);

            //Tab 2
            translate([0,-(Attachment_OD+Tab_Depth-Tab_Adjustment_Y)/2, 0])
            rotate([180,180,0])
            LockingTab(Tab_Width,Tab_Depth,Tab_Height1,Tab_Height2);
            AttachmentTop(Attachment_Inside_Cone_Height, Attachment_OD, Attachment_OD - Attachment_Wall );
            
            translate([0,0,Attachment_Height + Attachment_Inside_Cone_Height])
            YarnConnector(YarnConnector_Height,
                YarnConnector_Diameter, 
                YarnConnector_SphereDia, 
                YarnConnector_SlitWidth, 
                YarnConnector_SlitHeightWidthRatio);
        }
        translate([0,0, -1])
        #cylinder(h = 100, r=1);
        
    }
}

module AttachmentTop(height, diameter, sphereDiameter)
{
    echo("AttachmentTop ",height=height, diameter=diameter, sphereDiameter=sphereDiameter);
    translate([0, 0, Attachment_Height])
    difference()
    {
        cylinder(h=height, d1=diameter, d2=diameter);
        sphere(d=sphereDiameter);
    }    
}

module YarnConnector(height, diameter, sphereDiameter, slitsize, ratio)
{
    echo("YarnConnector ",height=height, diameter=diameter, sphereDiameter=sphereDiameter);
    difference()
    {
        cylinder(h=height, d1=diameter, d2=diameter);
        translate([0, 0, height])
        sphere(d=sphereDiameter);
        YarnSlit(height, diameter, slitsize, ratio);
    }
}

module YarnSlit(height, diameter, slitsize, ratio)
{
    slitCenter = slitsize/2;
    slitHeight = ratio * slitsize;
    poly = [[0,0],[0, slitsize], [slitHeight, slitCenter]];
    echo(poly=poly, slitCenter=slitCenter, slitHeight=slitHeight);
    
    translate([- slitCenter, diameter/2 , height])
    rotate([90,90,0])
    linear_extrude(height = diameter)
    polygon(poly);
}

module Spindle(height, od, baseheight, base_od)
{
    echo("Spindle ",height=height, od=od, baseheight=baseheight, base_od=base_od);
    //base
    cylinder(h=baseheight, d1=base_od, d2 = base_od);
    //spindle
    cylinder(h=height, d1= od, d2 = od);
    
    //spindle top
    translate([0,0,height ])
    sphere(d=od);
}
 
module LockingTab(width, depth, h1, h2)
{
    echo("LockingTab ",width=width, depth=depth, h1=h1, h2=h2);
    points=[[0,0],[width,0],[width,h1],[0,h2]];
    rotate([90,0,0])
    linear_extrude(height=depth, center = true)
    translate([-width/2,0,0])
    polygon(points);
}

module Tube(height, diameter, wall)
{
    
    difference()
    {
        cylinder(h=height, d1=diameter, d2=diameter);
        cylinder(h=height, d1=diameter-wall, d2=diameter-wall);
    }
}
