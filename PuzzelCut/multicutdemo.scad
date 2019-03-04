//OpenSCAD PuzzleCut Library Demo - by Rich Olson
//http://www.nothinglabs.com
//Tested on build 2015.03-2
//License: http://creativecommons.org/licenses/by/3.0/

//!!!!!
//IMPORTANT NOTE: Puzzlecut only works correctly when RENDERING (F6)!  Preview (F5) will not produce usable results!
//!!!!!

include <puzzlecutlib.scad>
include <demoobject2.scad>

stampSize = [500,500,100];		//size of cutting stamp (should cover 1/2 of object)

cutSize = 7;	//size of the puzzle cuts

xCut1 = [-51, -2, 55];			//locations of puzzle cuts relative to Y axis center
yCut1 = [-20, 20];				//locations of puzzle cuts relative to Y axis center
yCut2 = [-25, -10, 20];			//additional Y cut
yCut3 = [-25, 25];				//additional Y cut

kerf = -0.75;	//supports +/- numbers (greater value = tighter fit)
					//using a small negative number may be useful to assure easy fit for 3d printing
					//using positive values useful for lasercutting
					//negative values can also help visualize cuts without seperating pieces

xMaleCut(offset = 0, cut = xCut1) 
	yCuts();

xFemaleCut(offset = 0, cut = xCut1) 
	yCuts();

module yCuts()
{
		yMaleCut(offset = -45, cut = yCut1)
			drawDemoObject();

		yFemaleCut(offset = -45, cut = yCut1)
			yMaleCut(offset = -6, cut = yCut2)
				drawDemoObject();

		yFemaleCut(offset = -6, cut = yCut2)
			yMaleCut(offset = 35, cut = yCut3)
				drawDemoObject();

		yFemaleCut(offset = 35, cut = yCut3)
				drawDemoObject();

}
