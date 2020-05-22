$fn=180;

build();
module build(args) 
{
    ImportFile();
}

module ImportFile() 
{
        translate([-5.5,2.25,-7])
        {
            import("./flower_pot.stl");
        }
        Base();
}

module Base(args) 
{
    difference()
    {
    linear_extrude(4)
    circle(r=39);
    translate([0,0,3])
    cylinder(r1=4, r2=38, h=3, center=true);
    }

}