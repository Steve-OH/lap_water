//============================================================================================//
//  This is the geometric model for a large wooden slab, 1.5" W x 20" L x 1.5" T.                //
//============================================================================================//

// The units of diffusivity used in the simulation are cm^2 s^-1, so we convert lengths to
// centimetres, as required.

  inches = 2.54;

//============================================================================================//
//  the slab                                                                                  //
//============================================================================================//

Point(11)  = { 0.000 * inches,  0.000 * inches,  0.000 * inches};
Point(12)  = { 0.000 * inches, 20.000 * inches,  0.000 * inches};
Point(13)  = { 1.500 * inches, 20.000 * inches,  0.000 * inches};
Point(14)  = { 1.500 * inches,  0.000 * inches,  0.000 * inches};
Point(15)  = { 0.000 * inches,  0.000 * inches,  1.500 * inches};
Point(16)  = { 0.000 * inches, 20.000 * inches,  1.500 * inches};
Point(17)  = { 1.500 * inches, 20.000 * inches,  1.500 * inches};
Point(18)  = { 1.500 * inches,  0.000 * inches,  1.500 * inches};

Line(101) = { 11, 12};
Line(102) = { 12, 13};
Line(103) = { 13, 14};
Line(104) = { 14, 11};
Line(105) = { 15, 16};
Line(106) = { 16, 17};
Line(107) = { 17, 18};
Line(108) = { 18, 15};
Line(109) = { 11, 15};
Line(110) = { 12, 16};
Line(111) = { 13, 17};
Line(112) = { 14, 18};

Line Loop(201) = { 101, 102, 103, 104};
Line Loop(202) = { 105, 106, 107, 108};
Line Loop(203) = { 101, 110, -105, -109};
Line Loop(204) = { 102, 111, -106, -110};
Line Loop(205) = { 103, 112, -107, -111};
Line Loop(206) = { 104, 109, -108, -112};

Plane Surface(301) = {201};
Plane Surface(302) = {202};
Plane Surface(303) = {203};
Plane Surface(304) = {204};
Plane Surface(305) = {205};
Plane Surface(306) = {206};

Surface Loop(401) = {301, -302, -303, -304, -305, -306};

Volume(501) = {401};

//============================================================================================//
//  The physical surface is the union of all surfaces exposed to air.                         //
//============================================================================================//

Physical Surface(2000) = { 301, -302, -303, -304, -305, -306  // the outer faces
                         };

//============================================================================================//
//  The physical volume is just the solid volume of the slab.                                 //
//============================================================================================//

Physical Volume(3000) = {501};

//============================================================================================//
//  Because moisture gradients are very steep at the exposed surfaces when the simulation     //
//  begins, we set up a boundary layer with a smaller mesh size to minimize the error terms.  //
//  In principle, GetDP supports boundary faces as well as edges, but that doesn't seem to    //
//  work, so we add a few extra edges on the broad faces of the slab to ensure that the mesh  //
//  doesn't get too large there.                                                              //
//============================================================================================//

Field[1] = BoundaryLayer;
Field[1].EdgesList = { 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112 // slab edges
                     };
Field[1].hwall_n = 0.05 * inches;  // mesh size near the boundary is 1/20"
Field[1].hwall_t = 0.05 * inches;
Field[1].hfar    = 1.0  * inches;  // mesh size away from the boundary is 1"
Field[1].ratio   = 1.1;

Background Field = 1;

Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.Optimize = 1;

