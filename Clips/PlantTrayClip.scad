

jaw_depth     = 15;
jaw_thickness = 5;
jaw_spacing   = 44;//16.16;
tooth_height  = 7.75; //.75;

module planter_clip()
{
  // Calculated Values
  body_length = jaw_depth + (jaw_thickness * 2);
  body_width  = jaw_spacing + (jaw_thickness * 2);

  mouth_width = jaw_spacing - (tooth_height * 2);
  mouth_x_pos = jaw_depth + jaw_thickness;
  mouth_y_pos = jaw_thickness + tooth_height;

    box_main = [body_length, body_width, jaw_thickness];
    box_cutout = [jaw_depth-2, jaw_spacing, jaw_thickness + 2];
    box_slit = [jaw_thickness + 4, mouth_width, jaw_thickness + 2];
    
    move_cutout = [jaw_thickness, jaw_thickness, -1];
    move_slit= [mouth_x_pos - 3, mouth_y_pos+4, -1];
    
    difference()
    {
        cube(box_main);
        
        translate(move_cutout) cube(box_cutout);
        
        #translate(move_slit) cube(box_slit);
    }
}

planter_clip();