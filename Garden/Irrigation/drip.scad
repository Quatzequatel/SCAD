/*

*/
NW = 0.4;
LW = 0.6;
LH = 0.24;
$fn=100;

OD_TIP = 4.0;
OD_FLANG = 6.21;
OD_PIPE = 4.61;
ID_PIPE = OD_TIP - (NW *2);
WALL = LW * 4;
BarbLength = 4;

CONNECTORS = 7;
M_ID_PIPE = RadiusFromArea(CircleArea(ID_PIPE) * CONNECTORS);
M_OD_PIPE = M_ID_PIPE + WALL;
M_PIPE_LENGTH = (CONNECTORS+1)*15;

function CircleArea(radius) = 2 * PI * radius * radius;
function RadiusFromArea(area) = sqrt(area/PI);

module Build(args) 
{
    rotate([90,0,0])
    Connector();       
}

Build();

module Connector(args) 
{
    height = 10.3;
    y = OD_FLANG - OD_TIP;
    echo(y=y);
    
    difference()
    {
        union()
        {
            //Barb connector
            for (i=[0:CONNECTORS-1]) 
            {
                translate([i * 15, 0, 0])
                Barb(od = [OD_TIP, OD_FLANG, OD_PIPE], id = ID_PIPE, height = M_OD_PIPE + 4, barbLength =  BarbLength);    
            }
            //Resevior tube
            translate([-15, y, 0])
            rotate([0, 90, 0]) 
            {
                Tube(od = M_OD_PIPE, id = M_ID_PIPE, length = M_PIPE_LENGTH);
            }

            translate([-15,y,0])
            rotate([90,0,-90])
            {
                union()
                {
                    ConeTaperTube(od1=M_OD_PIPE, od2=OD_PIPE, wall=WALL, length=M_OD_PIPE);
                    translate([0, 0, 9])
                    Barb(od = [OD_TIP, OD_FLANG, OD_PIPE], id = ID_PIPE, height = M_OD_PIPE, barbLength = BarbLength); 
                }
            }

            translate([M_PIPE_LENGTH-15,y,0])
            rotate([90,0,90])
            {
                union()
                {
                    ConeTaperTube(od1=M_OD_PIPE, od2=OD_PIPE, wall=WALL, length=M_OD_PIPE);
                    translate([0, 0, 9])
                    Barb(od = [OD_TIP, OD_FLANG, OD_PIPE], id = ID_PIPE, height = M_OD_PIPE, barbLength = BarbLength); 
                }
            }
        }

        translate([-15, y, 0])
        {
            rotate([0, 90, 0]) 
            {
                cylinder(d=M_ID_PIPE, h = M_PIPE_LENGTH);
            }
        }

        translate([-15, -7, -5])
        cube(size=[M_PIPE_LENGTH, 5, M_OD_PIPE+10]);

        for (i=[0:CONNECTORS-1]) 
        {
            translate([i * 15, 0, 0])
            cylinder(d=ID_PIPE, h=M_OD_PIPE + 4);
            // Barb([OD_TIP, OD_FLANG, OD_PIPE], ID_PIPE, M_OD_PIPE + 4, 4);    
        }
    }    
}

module Barb(od, id, height, barbLength) 
{
    //tip
    union()
    {
        Tube(od[0], id, height);
        translate([0, 0, height-6])
        ConeWithTube(od1=od[1], od2=od[2], id=id, length=barbLength);
    }

}

module Tube(od, id, length)
{
    linear_extrude(height=length)
    {
        difference()
        {
            circle(r=od/2);
            circle(r=id/2);
        }
    }
}

module ConeWithTube(od1, od2, id, length)
{
    // linear_extrude(height=length)
    {
        difference()
        {
            cylinder(d1=od1, d2=od2, h=length);
            cylinder(d=id, h=length);
        }
    }
}

module ConeTaperTube(od1, od2, wall, length)
{
    // linear_extrude(height=length)
    {
        difference()
        {
            cylinder(d1=od1, d2=od2, h=length);
            cylinder(d1=od1-wall, d2=od2-wall, h=length);
        }
    }
}