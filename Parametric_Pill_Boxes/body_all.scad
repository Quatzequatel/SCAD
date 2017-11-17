/*

makes a little octagonal pill box with 7 compartments
or the same box with a cylindrical surface

somewhat parametric - see below

A screw with an octagonal head is used to hold the
top in place - When the screw is loosened by a few
turns the top can be rotated to make one of the
compartments available.

PCM  February 2016
*/



 use <threads.scad>
font = "Liberation Sans";
letter_height = 2;


// the following values can be set to one's
// liking at least over a small range -
//  if length_edge is changed values for the
//  lid will have to be changed to correspond
//   if round_or_octa = 0 an octahedral box
//   if round_or_octa = 1 a cylindrical box
//   radius of the round box is approximately
//   length_edge divided by 0.7654 


 round_or_octa = 1;
 length_edge = 30;
 height = 20;
 thickness = 3;
 letter_size = 7;


 // transfer values to symbols used in the code

leh = length_edge;
ht = height ;
th = thickness;


//  start of code

   if (round_or_octa == 0)
       
      difference()
 {
     union()
 {
      octa_body()
      frame_8();
     dividers(leh,th,ht);
     linear_extrude(height=ht)
     wedge(leh);
     decorate();
     cylinder (r=8,h=ht,$fn=48);
 }

  translate([0,0,ht-12])
    metric_thread (diameter=9.2, pitch=2, length=13, internal=true);
 }


   
   else
       
   if (round_or_octa == 1)

    difference()
 {
     union()
 {
      round_body(leh);
     dividers(leh,th,ht);
     linear_extrude(height=ht)
     wedge(leh);
     decorate();
     cylinder (r=8,h=ht,$fn=48);
 }
  translate([0,0,ht-12])
    metric_thread (diameter=9.2, pitch=2, length=13, internal=true);
 }

  else
      
  {}



module decorate()
 {
     rr = sqrt((leh*leh)/(2-2*cos(45)))-1;
     di = (leh/2)*sqrt((1+cos(45))/(1-cos(45)))-1 ;
        dist = round_or_octa==1 ? rr : di;
    
   for (j = [0:1:6])
    {
     translate([dist*cos(22.5+j*45),dist*sin(22.5+j*45),ht/4])
     rotate([0,90,22.5+j*45])
     rotate([0,0,90])
    linear_extrude(height = letter_height)
      {text(days[j][0],size = letter_size, font = font, halign = "center",
     valigh = "baseline", $fn = 16);}
 }

 }

days = [["Sun"],["Mon"],["Tue"],["Wed"],["Thu"],["Fri"],["Sat"]];




module octa_body()
{
    dist = (leh/2)*sqrt((1+cos(45))/(1-cos(45))) ;
linear_extrude(height=th)
   octagon(leh);
    for (j = [0:1:7])
    {
translate([dist*cos(22.5+j*45),dist*sin(22.5+j*45),ht/2])
rotate([0,90,22.5+j*45])
    translate([0,0,-th/2])
 cube([ht,leh,th],center=true);
    }
}

module round_body(l)
{
rr = sqrt((l*l)/(2-2*cos(45)));
  translate([0,0,ht/2])  
difference()
{
cylinder(r=rr,$fn=96,h=ht,center=true);
translate([0,0,th])    
cylinder(r=rr-th,$fn=96,center=true,h=ht);    
}}

 module frame_8()
{
    rr = sqrt((leh*leh)/(2-2*cos(360/8)));
    l = (rr-(th/cos(360/16)))*sqrt(2-2*cos(360/8));
linear_extrude(height=th)
difference()
{
octagon(leh);
octagon(l);
}
translate([0,0,ht-th])
linear_extrude(height=th)
difference()
{
octagon(leh);
octagon(l);
}
for (j = [0:45:315])
 {
rotate([0,0,j])
translate([rr,0,0])
 linear_extrude(height=ht)
octa_kite(th);
 }
}


module octa_kite(x)
{
/*
makes a kite
*/
   r = x;

polygon

    (points = [ [0,0],[-r*sin(22.5) ,r*cos(22.5)],[-r*(1/cos(22.5)),0],
               [-r*sin(22.5), -r*cos(22.5)],

    ]);

}



module octagon (l)
{

/*
l is the length of the sides
  of the octagon -
  it is centered at the origin
pcm
*/

rr = sqrt((l*l)/(2-2*cos(45)));

polygon([
          [ rr,0 ],
           [ cos(45)*rr,sin(45)*rr],
           [ cos(90)*rr,sin(90)*rr],
           [ cos(135)*rr,sin(135)*rr],
           [ cos(180)*rr,sin(180)*rr],
           [ cos(225)*rr,sin(225)*rr],
           [ cos(270)*rr,sin(270)*rr],
           [ cos(315)*rr,sin(315)*rr],
                      ]);
}


module dividers(cx,cy,cz)

/* makes dividers with the cube command
cx, cy, cz are parameters for the size
of the cube -
*/

{
    rr = sqrt((cx*cx)/(2-2*cos(45)));

for (j = [0:45:315])
{
rotate([0,0,j])
    translate([0,-cy/2,0])
cube(size=[rr-cy,cy,cz],center=false);
}

}


module wedge(l)
{

/*
l is the length of the sides
  of the octagon -
  it is centered at the origin
pcm
*/

rr = sqrt((l*l)/(2-2*cos(45)));

polygon([
          [ rr,0 ],
           [ cos(315)*rr,sin(315)*rr],
           [0,0],
                      ]);
}
