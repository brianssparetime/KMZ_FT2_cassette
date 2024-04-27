
// Ft-2 cassette case

$fn = 100;

//external_y = 39;
// brianssparetime: measured height of old cannister: ~38.5 to 38.6
external_y = 38.5;

external_d = 24.5;
external_r = external_d/2;

sleeve_external_d = 23;
sleeve_external_r = sleeve_external_d/2;

internal_d = 22;
internal_r = internal_d/2;

slot_width = 2;

lid_hole_r = 6;

spindle_d = 11;
spindle_r = spindle_d/2;

peg_z = 6;
peg_r = 3;

end_y = 1;

leader_slot_x = 2;
leader_slot_z = 17.5;

/*

    Film Cassette for KMZ FT-2 panoramic camera.

    This is not well polished code! It is just something functional to do what I need.

    Uncomment the different lines below (one at a time) to render the three main parts of the cassette.
    
    Print 0.16mm regular black PLA.
    
    The lid is rendered the "wrong" way around. This is because it is easier to flip it on the z-axis
    when it is imported into the slicing software than mess around here trying to get it right.

    [brianssparetime:  ignore the above.  I fixed this.]

    The spindle needs to be printed on a 45 degree slope with some support. At 45 degrees the 
    support stuff shouldn't get on the top surface of the disc. It is also a fraction too long by design.
    During finishing sand the top down to fit the camera snuggly.

    [brianssparetime:  ignore the above.  I fixed this - spindle and cannister are sized correctly so no finishing is needed]
    
    The body should be lined on the walls with "felt". Cut a strip 36mm wide and long enough to go around the cassette and out the film slot. After it is stuck down trim most of it out leaving just a little sticking out. I use sticky back Fablon Velour (it for for used on card tables and that kind of thing). CS glue it if it comes loose.

    [brianssparetime:  you should still do this ^ ]
    
    No attempt is made to keep this pretty so the draft renderings will look odd because
    of the overlapping surfaces. Do a full render to see the models properly.
    
    License is free to do what you like but a credit would be appreciated.
    
    Roger Hyam (roger@hyam.net) 2021-11-03

*/


// uncomment this to render the spindle
spindle();

// uncomment this to render the base
base();

// uncomment this to render the lid
translate([50,0,-external_y/2]) lid();


//negative_lid();
    


module spindle(){
    
    ring_z = external_y - 2*end_y - 1.8;
    
    translate([0,0,end_y])
        
        difference(){
            
            union(){
                // body
                cylinder(external_y - end_y + 0.3, spindle_r, spindle_r);
                // no need for the extra .3 ???
                //cylinder(external_y - end_y, spindle_r, spindle_r);
                
                // ring
                translate([0, 0, ring_z]) cylinder(0.8, internal_r * 0.9, internal_r * 0.9);
            }
        
            // hole in top
            cylinder(external_y, 3.5, 3.5);

            
            // slot in top
            translate([-1, -lid_hole_r, external_y - 3])
                cube([2,lid_hole_r * 2, end_y*3]);
            
            // leader slot for film
            translate([-leader_slot_x/2, -15, (ring_z/2) - (leader_slot_z/2)])
                cube([leader_slot_x, 30, leader_slot_z]);
            
            
        }
        
}

module base(){

    difference(){
            outer();
            negative_lid();
    }
    
}

module lid(){
    
    // this is the negative lid shape with the 
    // holes put back in it.
    difference(){
        negative_lid(0.25);
        // central hole
        cylinder(external_y + end_y, lid_hole_r,lid_hole_r);
        
        // film slot
        translate([0,sleeve_external_r - slot_width + 0.3,end_y]) 
            cube([sleeve_external_r +3, slot_width, external_y - end_y*2]);
        
    }
    
}


// only used to construct the base from the outer and the lid
module negative_lid(fudge = 0){
    
        // very top layer
        translate([0,0,external_y - end_y])
            union(){ 
                cylinder(end_y, external_r, external_r);
                cube([external_r, external_r, end_y]);    
            }
            
        // sides        
        translate([0,0,external_y/2])
            
            difference(){
                union(){ 
                    cylinder(external_y/2, external_r, external_r);
                    cube([external_r, external_r, external_y/2]);  
                }
                // cutting out the inside - with a fudge factor?
                
                cylinder(external_y/2, sleeve_external_r + fudge, sleeve_external_r + fudge);
                cube([sleeve_external_r + fudge, sleeve_external_r + fudge, external_y/2]);
            }

    
}
   
module outer(){
 
     difference(){
     
         // outer shape
        union(){ 
            cylinder(external_y, external_r, external_r);
            cube([external_r, external_r, external_y]);    
        }
        
        // central spiral
        translate([0,0,end_y])            
            union(){
                
                //spiral
                cylinder(external_y - end_y*2, internal_r, internal_r);
                cube([internal_r, internal_r, external_y - end_y*2]);
          
                // central hole
                cylinder(external_y + end_y, lid_hole_r,lid_hole_r);
                
                // film slot
                translate([0,internal_r - slot_width,0]) 
                    cube([external_r, slot_width, external_y - end_y*2]);
            }

     }
     
    // bottom peg
    cylinder(peg_z, peg_r, peg_r * 0.8);


}

