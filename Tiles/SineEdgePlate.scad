SineEdgePlate();
module SineEdgePlate()
{
   function to2d(pts)=[for(p=pts)[p[0],p[1]]];
   pts= concat( [ [36,0], [0,0]]
                , to2d(sinePts( h=1, n=2, base=5 ))
                 ); 
   
   linear_extrude(height=10, scale=[1,1])
   polygon( pts );
//   echo(pts);
}

function sinePts(xs=[0:3600],xd=100, n=5, h=5, base=0, z=0)=
(
   [ for(x=xs) [(x-xs[0])/xd,h*sin(x/n)+base,z] ]
);