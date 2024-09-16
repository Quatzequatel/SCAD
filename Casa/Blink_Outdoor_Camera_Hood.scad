$fn=200;
// import("C://Users//quatz//Downloads//Blink_Outdoor_Camera_Hood.stl");

difference()
{
    //main
    minkowski()
    {
        cube([47,47,0.1], true);
        cylinder(r=14.5,h=23.5);
    };

    //cut
    minkowski()
    {
        cube([42.7,42.7,0.2], true);
        cylinder(r=13.5,h=23.5);
    }
}