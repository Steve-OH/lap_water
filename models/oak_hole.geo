//============================================================================================//
//  This is the geometric model for a large wooden slab, 18" W x 96" L x 6" T, with a 1"      //
//  square hole cut through the middle of the broad face of the slab.                         //
//============================================================================================//

// The units of diffusivity used in the simulation are cm^2 s^-1, so we convert lengths to
// centimetres, as required.

  inches = 2.54;

//============================================================================================//
//  the slab itself                                                                           //
//============================================================================================//

Point(11)  = { 0.000 * inches,  0.000 * inches,  0.000 * inches};
Point(12)  = { 0.000 * inches, 96.000 * inches,  0.000 * inches};
Point(13)  = {18.000 * inches, 96.000 * inches,  0.000 * inches};
Point(14)  = {18.000 * inches,  0.000 * inches,  0.000 * inches};
Point(15)  = { 0.000 * inches,  0.000 * inches,  6.000 * inches};
Point(16)  = { 0.000 * inches, 96.000 * inches,  6.000 * inches};
Point(17)  = {18.000 * inches, 96.000 * inches,  6.000 * inches};
Point(18)  = {18.000 * inches,  0.000 * inches,  6.000 * inches};

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

//============================================================================================//
//  the hole                                                                                  //
//============================================================================================//

Point(51)  = { 8.500 * inches, 47.500 * inches,  0.000 * inches};
Point(52)  = { 8.500 * inches, 48.500 * inches,  0.000 * inches};
Point(53)  = { 9.500 * inches, 48.500 * inches,  0.000 * inches};
Point(54)  = { 9.500 * inches, 47.500 * inches,  0.000 * inches};
Point(55)  = { 8.500 * inches, 47.500 * inches,  6.000 * inches};
Point(56)  = { 8.500 * inches, 48.500 * inches,  6.000 * inches};
Point(57)  = { 9.500 * inches, 48.500 * inches,  6.000 * inches};
Point(58)  = { 9.500 * inches, 47.500 * inches,  6.000 * inches};

Line(151) = { 51, 52};
Line(152) = { 52, 53};
Line(153) = { 53, 54};
Line(154) = { 54, 51};
Line(155) = { 55, 56};
Line(156) = { 56, 57};
Line(157) = { 57, 58};
Line(158) = { 58, 55};
Line(159) = { 51, 55};
Line(160) = { 52, 56};
Line(161) = { 53, 57};
Line(162) = { 54, 58};

Line Loop(251) = { 151, 152, 153, 154};
Line Loop(252) = { 155, 156, 157, 158};
Line Loop(253) = { 151, 160, -155, -159};
Line Loop(254) = { 152, 161, -156, -160};
Line Loop(255) = { 153, 162, -157, -161};
Line Loop(256) = { 154, 159, -158, -162};

//============================================================================================//
//  the slab, with hole                                                                       //
//============================================================================================//

Plane Surface(301) = {201, 251};  // the Z faces of the slab and hole are coincident
Plane Surface(302) = {202, 252};
Plane Surface(303) = {203};
Plane Surface(304) = {204};
Plane Surface(305) = {205};
Plane Surface(306) = {206};
Plane Surface(307) = {253};
Plane Surface(308) = {254};
Plane Surface(309) = {255};
Plane Surface(310) = {256};

Surface Loop(401) = {301, -302, -303, -304, -305, -306, 307, 308, 309, 310};

Volume(501) = {401};

//============================================================================================//
//  some extra lines on the surface to improve the boundary layer mesh (see below)            //
//============================================================================================//

Point(91)  = { 6.000 * inches,  0.000 * inches,  0.000 * inches};
Point(92)  = { 6.000 * inches, 96.000 * inches,  0.000 * inches};
Point(93)  = {12.000 * inches,  0.000 * inches,  0.000 * inches};
Point(94)  = {12.000 * inches, 96.000 * inches,  0.000 * inches};
Point(95)  = { 6.000 * inches,  0.000 * inches,  6.000 * inches};
Point(96)  = { 6.000 * inches, 96.000 * inches,  6.000 * inches};
Point(97)  = {12.000 * inches,  0.000 * inches,  6.000 * inches};
Point(98)  = {12.000 * inches, 96.000 * inches,  6.000 * inches};

Line(191) = { 91, 92};
Line(192) = { 93, 94};
Line(193) = { 95, 96};
Line(194) = { 97, 98};

//============================================================================================//
//  The physical surface is the union of all surfaces exposed to air.                         //
//============================================================================================//

Physical Surface(2000) = { 301, -302, -303, -304, -305, -306  // the outer faces
                         , 307, 308, 309, 310                 // inside the hole
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
                     , 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132 // hole edges
                     , 191, 192, 193, 194  // extra edges
                     };
Field[1].hwall_n = 0.25 * inches;  // mesh size near the boundary is 1/4"
Field[1].hwall_t = 0.25 * inches;
Field[1].hfar    = 1.0  * inches;  // mesh size away from the boundary is 1"
Field[1].ratio   = 1.1;

Background Field = 1;

Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.Optimize = 1;

