

outerDiameter1 = 57.5;
outerDiameter2 = 58.04;

innerDiameter1 = 31.0;
innerDiameter2 = 32.0;

height = 30;

module tube(h, od1, od2, id1, id2)
{
    difference()
    {
        cylinder(h=h, d1=od1, d2=od2, center=false, $fn=100);
        cylinder(h=h, d1=id1, d2=id2, center=false, $fn=100);
    }
}

tube(height, outerDiameter1, outerDiameter2, innerDiameter1,innerDiameter2);