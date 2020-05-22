spindle_od = 19.35;
torch_od = 16;
spacing = 55;
wall = 5;
height = 40;


max_width = max(spindle_od,torch_od);

tikiMT(0);
translate([0,max_width+wall*2+2,0])  {
    tikiMT(10);
}
module tikiMT(offset)  {

    difference()  {
        union()  {
            cylinder(h = height,d = max_width+wall+wall, $fn=100);
            translate([0,(max_width+wall+wall)*-0.5,0])  {
                cube([spacing,max_width+wall+wall,height]);
            }
            translate([spacing,0,0])  {
                cylinder(h = height,d = max_width+wall+wall, $fn=100);
            }
        }
        
        //Spindle
        cylinder(h = height,d = spindle_od, $fn=100);
        translate([spacing,0,offset])  {
            cylinder(h = height,d = torch_od, $fn=100);
        }
        //splice
        translate([-max_width-wall,-0.5,0])  {
            cube([spacing*3,1,height]);
        }
        //through hole
        rotate([90,0,0])  {
            translate([spacing/2,height/2,-50])  {
                cylinder(h = 100,d = 5, $fn=100);
            }
        }
        //nut
        rotate([90,0,0])  {
            translate([spacing/2,height/2,7])  {
                cylinder(h = 100,d = 10, $fn=6);
            }
        }
        //head
        rotate([90,0,0])  {
            translate([spacing/2,height/2,-27])  {
                cylinder(h = 20,d = 10, $fn=100);
            }
        }
         
    }   
}
