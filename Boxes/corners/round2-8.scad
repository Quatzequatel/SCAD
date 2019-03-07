pad = 0.1;	// Padding to maintain manifold
ch = 15;
cr = 20;
ct = 2;
r = 4;
smooth = 180;	// Number of facets of rounding cylinder

difference() {
	union() {
		// Basic cup shape
		difference() {
			cylinder(ch,cr,cr,center=false,$fn=smooth);
			translate([0,0,ct])
				cylinder(ch-ct+pad,cr-ct,cr-ct,center=false,$fn=smooth);
		}
		// Inside Fillet
		difference() {
			rotate_extrude(convexity=10,  $fn = smooth)
				translate([cr-ct-r+pad,ct-pad,0])
					square(r+pad,r+pad);
			rotate_extrude(convexity=10,  $fn = smooth)
				translate([cr-ct-r,ct+r,0])
					circle(r=r,$fn=smooth);
		}
	}		
	
	// Bottom Round
	difference() {
		rotate_extrude(convexity=10,  $fn = smooth)
			translate([cr-r+pad,-pad,0])
				square(r+pad,r+pad);
		rotate_extrude(convexity=10,  $fn = smooth)
			translate([cr-r,r,0])
				circle(r=r,$fn=smooth);
	}
}