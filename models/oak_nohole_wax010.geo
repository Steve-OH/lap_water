//============================================================================================//
//  This is the geometric model for a large wooden slab, 18" W x 96" L x 6" T, with wax       //
//  coatings 0.010" thick on the two end-grain surfaces.                                      //
//============================================================================================//

// The units of diffusivity used in the simulation are cm^2 s^-1, so we convert lengths to
// centimetres, as required.

  inch = 2.54;

//============================================================================================//
//  the slab itself                                                                           //
//============================================================================================//

Point(11)   = { 0.000 * inch,  0.000 * inch,  0.000 * inch};
Point(12)   = { 0.000 * inch, 96.000 * inch,  0.000 * inch};
Point(13)   = {18.000 * inch, 96.000 * inch,  0.000 * inch};
Point(14)   = {18.000 * inch,  0.000 * inch,  0.000 * inch};
Point(15)   = { 0.000 * inch,  0.000 * inch,  6.000 * inch};
Point(16)   = { 0.000 * inch, 96.000 * inch,  6.000 * inch};
Point(17)   = {18.000 * inch, 96.000 * inch,  6.000 * inch};
Point(18)   = {18.000 * inch,  0.000 * inch,  6.000 * inch};

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
//  some extra lines on the surface to improve the boundary layer mesh (see below)            //
//============================================================================================//

Point(21)  = { 6.000 * inch,  0.000 * inch,  0.000 * inch};
Point(22)  = { 6.000 * inch, 96.000 * inch,  0.000 * inch};
Point(23)  = {12.000 * inch,  0.000 * inch,  0.000 * inch};
Point(24)  = {12.000 * inch, 96.000 * inch,  0.000 * inch};
Point(25)  = { 6.000 * inch,  0.000 * inch,  6.000 * inch};
Point(26)  = { 6.000 * inch, 96.000 * inch,  6.000 * inch};
Point(27)  = {12.000 * inch,  0.000 * inch,  6.000 * inch};
Point(28)  = {12.000 * inch, 96.000 * inch,  6.000 * inch};

Line(191) = { 21, 22};
Line(192) = { 23, 24};
Line(193) = { 25, 26};
Line(194) = { 27, 28};

//============================================================================================//
//  the wax layer at the Y = 0" end of the slab                                               //
//============================================================================================//

Point(31)  = { 0.000 * inch, -0.010 * inch,  0.000 * inch};
Point(32)  = { 0.000 * inch,  0.000 * inch,  0.000 * inch};
Point(33)  = {18.000 * inch,  0.000 * inch,  0.000 * inch};
Point(34)  = {18.000 * inch, -0.010 * inch,  0.000 * inch};
Point(35)  = { 0.000 * inch, -0.010 * inch,  6.000 * inch};
Point(36)  = { 0.000 * inch,  0.000 * inch,  6.000 * inch};
Point(37)  = {18.000 * inch,  0.000 * inch,  6.000 * inch};
Point(38)  = {18.000 * inch, -0.010 * inch,  6.000 * inch};

Line(121) = { 31, 32};
Line(122) = { 32, 33};
Line(123) = { 33, 34};
Line(124) = { 34, 31};
Line(125) = { 35, 36};
Line(126) = { 36, 37};
Line(127) = { 37, 38};
Line(128) = { 38, 35};
Line(129) = { 31, 35};
Line(130) = { 32, 36};
Line(131) = { 33, 37};
Line(132) = { 34, 38};

Line Loop(221) = { 121, 122, 123, 124};
Line Loop(222) = { 125, 126, 127, 128};
Line Loop(223) = { 121, 130, -125, -129};
Line Loop(224) = { 122, 131, -126, -130};
Line Loop(225) = { 123, 132, -127, -131};
Line Loop(226) = { 124, 129, -128, -132};

