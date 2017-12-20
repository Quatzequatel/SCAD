
 triangle_points =[[0,0],[3,0],[0,4]];
 triangle_paths =[[0,1,2]];
 
////rotate([60,0,0])
linear_extrude(height = 10, center = true, convexity = 10, scale=[1,1], $fn=100)
polygon(triangle_points,triangle_paths,10);