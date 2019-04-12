
//box(10,20,15,2);
getPoly(10,20,15,2);

module box(width, length, height, thickness)
{
    difference()
    {
    cube([width, length, height]);
    translate([thickness/2,thickness/2,thickness])
    cube([width-thickness, length-thickness, height]);
    }
    
    #translate([0,0,height-thickness/2-0.3])
    rotate([0,-30,0])
    cube([thickness/2,length,thickness *2]);
    
    #translate([0,thickness/2,height-thickness/2])
    rotate([0,30,-90])
    cube([thickness/2,width,thickness *2]);
    
    #translate([0,thickness/2,height-thickness/2])
    rotate([0,30,-90])
    cube([thickness/2,width,thickness *2]);
}

module getPoly(width, length, height, thickness)
{
    pa = [[0,0],[width,0],[length,sqrt(width)]];
}