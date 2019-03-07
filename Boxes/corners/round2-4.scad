pad = 0.1;	// Padding to maintain manifold
ch = 15;
cr = 20;
ct = 2;
r = 4;
smooth = 180;	// Number of facets of rounding cylinder

difference() {
	cylinder(ch,cr,cr,center=false,$fn=smooth);
	translate([0,0,ct])
	cylinder(ch-ct+pad,cr-ct,cr-ct,center=false,$fn=smooth);
}
