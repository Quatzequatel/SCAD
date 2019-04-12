


//rotate([0,0,90])
//rotate([90,90,90])
//linear_extrude(height = 5, center = true, convexity = 10)
//polygon(t);

//#translate([10,0,0])
//rotate([0,-90,0])
//linear_extrude(height = 20, center = true, convexity = 10)
//polygon(t);
// 
// cube(20);
 
 
 module cubeWithTopOverhang(width, length, height, hang)
 {
     t = [[0,0],[hang,0],[0,hang]];
     cube([width, length, height]);
     
     #translate([0,length,height])
     rotate([180,0,0])
     {
        translate([width/2,0,0])
        rotate([0,-90,0])
        linear_extrude(height = width, center = true, convexity = 10)
        polygon(t);

        translate([width/2,length,0])
        rotate([90,-90,90])
        linear_extrude(height = width, center = true, convexity = 10)
        polygon(t);
             
        translate([0,length/2,0])
        rotate([270,-90,0])
        linear_extrude(height = length, center = true, convexity = 10)
        polygon(t);
             
        translate([width,length/2,0])
        rotate([90,-90,0])
        linear_extrude(height = length, center = true, convexity = 10)
        polygon(t);   
     }
}

 module bottomOverhang(width, length, height, hang)
 {
     t = [[0,0],[hang,0],[0,hang]];
     cube([width, length, height]);
     w = width + hang;
     l = length + hang;
     h = height + hang;
     
     
     translate([-hang/2,l-hang/2,0])
     rotate([180,0,0])
     {
        translate([w/2,0,0])
        rotate([0,-90,0])
        linear_extrude(height = w, center = true, convexity = 10)
        polygon(t);

        translate([w/2,l,0])
        rotate([90,-90,90])
        linear_extrude(height = w, center = true, convexity = 10)
        polygon(t);
             
        translate([0,l/2,0])
        rotate([270,-90,0])
        linear_extrude(height = l, center = true, convexity = 10)
        polygon(t);
             
        translate([w,l/2,0])
        rotate([90,-90,0])
        linear_extrude(height = l, center = true, convexity = 10)
        polygon(t);   
     }
}

// cube(20);
//translate([0,20,0])
// rotate([180,0,0])
cubeWithTopOverhang(20,10,15,2);