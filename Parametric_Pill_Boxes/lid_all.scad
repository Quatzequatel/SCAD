
/* lid for the octagonal and circular
    pill box
   length_edge needs to be greater than
   the length_edge for the body of the
   box so that it fits -

   PCM  February 2016

*/
 
// settable parameters - set to suit lid
// the following values can be set to one's
// liking at least over a small range -
//  change length_edge to suit lid
//   if round_or_octa = 0 an octahedral box
//   if round_or_octa = 1 a cylindrical box
//   radius of the round box is approximately
//   length_edge divided by 0.7654 
//


  round_or_octa = 0;
 length_edge = 31.5;
 height = 5;
 thickness = 1.5;


 // transfer values to symbols used in the code

leh = length_edge;
ht = height ;
th = thickness;


//  start of code

if (round_or_octa==0)

    difference()
    {
          union()
      {
          octa_hole();
          frame_8();
           linear_extrude(height=th)
          circle(r=12);
                }
                 cylinder(r=5,h=2*th+1,center=true);
            }


else
  if (round_or_octa==1)

    difference()
    {
          union()
      {
    difference()
{
          round_body(leh);
     translate([0,0,-0.5])
    linear_extrude(height=th+1)
    wedge(leh-th);
}
          linear_extrude(height=th)
          circle(r=12);
                }
                 cylinder(r=5,h=2*th+1,center=true);
            }

  else

{}

module octa_hole()
{
    dist = (leh/2)*sqrt((1+cos(45))/(1-cos(45))) ;
linear_extrude(height=th)
   octagon_less(leh);
   for (j = [0:1:7])
    {
translate([dist*cos(22.5+j*45),dist*sin(22.5+j*45),ht/2])
rotate([0,90,22.5+j*45])
    translate([0,0,-th/2])
 cube([ht,leh,th],center=true);
    }
}



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
rr is length of the longer side


*/
   r = x;

polygon

    (points = [ [0,0],[-r*sin(22.5) ,r*cos(22.5)],[-r*(1/cos(22.5)),0],
               [-r*sin(22.5), -r*cos(22.5)],

    ]);

}



module octagon_less(l)
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
           [0,0],
                      ]);
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

