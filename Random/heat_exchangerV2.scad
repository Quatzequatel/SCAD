//first version by akaJes 2016 (c)

//pipe
pd=8;
pt=2;
//size
width=50;
length=100;
//segment
thickness=8;
wall=1;
number=6;
pipe_connected=1;
camera_ribs=3;

difference(){
  heat_exchager();
  translate([0,10,-thickness*2.5])cube([width/2,length-20,70]);
}

module arrow(cl){
  if (number==6)
    translate([0,0,20]){
      cylinder(d=pd,h=pd*2);
      translate([0,0,pd*2])cylinder(d1=pd*2,d2=1,h=pd);
    }
}
module heat_exchager(){
  for (i=[0:number-1])
    translate([0,0,(thickness-wall)*i])
      section(i%4,i==0||i==number-1);
}
module section(side=0,upper=1){
  difference(){
    union(){
      color(side%2?"red":"blue")
      camera(width,length,thickness,wall,side);
      holes(side,upper);
    }
    holes(side,upper,1);
  }
}
module holes(side,upper=1,hole=0){
  let(sh=pd/2+pt*2,ch=floor(side/2)%2)
  let (l=(upper?wall*3:0)){
    color(side%2?"red":"blue")
      translate([(width-pd*2)*(side%2)+pd,0,0]){
        translate([0,ch?sh:length-sh,wall]){
          mirror([0,0,1])pipe(pd,pt,wall+(side==0?l:0),hole);
          if (side==0&&upper)
            translate([0,0,-pd*8])arrow();
        }
        translate([0,ch?length-sh:sh,thickness-wall]){
          pipe(pd,pt,wall+(side!=0?l:0),hole);
          if (side!=0&&upper)
            arrow();
        }
      }
    let(ch2=ch!=side%2)
    translate([(width-pd*2)*(1-(side%2))+pd,0,0])
      translate([0,ch2?sh:length-sh,side==0?-l:0]){
        color(!side%2?"red":"blue")
          pipe(pd,pt,thickness+l,hole);
        if (upper)
          translate([0,0,side==0?-pd*8:0]) 
            color(!side%2?"lightcoral":"RoyalBlue")
              arrow();
      }
  }
}
module pipe(d,t,h,hole=0){
  if (hole)
    translate([0,0,-0.1])cylinder(d=d,h=h+.2);
  else
    difference(){
      cylinder(d=d+2*t,h=h);
      translate([0,0,-0.1])cylinder(d=d,h=h+.2);
    }
}
module camera(w,l,h,t,side=0,r=3,ribs=camera_ribs){
  difference(){
    rounded_cube(w,l,h,r);
    translate([t,t,t])rounded_cube(w-2*t,l-2*t,h-2*t,r);
  }
  if (ribs){
    intersection(){
      rounded_cube(w,l,h,r);
      let(step=l/(ribs+1))
        for (i=[1:ribs])
          let(hole=w/4,angle=45)
            translate([(i+side)%2?0:hole,step*i,0])
              rotate([angle,0,0])
                cube([w-hole,t,h/cos(angle)]);
      }
    }
}
module rounded_cube(w,d,h,ri){
  if(ri==0)
    cube([w,d,h]);
  else
    resize([w,d,h])
  let(min_s=min(min(w,d),h))
  let(r=min(ri,min_s/2))
  hull(){
    for (i=[r,h-r])
      for (j=[r,d-r])
        for (y=[r,w-r])
          translate([y,j,i])sphere(r,$fn=16);
  }
}