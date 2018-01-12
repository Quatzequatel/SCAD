TopOutDiameter = 34.24;
BottomOutDiameter = 36;

TopInsideDiameter = 29.25;
BottomInsideDiameter = 31.3;

Height = 40;

module PoleAttachment()
{
    translate([BottomOutDiameter/2,BottomOutDiameter/2,0])
    difference()
    {
    cylinder($fn = 360,  Height, BottomOutDiameter/2, TopOutDiameter/2, false);
    translate([0,0,-1])
    cylinder($fn = 360,  Height+2, BottomInsideDiameter/2, TopInsideDiameter/2, false);
    
    }
}

module ShelfAttachment()
{
    cylinder($fn = 360,  Height, BottomInsideDiameter/2, TopInsideDiameter/2, false);
}

module PoleExtension()
{
    union()
    {
        PoleAttachment();
        height = Height;
        inch =25.4;
        
//        translate([BottomOutDiameter+5,BottomOutDiameter+5,height/2])
//        #rotate([0,0,-45])
//        cube([8,33,height],true);
        #translate([TopInsideDiameter,TopInsideDiameter,0])
        rotate([90,0,45])
        linear_extrude(8,10,center=true)
        polygon([[0,0],[(inch+3),0],[0,40]]);              
        
        
        //polygon([0,0],[BottomOutDiameter+25.4+BottomInsideDiameter,0],[0,10],[0,1,2]);
        translate([TopInsideDiameter,TopInsideDiameter,0])
        rotate([270,0,45])
        linear_extrude(8,10,center=true)
        polygon([[0,0],[(BottomOutDiameter+inch),0],[0,20]]);        
        
        translate([BottomOutDiameter+inch,BottomOutDiameter+inch,0])
        ShelfAttachment();
    }
    
}

PoleExtension();
echo(BottomOutDiameter+25.4+BottomInsideDiameter);

