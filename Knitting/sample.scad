//surface.scad
$fn=100;
surface(file = "sample.dat", center = false, convexity = 5);

// d = sin(1:0.2:10) * cos(1:0.2:10)) * 10;
// echo(d=d);

//  for(i=[0:36])
//  echo(i = i, sin= sin(i), value = (sin(i*10)*50)+50)
//     translate([i*10,0,0])
//        cylinder(r=5,h=(sin(i*10)*50)+50);