Plane Surface(321) = {221};
Plane Surface(322) = {222};
Plane Surface(323) = {223};
Plane Surface(324) = {224};
Plane Surface(325) = {225};
Plane Surface(326) = {226};

Surface Loop(421) = {321, -322, -323, -324, -325, -326};

Volume(521) = {421};

//============================================================================================//
//== the wax layer at the Y = 96" end of the slab                                             //
//============================================================================================//

Point(41)  = { 0.000 * inch, 96.000 * inch,  0.000 * inch};
Point(42)  = { 0.000 * inch, 96.010 * inch,  0.000 * inch};
Point(43)  = {18.000 * inch, 96.010 * inch,  0.000 * inch};
Point(44)  = {18.000 * inch, 96.000 * inch,  0.000 * inch};
Point(45)  = { 0.000 * inch, 96.000 * inch,  6.000 * inch};
Point(46)  = { 0.000 * inch, 96.010 * inch,  6.000 * inch};
Point(47)  = {18.000 * inch, 96.010 * inch,  6.000 * inch};
Point(48)  = {18.000 * inch, 96.000 * inch,  6.000 * inch};

Line(141) = { 41, 42};
Line(142) = { 42, 43};
Line(143) = { 43, 44};
Line(144) = { 44, 41};
Line(145) = { 45, 46};
Line(146) = { 46, 47};
Line(147) = { 47, 48};
Line(148) = { 48, 45};
Line(149) = { 41, 45};
Line(150) = { 42, 46};
Line(151) = { 43, 47};
Line(152) = { 44, 48};

Line Loop(241) = { 141, 142, 143, 144};
Line Loop(242) = { 145, 146, 147, 148};
Line Loop(243) = { 141, 150, -145, -149};
Line Loop(244) = { 142, 151, -146, -150};
Line Loop(245) = { 143, 152, -147, -151};
Line Loop(246) = { 144, 149, -148, -152};

Plane Surface(341) = {241};
Plane Surface(342) = {242};
Plane Surface(343) = {243};
Plane Surface(344) = {244};
Plane Surface(345) = {245};
Plane Surface(346) = {246};

Surface Loop(441) = {341, -342, -343, -344, -345, -346};

Volume(541) = {441};

//============================================================================================//
//  The physical surface is the outer surface exposed to air, so it includes all of the       //
//  surfaces except the two pairs of wood/wax surfaces in contact with each other.            //
//============================================================================================//

Physical Surface(2000) = { 301, -302, -303, -305        // slab
                         , 321, -322, -323, -325, -326  // wax layer @ Y = 0"
                         , 341, -342, -343, -344, -345  // wax layer @ Y = 96"
                         };

//============================================================================================//
//  We need to separate the volume into two parts, since the diffusion characteristics are    //
//  are different for wax vs. wood. The first physical volume represents the wood slab.       //
//============================================================================================//

Physical Volume(3000) = {501};

//============================================================================================//
//  The second physical volume represents the wax layers.                                     //
//============================================================================================//

Physical Volume(3100) = {521, 541};

//============================================================================================//
//  Because moisture gradients are very steep at the exposed surfaces when the simulation     //
//  begins, we set up a boundary layer with a smaller mesh size to minimize the error terms.  //
//  In principle, GetDP supports boundary faces as well as edges, but that doesn't seem to    //
//  work, so we add a few extra edges on the broad faces of the slab to ensure that the mesh  //
//  doesn't get too large there.                                                              //
//============================================================================================//

Field[1] = BoundaryLayer;
Field[1].EdgesList = { 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112  // real edges
                     , 191, 192, 193, 194  // extra edges
                     };
Field[1].hwall_n = 0.25 * inch;  // mesh size near the boundary is 1/4"
Field[1].hwall_t = 0.25 * inch;
Field[1].hfar = 1.0 * inch;      // mesh size away from the boundary is 1"
Field[1].ratio = 1.1;

Background Field = 1;

Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.Optimize = 1;

