$fn=360;
use <..//..//libraries//Threads//threads-library-by-cuiso-v1.scad>

// Bolt Diameter
Bolt_Diameter = 9.3;
Bolt_Length = 45;
Head_Diameter = 20;
Head_Thickness = 7.65;
Head_Space = 15;

function HeadRadius() = Head_Diameter/2 + Head_Space;
function HeadThickness() = Head_Thickness + Head_Space/2;

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
Knob2 = false;
ViseBase= false;
ViseSlider=false;
BordInsert=true;

Build();

module Build(arg)
{
	DisplayDimension();

	if(CenterBolt)
	{
		// CenterBolt();
	}
	if(Knob2)
	{
        difference()
        {
            Knob2();
            CenterBolt();
        }
	}
    if(BordInsert)
    {
        difference()
        {
            BordInsert();
            // CenterBolt();
			AddScrewHoles();

        }

        
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
	translate([Bolt_Length/2,0,0])rotate([0,270,0]){
		cylinder(r=Bolt_Diameter/2,h=Bolt_Length,$fn=60);

	translate([0,0,-Head_Thickness])
        cylinder(r=Head_Diameter/2,h=Head_Thickness,$fn=6);
	}

}

module CenterBolt()
{
	// Center Bolt
	translate([Bolt_Length/2,0,0])rotate([0,270,0])
    {
		cylinder(r=Bolt_Diameter/2,h=Bolt_Length,$fn=60);

	    translate([0,0,-Head_Thickness])
        cylinder(r=Head_Diameter/2,h=Head_Thickness,$fn=6);
	}

}

module Knob2()
{
    translate([Bolt_Length/2,0,0])
    rotate([0,90,0])
    linear_extrude(HeadThickness(), $fn=100) 
    //offset(0.25) 
    scale([HeadRadius(), HeadRadius(), 0])
    polygon(shape_pts, convexity = 10);    
}

module BordInsert()
{
    translate([Bolt_Length/2,0,0])
        rotate([0,90,0])
    difference()
    {
        linear_extrude(HeadThickness(), $fn=100) 
        //offset(0.25) 
        scale([2*HeadRadius(), 2*HeadRadius(), 0])
        square(size=[1, 2], center=true);

        translate([0,0,-(Bolt_Length - HeadThickness())])
        {
            #thread_for_nut(diameter=Bolt_Diameter, length=Bolt_Length, usrclearance=0.1); 
            %cylinder(r=Bolt_Diameter/2,h=Bolt_Length,$fn=60);
        }

    }

}

module Knob()
{
	translate([Bolt_Length/2,0,0])
		rotate([0,90,0])
        scale([2,2,2])
        import("..//..//Shop Accessories//Vise//levelKnobs_m5.stl", convexity = 5);	
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

module AddScrewHoles()
{
	    Screw_Head_OD = 9.25;
        Screw_Neck_OD = 3.25;
        ScrewHoleX = 5;
        ScrewHoleZ = 10 + 0.25;

		translate([32,25,-5])
		rotate([0,-90,0])
        translate([ScrewHoleX, 0, ScrewHoleZ])
        ScrewHole(15 + 1, 4, Screw_Neck_OD, Screw_Head_OD);

