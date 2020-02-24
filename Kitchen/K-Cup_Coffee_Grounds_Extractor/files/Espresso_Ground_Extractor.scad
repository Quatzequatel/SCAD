

Height = 45;
TopDia = 31;
BottomDia = TopDia + 15;
Zlift = Height/2 +5;

$fn=90;

union()
{
//    translate([0,0,Zlift])
    cylinder(h = Height , d1 = BottomDia +1, d2 = 0.4, center= false);
    
    difference()
    {
        translate([0,0,5])
        import("/Kitchen/K-Cup_Coffee_Grounds_Extractor/files/k_cup_screw_standalone.stl");
        
        translate([0,0,Zlift])
        cylinder(h = Height , d1 = BottomDia, d2 = TopDia, center= true);
        
        cylinder(h = Height , d1 = BottomDia-8, d2 = TopDia, center= false);
        
    }
}