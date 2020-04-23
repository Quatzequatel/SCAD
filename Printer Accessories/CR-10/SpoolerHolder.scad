/*
    this is a bottom that connects (anchors) the
    spooler holder to the Control Box. this connector
    hooks around the control box so it is not dislodge
    easily from the Control Box.
*/

Thickness = 5.0;
Width = 150.0;
ControlBoxWidth = 125.25;
ControlBoxHeight = 119; //118.5 is actual.
SpoolWidth = 70.0; //66.5 is actual.
// Height = 

Build();

module Build(args) 
{
    Base();
}

function TranslateBoxWidth(args = 0) = ControlBoxWidth/2 - (args == 1 ? Thickness/2 : 0);
function TranslateBoxHeight(args = 0) = args != 2 ? (ControlBoxHeight/2 + (args == 1 ? Thickness/2 : 0)) : ControlBoxHeight;

module Base()
{
    translate([0, Thickness/2, 0]) 
    rotate([90 , 0, 0]) 
    color("Yellow") linear_extrude(height=Thickness, center=true, convexity=10, twist=0) 
    square(size=[ControlBoxWidth, SpoolWidth], center=true);

    color("Aqua") translate([TranslateBoxWidth(false), TranslateBoxHeight(false), 0]) 
    rotate([90 , 0, 90]) 
    linear_extrude(height=Thickness, center=true, convexity=10, twist=0) 
    square(size=[ControlBoxHeight, SpoolWidth], center=true);

    color("Blue") translate([-TranslateBoxWidth(false), TranslateBoxHeight(false), 0]) 
    rotate([90 , 0, 90]) 
    linear_extrude(height=Thickness, center=true, convexity=10, twist=0) 
    square(size=[ControlBoxHeight, SpoolWidth], center=true);

    color("Gold") translate([-TranslateBoxWidth(1), TranslateBoxHeight(2), 0]) 
    rotate([90 , 0, 0]) 
    linear_extrude(height=Thickness, center=true, convexity=10, twist=0) 
    square(size=[10, SpoolWidth], center=true);

    color("Gold") translate([TranslateBoxWidth(1), TranslateBoxHeight(2), 0]) 
    rotate([90 , 0, 0]) 
    linear_extrude(height=Thickness, center=true, convexity=10, twist=0) 
    square(size=[10, SpoolWidth], center=true);

}