		translate([32,-25,5])
		rotate([0,-90,0])
        translate([-ScrewHoleX, 0, ScrewHoleZ])
        ScrewHole(15 + 1, 4, Screw_Neck_OD, Screw_Head_OD);
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

module ScrewHole(height, od, id, insetDiameter)
{
    echo("ScrewHole", height=height, od=od, id=id, insetDiameter=insetDiameter);
    //translate([0, 0, height+1])
    rotate([0, 180, 0]) 
    {
        wall = od - id;
        cylinder(h=height + 1, d1=od, d2=od);;
        if(insetDiameter > id)
        {
            cylinder(h=insetDiameter, d1 = insetDiameter, d2 = 1);
        }
    }
}

shape_pts = 
[
        [1, 0], [1.00243, 0.0250661], [1.00949, 0.0505168], [1.02078, 0.0767027], [1.03574, 0.103921], [1.05341, 0.132366], [1.07213, 0.162036], [1.08931, 0.192599], [1.10153, 0.223291], [1.10534, 0.252984], [1.09878, 0.280565], [1.08248, 0.305421], [1.0592, 0.327651], [1.03236, 0.347851], [1.00475, 0.366763], [0.978186, 0.385041], [0.953606, 0.403179], [0.931381, 0.421528], [0.911562, 0.440335], [0.894046, 0.459784], [0.878684, 0.480027], [0.865328, 0.501216], [0.853864, 0.523509], [0.844214, 0.54709], [0.836323, 0.57216], [0.830132, 0.598928], [0.825521, 0.627566], [0.822232, 0.658135], [0.819736, 0.690455], [0.817079, 0.723895], [0.812721, 0.757129], [0.804567, 0.788007], [0.790428, 0.813856], [0.768988, 0.832442], [0.740679, 0.84314], [0.707588, 0.847282], [0.672422, 0.84736], [0.637484, 0.845927], [0.604258, 0.844986], [0.573504, 0.845899], [0.545492, 0.849555], [0.520225, 0.856571], [0.497588, 0.867454], [0.477344, 0.882572], [0.459023, 0.901873], [0.442125, 0.92518], [0.4261, 0.952123], [0.410283, 0.981901], [0.393827, 1.01299], [0.375711, 1.04286], [0.354893, 1.06808], [0.330689, 1.08517], [0.303189, 1.09212], [0.27331, 1.08946], [0.242365, 1.0798], [0.211501, 1.06638], [0.181429, 1.05191], [0.152445, 1.03819], [0.124566, 1.0262], [0.0976629, 1.01638], [0.0715432, 1.00888], [0.0459962, 1.00369], [0.0208138, 1.00076], [-0.00420516, 1.00003], [-0.029257, 1.0015], [-0.0545393, 1.00518], [-0.0802554, 1.01114], [-0.106615, 1.01942], [-0.133827, 1.03], [-0.162068, 1.04265], [-0.191431, 1.05676], [-0.221821, 1.07112], [-0.252815, 1.08362], [-0.283547, 1.09129], [-0.312765, 1.09094], [-0.339223, 1.0805], [-0.362252, 1.06034], [-0.382058, 1.03314], [-0.399495, 1.00252], [-0.415629, 0.971643], [-0.431432, 0.942691], [-0.447683, 0.916909], [-0.465002, 0.894922], [-0.483915, 0.877014], [-0.504919, 0.86333], [-0.528425, 0.853803], [-0.554605, 0.847977], [-0.58355, 0.845322], [-0.615185, 0.845152], [-0.649102, 0.84644], [-0.684325, 0.847621], [-0.719085, 0.846477], [-0.750864, 0.840374], [-0.777029, 0.827082], [-0.795964, 0.805884], [-0.807876, 0.778045], [-0.814498, 0.746088], [-0.818073, 0.712586], [-0.820535, 0.679415], [-0.823216, 0.64764], [-0.826908, 0.617716], [-0.832031, 0.589722], [-0.838784, 0.563547], [-0.847261, 0.539001], [-0.857515, 0.515875], [-0.869604, 0.493973], [-0.883621, 0.47312], [-0.89969, 0.45316], [-0.917965, 0.433945], [-0.938587, 0.415315], [-0.961622, 0.397068], [-0.986934, 0.378929], [-1.01399, 0.360502], [-1.04159, 0.341236], [-1.0676, 0.320435], [-1.08891, 0.297371], [-1.10216, 0.271575], [-1.10516, 0.243182], [-1.0982, 0.213017], [-1.0839, 0.182256], [-1.06585, 0.151931], [-1.04725, 0.122655], [-1.03035, 0.0946346], [-1.01654, 0.0677918], [-1.00662, 0.0418897], [-1.00108, 0.0166095], [-1.00028, -0.00841256], [-1.00431, -0.0335665], [-1.01284, -0.0592275], [-1.02544, -0.0857312], [-1.04145, -0.113348], [-1.05969, -0.142219], [-1.07823, -0.172246], [-1.09416, -0.202961], [-1.10389, -0.233452], [-1.10431, -0.262543], [-1.09428, -0.289239], [-1.07526, -0.313169], [-1.05041, -0.334636], [-1.02305, -0.354322], [-0.995637, -0.372955], [-0.969669, -0.391138], [-0.94586, -0.409314], [-0.924449, -0.427793], [-0.90542, -0.446798], [-0.888646, -0.466498], [-0.873973, -0.487042], [-0.861265, -0.508583], [-0.850418, -0.531288], [-0.841366, -0.555347], [-0.834055, -0.580966], [-0.828414, -0.608347], [-0.824286, -0.637636], [-0.82134, -0.668832], [-0.818924, -0.701629], [-0.815897, -0.735188], [-0.810516, -0.767908], [-0.800573, -0.797397], [-0.78405, -0.820992], [-0.760154, -0.836891], [-0.729947, -0.845154], [-0.69586, -0.847627], [-0.660552, -0.846933], [-0.626065, -0.845476], [-0.593616, -0.845034], [-0.563771, -0.846788], [-0.53669, -0.851514], [-0.512324, -0.859775], [-0.490532, -0.872065], [-0.470991, -0.888605], [-0.453205, -0.909278], [-0.436667, -0.933866], [-0.420794, -0.961881], [-0.404867, -0.992316], [-0.387972, -1.02333], [-0.369055, -1.05204], [-0.347143, -1.07488], [-0.321775, -1.08867], [-0.29334, -1.0922], [-0.262955, -1.08683], [-0.231928, -1.07555], [-0.201274, -1.06152], [-0.171552, -1.04715], [-0.142947, -1.03393], [-0.115416, -1.02264], [-0.0887992, -1.01359], [-0.0628957, -1.00688], [-0.0374943, -1.00245], [-0.012389, -1.00027], [0.0126192, -1.00028], [0.0377263, -1.00249], [0.0631314, -1.00693], [0.0890405, -1.01367], [0.115664, -1.02273], [0.143205, -1.03404], [0.17182, -1.04728], [0.201553, -1.06165], [0.232213, -1.07567], [0.263239, -1.08691], [0.293613, -1.09221], [0.322024, -1.08859], [0.34736, -1.07471], [0.369241, -1.0518], [0.388135, -1.02305], [0.405016, -0.99203], [0.420939, -0.961611], [0.436815, -0.933623], [0.453363, -0.90907], [0.471162, -0.888434], [0.490722, -0.871933], [0.512536, -0.859681], [0.536927, -0.851455], [0.564033, -0.846759], [0.593903, -0.845029], [0.626374, -0.845487], [0.660876, -0.846946], [0.696183, -0.847623], [0.730247, -0.845108], [0.760406, -0.836782], [0.784236, -0.820809], [0.800692, -0.797149], [0.810583, -0.767618], [0.815933, -0.73488], [0.818947, -0.701321], [0.821364, -0.668537], [0.824318, -0.637358], [0.828458, -0.608086], [0.834114, -0.580722], [0.841441, -0.555118], [0.85051, -0.531073], [0.861373, -0.50838], [0.874099, -0.486849], [0.88879, -0.466313], [0.905584, -0.44662], [0.924635, -0.427621], [0.946068, -0.409146], [0.969898, -0.390971], [0.995884, -0.372786], [1.0233, -0.354146], [1.05066, -0.334448], [1.07546, -0.312961], [1.09442, -0.289006], [1.10436, -0.262285], [1.10384, -0.233176], [1.09403, -0.202677], [1.07807, -0.171966], [1.05952, -0.141947], [1.04129, -0.113088], [1.02531, -0.0854827], [1.01274, -0.058988], [1.00425, -0.0333334], [1.00027, -0.00818236]
];