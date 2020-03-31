//$fn=16;

// Bolt Diameter
Bolt_Diameter = 5.00;
Bolt_Length = 50 - 3.0;
Head_Diameter = 8.10;
Head_Thickness = 3.5;

// Nut Diameter
Nut_Thickness = 3.75;

// Vise Base Diameter
Corner_r = 0.5;

Base_Hight = 30;
Base_Width = 35;
Base_Depth = 60;
Base_Radius = 5;

Base_Thickness = 6.5;

//Rail Diameter
Rail_Width = 4.0;
Base_Space = 9.5;
Rail_Margin = 0.3;

//Movement Offset
Move_offset = 0.0;
/* ********* Reassigned ********* */

bd = Bolt_Diameter;
bl = Bolt_Length;
bhd = Head_Diameter;
bht = Head_Thickness;

nt = Nut_Thickness;

mcr = Corner_r;

mbh = Base_Hight - Corner_r;
mbw = Base_Width - Corner_r;
mbd = Base_Depth+Move_offset - Corner_r;
mbr = Base_Radius - Corner_r;

mbt = Base_Thickness - Corner_r*2;

rw = Rail_Width;
rbs = Base_Space;
rm = Rail_Margin;

/* ****************************** */
CenterBolt = true;
Knob = true;
ViseBase= false;
ViseSlider=false;

Build();

module Build(arg)
{
	DisplayDimension();

	if(CenterBolt)
	{
		CenterBolt();
	}
	if(Knob)
	{
		Knob();
	}
	if(ViseBase)
	{
		ViseBase();
	}
	if(ViseSlider)
	{
		ViseSlider();
	}
}

module CenterBolt()
{
	// Center Bolt
	#translate([Bolt_Length/2,0,0])rotate([0,270,0]){
		cylinder(r=Bolt_Diameter/2,h=Bolt_Length,$fn=16);
		translate([0,0,-Head_Thickness])cylinder(r=Head_Diameter/2,h=Head_Thickness,$fn=6);
	}

}

module Knob()
{
	translate([Bolt_Length/2,0,0])
		rotate([0,90,0])import("levelKnobs_m5.stl", convexity = 5);	
}

module DisplayDimension()
{
	// Display of dimensions
	echo("Base_Hight => ",Base_Hight,"mm");
	echo("Base_Width => ",Base_Width,"mm");
	echo("Base_Depth => ",Base_Depth+Move_offset,"mm");
	echo("Base_Radius => ",Base_Radius,"mm");
	echo("Range of movement => ",Move_offset," - ",Bolt_Length-Base_Thickness*3+Corner_r*2+Move_offset,"mm");
}

module ViseBase()
{
	// Vise Base
	difference(){
		minkowski(){
			sphere(mcr);
			union(){
				difference(){
					translate([bl/2,0,-mbr])rotate([0,270,0])
						roundedRect([mbh-mbr, mbw-mbr, mbd], mbr, $fn=32);
					translate([0,0,-mbr-mbh/2])
						cube([mbd*1.5, mbw*1.5, mbh/2-mbr+0.1],center=true);
					translate([bl/2-mbt,-mbw*1.5/2,-mbh/2+mbt])
						rotate([0,270,0])cube([mbh, mbw*1.5, mbd-mbt*2]);
					intersection(){
						translate([bl/2-mbd+mbt+mcr/2,0,0])
							gloove();
						translate([bl/2-mbt,-mbw*1.5/2,-mbh/2+mbt])
							rotate([0,270,0])cube([mbh, mbw*1.5, mbd-mbt]);
					}
				}
			translate([bl/2-mbt,0,0])rotate([0,270,0])cylinder(r=bd*1.35,h=mbt+mcr*2,$fn=32);
			}
		}
		translate([bl/2+mbt+0.1,0,0])rotate([0,270,0])cylinder(r=bd/2,h=bl,$fn=32);
		translate([bl/2-(mbt+mcr)*2+nt-mcr,0,0])rotate([0,270,0])cylinder(r=bhd/2/cos(30),h=nt+0.1,$fn=6,center=false);
		for(ay = [-1 : 2 : 1]) {
			translate([bl/2-mbt-mcr,rbs*ay-rw/2,-mbh/2+mbt*1.5])
				rotate([0,180,0])cube([mbd-mbt*2-mcr*2,rw,mbt]);
		}
	}	
}


module ViseSlider()
{
	// Vise Slider
	minkowski(){
		sphere(mcr);
		union(){
			difference(){
				translate([-bl/2,0,-mbr])rotate([0,270,0])
					roundedRect([mbh-mbr, mbw-mbr, mbt], mbr);
				translate([-bl/2+mbt/2,-mbw*1.5/2,-mbh/2+mbt+.15+mcr])
					rotate([0,180,0])cube([mbt*2,mbw*1.5,mbh]);
				translate([-bl/2-mbt,0,0])gloove();
			}
			difference(){
				translate([-bl/2+mbt-mcr,0,0])rotate([0,270,0])cylinder(r=bd*1.25,h=mbt,$fn=32);
				translate([-bl/2+mbt+0.1,0,0])rotate([0,270,0])cylinder(r=(bd+mcr)/2*1.1,h=mbt,$fn=32);
			}
			for(ay = [-1 : 2 : 1]) {
				translate([-bl/2+mbt,rbs*ay-rw/2+rm/2+mcr,-mbh/2+mbt*1.45])
					rotate([0,180,0])cube([mbt*2,rw-rm-mcr*2,mbt-rm-mcr]);
			}
		}
	}	
}

// size - [x,y,z]
// radius - radius of corners
module roundedRect(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];

	linear_extrude(height=z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	}
}
module gloove()
{
	for(ay = [-2 : 1 : 2]) {
		translate([0,mbw/6*ay,0])cylinder(r=0.5,h=mbh*2,center=true,$fn=32);
	}
	for(az = [-1 : 1 : 1]) {
		translate([0,0,mbw/6*az+2])
			rotate([90,0,0])cylinder(r=0.5,h=mbh*2,center=true,$fn=32);
	}
}
