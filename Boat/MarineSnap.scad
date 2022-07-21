/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

Size = 20;
ImageFloor = 5.468/2;
SocketXoffset = 4.4455;
SocketHeight = 5;
SocketDiameter = 2 * (10 - SocketXoffset);


ButtonXoffset = -3.43775;
ButtonDiameter = 2 * (10 - abs(ButtonXoffset));
ButtonHeight = SocketHeight;

// CenterSocket();
CenterButton();

module CenterButton()
{
    translate([ButtonDiameter/2 + abs(ButtonXoffset), 0, 0])
    Button();
}

module CenterSocket()
{
    translate([(SocketDiameter/2 + abs(SocketXoffset)) * -1, 0, 0])
    Socket();
}


module Socket()
{
    difference()
    {
        ImportImage();

        translate([(ButtonDiameter/2 + abs(ButtonXoffset)) * -1 ,0,0])
        cylinder(d=ButtonDiameter + 1, h=ButtonHeight + 1, center=false);        
    }    
}

module Button()
{
    difference()
    {
        ImportImage();
        
        translate([ SocketDiameter/2 + SocketXoffset , 0, 0])
            cylinder(d=SocketDiameter + 1, h=SocketHeight + 1, center=false);      
    }    
}



module ImportImage()
{
        translate([0,0,ImageFloor])
        import("marinesnap.stl", convexity=3);
}