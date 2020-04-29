/*
Tool for getting coffee gounds out of Espresso filter basket.
History:
 2020/02/25 : Created
              Changed EspressoFilterBasket_Depth from 27 to 19
                Idealy the point does not touch the basket bottom,
                but portafilter does hit the outside brim.
 2020/04/29 : adding blug to interior so basket does not fall into the
              jar. Extractor2().
*/
EspressoFilterBasket_Diameter_OD = 63;
EspressoFilterBasket_Diameter_ID = 53;
EspressoFilterBasket_Depth = 18;  //Breville double size
EspressoFilterBasket_LipDepth = 5;


WideMouth_Diameter = 84;
WideMouthLid_ID = 73;
WideMouthThickness = 4;

Wall = WideMouthLid_ID - EspressoFilterBasket_Diameter_OD;
LidOD = WideMouth_Diameter;
LidID = EspressoFilterBasket_Diameter_OD;
Height = 27;
//Total height should add up to 50-51 mm
PointerHeight = Height + EspressoFilterBasket_Depth + Wall/2;
// TopDia = 31;
// BottomDia = TopDia + 0;
// Zlift = Height/2 +5;

$fn=360;

build();
module build(args) 
{
    Extractor2();
}



module Extractor2()
{
    points = [
                [EspressoFilterBasket_Diameter_ID/2, 0], 
                [LidOD/2, 0], 
                [LidOD/2, WideMouthThickness], 
                [(LidID + Wall)/2, WideMouthThickness], 
                [(LidID + Wall)/2, Height],
                [LidID/2, Height],  
                // [LidID, Height - EspressoFilterBasket_LipDepth],
                [EspressoFilterBasket_Diameter_ID/2, Height - (2 * EspressoFilterBasket_LipDepth)],
                [EspressoFilterBasket_Diameter_ID/2, 0]
            ];

        adjustment = 0.5;
        rotate_extrude()
        union()
        {
            polygon(points);        
            translate([LidID/2 + (LidOD/2-LidID/2)/4 - adjustment/4, Height, 0])
            circle(d = (LidOD/2-LidID/2)/2 - adjustment/2);            
        }


}

module Extractor1()
{

    // ImportFile();
    // triangle(Wall / 2, LidID + 1);
    // rotate([0,0,90])
    // triangle(Wall / 2, LidID + 1);
    // rotate([0,0,45])
    // pyramid(LidID/3, PointerHeight);
    
    // rotate([0,0,90])
    // pyramid(LidID/3-2, PointerHeight);

    tube(LidID + Wall, LidID, Height , true);
    tube(LidOD, EspressoFilterBasket_Diameter_ID, 4);
}

// module ImportFile() 
// {
//         #translate([0,0,5])
//         import("C:/Users/quatz/source/repos/Quatzequatel/SCAD2/Kitchen/K-Cup_Coffee_Grounds_Extractor/files/k_cup_screw_standalone.stl");
// }

module triangle(width, length) {
    tripoly = [ [0,0],
                [0, width],
                [width, width/2] 
                ];

    rotate([90, -90, 0]) 
    {
        translate([0,-width/2,-length/2])
        linear_extrude(height = length)
        polygon(points=tripoly);
    }
}

module pyramid(width, height) 
{
    scalefactor = width/3 ;
    translate([0,0,height])
    rotate([180, 0, 0]) 
    {
        linear_extrude(height = height, scale = scalefactor )
        square(size=[3, 3], center=true);
    }   
}

module tube(od, id, length, includeTop=0) {
    odr = od/2;
    idr = id/2;

    echo(od=od, odr=odr, id=id, idr=idr, length=length);
    union()
    {
        linear_extrude(height = length)
        difference()
        {
            circle(r=od/2);
            circle(r=id/2);
        }
        wallr = (odr-idr)/2;
        echo(wallr=wallr);

        if(includeTop != 0)
        {
            translate([0,0,length])
            rotate_extrude()
            translate([idr + wallr,0,0])
            circle(r=wallr);
        }
    }
}