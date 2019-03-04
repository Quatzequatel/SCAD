//this file is used by puzzlecutdemo1.scad (does not render directly)


outsideCircle = 72;
platformWidth = 16;
platformDepth = 4.5;
supportBeamWidth = 9;
supportCenterCircleRadius = 12;
centerHoleRadius = 3.5;

$fs = 2;
$fa = 2;

module drawDemoObject()
{

	linear_extrude(height = platformDepth) supportPlatform();

}

module beams()
{
		circle(supportCenterCircleRadius);
		translate ([0,-supportBeamWidth / 2, 0]) square([outsideCircle - platformWidth, supportBeamWidth]);
		rotate ([0,0,120]) translate ([0,-supportBeamWidth / 2, 0]) square([outsideCircle - platformWidth, supportBeamWidth]);
		rotate ([0,0,240]) translate ([0,-supportBeamWidth / 2, 0]) square([outsideCircle - platformWidth, supportBeamWidth]);
}

module supportPlatform()
{
	difference()
	{
		beams();
		circle(centerHoleRadius);
	}
	
	difference()
	{
		circle(outsideCircle);
		circle(outsideCircle - platformWidth);
	}
}