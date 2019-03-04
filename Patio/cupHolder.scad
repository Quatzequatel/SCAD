

/*
Cup holder Diameter = 109mm, Height = 77 mm
Best values for Cup holder are; Diameter = 103mm, Height = 67 mm
Two of the Stands are tight with these values
The other Stand is slightly larger and these values are snug.
Diameter = 105mm, Height = 67 mm
*/
$fn = 100;
height = 67;
diameter = 105;
radius = diameter/2;

//width = height*2;;
wall = 2;
//height2 = height - 2;

difference()
{
    cupHolder(diameter, height, wall);
    drainHole(3*wall,wall);
}

module cupHolder(diameter, height, wall)
{
    linear_extrude(height,true)
    difference()
    {
        circle(d=diameter);
        circle(d=diameter-wall);
    }
    linear_extrude(wall,true)
    circle(d=diameter-wall);
}

module drainHole(diameter,height)
{
    linear_extrude(height,true)
    circle(d=diameter);
}