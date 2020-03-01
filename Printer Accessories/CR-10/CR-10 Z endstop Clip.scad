/*
i seem to be having problems with leveling the CR-10.
In looking or a simple way to reduce the z-stop by a few mm.
i decided to make a clip to fit over the aluminum brace; just
to triggeer the sensor a little sooner.

3/1/2020
This seems to work well.
printed with layer height of 0.2
*/


al_Thickness = 3;
clipWidth = 18;
clipOffest = 1.2;

clipX = clipWidth;
clipY = al_Thickness * 3;
clipZ = al_Thickness * 2;

dx = clipX; dy = al_Thickness; dz = clipOffest;
$fn=180;
Build();

module Build()
{
    union()
    {
        difference()
        {
    
            Block(clipX, clipY, clipZ);
            //remove
            tx = 0; 
            ty = (clipY-dy) / 2; 
            tz = dz + al_Thickness / 2;

            Block(dx, dy, (2 * clipZ), tx, ty, tz);

            translate([tx, (clipY) / 2, tz ])
            {
                chamfer(clipX, al_Thickness);          
            }
        }
        //round wall tops
        translate([0, al_Thickness/2, clipZ])
        chamfer(clipX, al_Thickness);  

        translate([0, clipY - al_Thickness/2, clipZ])
        chamfer(clipX, al_Thickness);
    }
}

module Block(xSide, ySide, zSide, xloc=0, yloc=0, zloc=0)
{
    translate([xloc, yloc, zloc])
    {    
        cube(size=[xSide, ySide, zSide]);    
    }
}

module chamfer(height, diameter)
{
    rotate([0, 90, 0]) 
    {
        cylinder(h = height, d1 = diameter, d2 = diameter);              
    }
}