sizeXY = 15;
smallOffset = 0.5;
smallXY= sizeXY-smallOffset;
sizeZ = 5;
smallZ = 0.32;
$fn=100;

function largeMoveZ(i) = (i * sizeZ) + (i * smallZ);
function smallMoveZ(i) = sizeZ + (i * sizeZ) + (i * smallZ);

build();
module build()
{
    for (i=[0:5]) 
    {
        difference()
        {
            union()
            {
                translate([0, 0, largeMoveZ(i)]) 
                Cube(sizeXY,sizeXY, sizeZ);
                translate([smallOffset/2,smallOffset/2, smallMoveZ(i)]) 
                Cube(smallXY,smallXY, smallZ);                
            }
            translate([0, 0, largeMoveZ(i)+0.5]) 
            Temp(210 + i * 5);
        }

    }
}

module Cube(x,y,z)
{
    cube(size=[x, y, z]);
}

module Temp(value)
{
    translate([3,0.4,0])
    rotate([90,0,0])
    linear_extrude(0.5)
    offset(r=0.15)
    text(text=str(value), size = 4);
}
