//this file is used by multicutdemo.scad (does not render directly)

module drawDemoObject()
{
	difference()
	{
		cube([130,70,4], center=true);
		translate ([25,0,0]) cylinder(h=5, r=15, center=true);
		translate ([-25,0,0]) cylinder(h=5, r=15, center=true);
	}
}

