/*
    
*/

include <constants.scad>;
include <Casa_globals.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

//-------------------------------------------------------------------------------------------------------------------
/*
    Local verables
*/
PlanterRadius1 = convert_in2mm(104);
PlanterRadius2 = convert_in2mm(110);
PlanterHeight1 = convert_in2mm(18);
PlanterHeight2 = convert_in2mm(18+1);


//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
Draw_Planter() ;

module Draw_Planter() 
{
    $fn = 100;
    translate(v = [gdv(PropertyDic, "x"), 0, 0]) 
  difference() 
  {
    cylinder(h = PlanterHeight1, r = PlanterRadius2);
    translate(v = [0, 0, -1]) 
    cylinder(h = PlanterHeight2, r = PlanterRadius1);

    linear_extrude(height = 2*PlanterHeight2) 
    translate(v = [- PlanterRadius2, - PlanterRadius2, -50]) 
    square(size = [ 2 * PlanterRadius2,  PlanterRadius2]);

    linear_extrude(height = 2*PlanterHeight2) 
    translate(v = [0, -2, -50]) 
    square(size = [ 2 * PlanterRadius2,  PlanterRadius2 + 100]);

  }
}