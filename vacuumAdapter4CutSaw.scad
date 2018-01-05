/*
Version=3.0
*/
outerDiameter1 = 45;
outerDiameter2 = 50.0;

innerDiameter1 = 31.0;
innerDiameter2 = 32.0;

outerDiameter3 = outerDiameter1;
outerDiameter4 = 40;

innerDiameter3 = 31.0;
innerDiameter4 = outerDiameter4;

height = 30;

module tube(h, od1, od2, id1, id2)
{
    difference()
    {
        cylinder(h=h, d1=od1, d2=od2, center=false, $fn=100);
        cylinder(h=h, d1=id1, d2=id2, center=false, $fn=100);
    }
}

union()
{
    tube(height, outerDiameter2, outerDiameter1, innerDiameter2,innerDiameter1);
    translate([0,0,height])tube(height, outerDiameter3, outerDiameter4, innerDiameter3,innerDiameter4);
}