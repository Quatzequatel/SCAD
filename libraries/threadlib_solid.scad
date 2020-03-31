/*
* Written by Johnny, published on Thingiverse
* for suggestions please contact me via jcernato@gmail.com
* Version 30.01.2017_Experimental
*/

module s_thread(diameter, slope, height) {
    if($fn) {mypolygon(diameter, slope, $fn, height);}
    else {mypolygon(diameter, slope, 16, height); }
}

module mypolygon(diameter, slope, polygons, height) {
    n = polygons;
    d = diameter;
    k = slope;
/* Shape:
    g___d
    |    \
    |      \ c
    |       |
    |      / b
    |   a /
    |   |
    ----
    f   e
    */
    m = round(height/slope);
  
echo (height/slope);
    
function cosinus(n,i) = (cos((360/n)*i));
function sinus(n,i) = (sin((360/n)*i));
//function height(k,n,i,offset) = (k/n*i+offset*k)>height ? height : (k/n*i+offset*k)<0 ? 0 : (k/n*i+offset*k);
function height(k,n,i,offset) = (k/n*i+offset*k);
off2=1;    
points = [
/* A */  for(i=[0:n*m]) [(d-k)/2*cosinus(n,i),(d-k)/2*sinus(n,i),height(k,n,i,-0.9+off2)],
/* B */  for(i=[0:n*m]) [d/2*cosinus(n,i),d/2*sinus(n,i),height(k,n,i,-0.5+off2)],
/* C */  for(i=[0:n*m]) [d/2*cosinus(n,i),d/2*sinus(n,i),height(k,n,i,-0.4+off2)],
/* D */  for(i=[0:n*m]) [(d-k)/2*cosinus(n,i),(d-k)/2*sinus(n,i),height(k,n,i,0+off2)],
/* E */  for(i=[0:n*m]) [(d-k)/2*cosinus(n,i),(d-k)/2*sinus(n,i),height(k,n,i,-1+off2)],
/* F */  [0,0,height(k,n,0,-1+off2)],
/* G */  [0,0,height(k,n,n*m,0+off2)],
];

faces = [
/* === lower-faces === */
  for (i=[0:n*m-1]) [i, i+n*m+2, i+1],
  for (i=[0:n*m-1]) [i, i+n*m+1, i+n*m+2],
      
/* === vertical-outside-faces === */
  for (i=[0:n*m-1]) [i+n*m+1, i+n*m*2+2, i+n*m+2],
  for (i=[0:n*m-1]) [i+n*m+2, i+n*m*2+2, i+n*m*2+3],
      
/* === upper-faces === */
  for (i=[0:n*m-1]) [i+n*m*3+3, i+n*m*2+3, i+n*m*2+2],
  for (i=[0:n*m-1]) [i+n*m*3+3, i+n*m*3+4, i+n*m*2+3],
    
/* === vertical-inner-faces === */
  for (i=[0:n*m-1]) [i+n*m*4+4, i, i+1],
  for (i=[0:n*m-1]) [i+n*m*4+4, i+1, i+n*m*4+5],
    
/* === bottom-faces === */
  for(i=[1:n]) [i+n*m*4+3, i+n*m*4+4, 1+n*m*5+4],
  //for(i=[1:n]) [i+n*m*4+4,i+n*m*5+5, i+n*m*5+4],
      
/* === top-faces === */
  for(i=[0:n-1]) [i+n*m*4-n+3, 2+n*m*5+4, i+n*m*4-n+4],

/* === lower-sidewall (endstop) === */
  [n*m*3+3, n*m*2+2, n*m+1, 0, n*m*4+4, n*m*5+5],
  
/* === upper-sidewall (endstop) === */
  [n*m, n*m*2+1, n*m*3+2, n*m*4+3, n*m*5+6, n*m*4-n+3]
]; 

polyhedron(points, faces, convexity=2);
  
}
 
$fn=50;
s_thread(10,1.5,12);


