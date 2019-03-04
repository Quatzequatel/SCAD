//OpenSCAD PuzzleCut Library Demo - by Rich Olson
//http://www.nothinglabs.com
//Tested on build 2015.03-2
//License: http://creativecommons.org/licenses/by/3.0/

//!!!!!
//IMPORTANT NOTE: Puzzlecut only works correctly when RENDERING (F6)!  Preview (F5) will not produce usable results!
//!!!!!

include <puzzlecutlib.scad>

stampSize = [500,500,100];		//size of cutting stamp (should cover 1/2 of object)

cutSize = 4;	//size of the puzzle cuts

xCut1 = [-18 ,-6, 4]; //locations of puzzle cuts relative to X axis center
yCut1 = [-4, 5, 16];	//for Y axis

kerf = -0.3;		//supports +/- numbers (greater value = tighter fit)
					//using a small negative number may be useful to assure easy fit for 3d printing
					//using positive values useful for lasercutting
					//negative values can also help visualize cuts without seperating pieces

//cutInTwo();	//cuts in two along y axis
cutInFour();	//cuts in four along x / y axis

//comment out lines as needed to render individual pieces

module cutInTwo()
{
	translate([0,-6,0])
		xMaleCut() drawOcto();

	translate([0,0,0])
		xFemaleCut() drawOcto();
}

module cutInFour()
{
	translate([6,-6,0])
		xMaleCut() yMaleCut() drawOcto();

	translate([-6,-6,0])
		xMaleCut() yFemaleCut() drawOcto();

	translate([6,6,0])
		xFemaleCut() yMaleCut() drawOcto();

	translate([-6,6,0])
		xFemaleCut() yFemaleCut() drawOcto();
}


module drawOcto()
{
	rotate ([0,0,16]) import("OctopusThickLegs.stl");
}