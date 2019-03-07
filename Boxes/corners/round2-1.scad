pad = 0.1;	// Padding to maintain manifold
b = 10;
h = 10;
w = 4;
r = 3;	// Radius of round
smooth = 360;	// Number of facets of rounding cylinder

z = h - r*h/b - r*pow(pow(h,2)+pow(b,2),0.5)/b;

difference() {
	rotate(a=[90,-90,0])
		linear_extrude(height = w, center = true, convexity = 10, twist = 0)
			polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
	translate([0,0,z])
		translate([-r,0,0])
			rotate(a=[0,90,90])
				cylinder(w+4*pad,r,r,center=true,$fn=smooth);
}