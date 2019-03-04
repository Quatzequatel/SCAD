// Jeff's Simple Parametric Clip (SPC)
//
// Free Software for a Voluntary World
//
// Google "voluntaryism"
//
// Thanks and enjoy!
//
// #####################################################################
//
// #####################################################################
//
// This is free and unencumbered software released into the public domain.
// 
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
// 
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// For more information, please refer to <http://unlicense.org/>


// Configurable Values
jaw_depth     = 20;
jaw_thickness = 5;
jaw_spacing   = 16.16;
tooth_height  = .75;

// The Object
module jeffs_spc() {


  // Calculated Values
  body_length = jaw_depth + (jaw_thickness * 2);
  body_width  = jaw_spacing + (jaw_thickness * 2);

  mouth_width = jaw_spacing - (tooth_height * 2);
  mouth_x_pos = jaw_depth + jaw_thickness;
  mouth_y_pos = jaw_thickness + tooth_height;

  difference() {

    // Jaw Body
    cube([body_length, body_width, jaw_thickness]);
  
  
    // Jaw Center Hole
    translate([jaw_thickness, jaw_thickness, -1])
    cube([jaw_depth, jaw_spacing, jaw_thickness + 2]);
  
  
    // Mouth
    translate([mouth_x_pos - 1, mouth_y_pos, -1])
    cube([jaw_thickness + 2, mouth_width, jaw_thickness + 2]);
  }
}

jeffs_spc();