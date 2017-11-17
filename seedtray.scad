
meshX=26;
meshY=18;
meshZ=40;
Seedrows=4;
Seedcolumns=4;

spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

main();
cover();
lip();

//seedholder();

//translate([0,0,meshZ/2]){cube([meshX,meshY,meshZ], center=true);}


// The spokes. This scales the design in spoke() to produce the spokes for the wheel. 
// Change this an the spoke() module in order to customize the spokes.  
module spokes( diameter, width, number ) {

	union() {
		cylinder( h=width/6, r= diameter/4, center = true ); 

		for (step = [0:number-1]) {
		    rotate( a = step*(360/number), v=[0, 0, 1])
		spoke( width );
            //echo(step);
		}
	}

}

module spoke( width ) {
	translate ( [-meshX/2, 0, 0] )
	cube( [meshX, width, width], center=true); 
}

module positive(x1,y1,z1)
{
    difference()
    {
    translate([0,0,0]){Mesh(z1,y1,x1, center=true);}
    translate([0,0,-1]){Mesh(z1+2,y1-wallWidth,x1-wallWidth, center=true);}
    }
}
module Mesh(BaseX,Height,TopX,center)
{
    cylinder(BaseX,Height,TopX,$fn=4);
}

module negative( diameter, width, spokes, rows )
{
    VeritcalScreen(diameter,width,spokes,rows);
}

module seedholder()
{
    
        color("LightBlue") positive(meshX,meshY,meshZ);
        VeritcalScreen(meshX,spokeY,spokeCount,spokerows);
}

module VeritcalScreen(wallDiameter, screenwidth, spokes, rows)
{
    //echo(wallDiameter=wallDiameter,screenwidth=screenwidth,spokeCount=spokeCount,rows=rows);
    
    rowHeight=(meshZ/rows);
    for(i =[1:rows])
        translate([0,0,rowHeight*i-2])
        {
        spokes( wallDiameter, screenwidth, spokes );
        }
    
}


module cover()
{
    translate([0,0,meshZ-1])
    difference() 
    {
        cube([meshZ*(Seedcolumns+1),meshZ*(Seedrows+1),1]);
    for(x = [1:Seedcolumns], Y =[1:Seedrows])
    {
            //echo(Y=Y, x=1);
           translate([(40*x), (40*Y),-1]) color("Blue") cube([35,35,5],center=true)
            //echo(Y=Y, x=1);
        echo(x, Y);
    }
    }
}
module lip(x,y,wall, height)
{
    resize([0,0,0]) translate([x/2,y/2,height/2]) difference()
    {
    cube([x,y,height],true);
    cube([x-wall,y-wall,height+1], true);
    }
}


module seedholderArray()
{
for(x=[1:Seedcolumns])
    for(y=[1:Seedrows])
    translate([x*meshZ,y*meshZ, 0])
    rotate([0,0,45]) 
    difference()
{
    
    color("LightBlue") positive(meshX,meshY,meshZ);
            VeritcalScreen(meshX,spokeY,spokeCount,spokerows);
    
}
}

module main()
{
    cover();
    translate([0,0,meshZ-2]) lip(meshZ*(Seedcolumns+1),meshZ*(Seedcolumns+1),1,2);
    seedholderArray();
}