//============================================================================================//
//  This is a slightly modified version of diffusion.pro, with a time-dependent humidity      //
//  function that represents the control of humidity during a nine-day drying low-temp        //
//  (140°F) kiln-drying process.                                                              //
//============================================================================================//


//============================================================================================//
//  This is the diffusion model for water in wood, plus a very simplistic addendum for water  //
//  in wax, to account for coated ends.                                                       //
//============================================================================================//

//============================================================================================//
//  References                                                                                //
//============================================================================================//

// Siau84 : Siau JF (1984) _Transport Processes in Wood_, Springer-Verlag, Berlin.

// Simp73 : Simpson WT (1973) Predicting equilibrium moisture content of wood by mathematical
//          models, _Wood and Fiber_ 5:41.

// Wood10 : Ross RJ, ed. (2010) _Wood Handbook: Wood as an Engineering Material_, Forest
//          Products Laboratory, United States Department of Agriculture, Madison WI.

//============================================================================================//
//  Utility functions                                                                         //
//============================================================================================//

Function {

  FtoK[] = ($1 - 32) * (5 / 9) + 273.16;  // converts from °F to Kelvins
  CtoK[] = $1 + 273.16;                   // converts from °C to Kelvins

  KtoF[] = (9 / 5) * ($1 - 273.16) + 32;  // converts from Kelvins to °F

}

// The units of measurement for most of the quantities in the simulation are cgs, so lengths are
// measured in centimetres and time in seconds. We provide some conversion factors to improve
// readability.

  cm     =  1;
  inches =  2.54;
  feet   = 12    * inches;

  seconds =   1;
  minutes =  60;
  hours   =  60    * minutes;
  days    =  24    * hours;
  years   = 365.25 * days;

//============================================================================================//
//============================================================================================//
//============================================================================================//
//  In this first section, we define a variety of material parameters. In general, these      //
//  parameters may be modified (within reason) to model different simulation conditions or    //
//  wood species.                                                                             //
//                                                                                            //
//  Each adjustable parameter is preceded by a comment line that begins with the word PARAM   //
//  in all caps.                                                                              //
//============================================================================================//
//============================================================================================//
//============================================================================================//


//============================================================================================//
//  Temperature                                                                               //
//============================================================================================//

//-- PARAM -- Tsim : Simulation temperature (Kelvins) ------------------------------------------

// This is the temperature at which to run the simulation. You can use the FtoK[] or CtoK[]
// functions to convert from degrees Fahrenheit or Celsius to Kelvins, respectively, or just
// specify the Kelvin value directly.

Function {

  Tsim[] = FtoK[140];

  // Some of the formulas we use later contain parameters that are given in terms of
  // temperature in °F, so we'll go ahead and compute that now.

  Tf[] = KtoF[Tsim[]];

}

//============================================================================================//
//  Material specific gravity                                                                 //
//============================================================================================//

//-- PARAM -- Gsim : Simulation specific gravity (unitless) ------------------------------------

// This is the specific gravity (density with respect to water) of the fully dry slab material.
// It must be strictly larger than zero (air), and strictly less than 1.54 (pure
// cellulose/lignin).

  Gsim = 0.67;  // typical value for white oak

//============================================================================================//
//  Initial moisture content                                                                  //
//============================================================================================//

//-- PARAM -- Uinit : initial moisture content (percent) ---------------------------------------

// This value is used as the initial value of the moisture content throughout the volume of the
// slab. Typical fiber saturation point values are around 28-32%; the value goes down somewhat
// as temperature increases. Modeling free water transport (U > FSP) isn't handled in this
// simulation.

  Uinit = 30.0;  // nominal fiber saturation point, valid for most species

//============================================================================================//
//  Simulation timing                                                                         //
//============================================================================================//

// This is a subset of the time parameters that control the simulation; the ones not listed
// here should probably be left as-is.

//-- PARAM -- Tend : simulation end time -------------------------------------------------------

  // The simulation will run to the specified time.

  Tend        = 9 * days;

//-- PARAM -- Tstep_max : maximum time step ----------------------------------------------------

  // The time steps between intermediate solution values will be no greater than this value.

  Tstep_max   = 24.0 * hours;

//============================================================================================//
//  Relative humidity                                                                         //
//============================================================================================//

//-- PARAM -- Hsim : simulation relative humidity (fraction) -----------------------------------

// This is the relative humidity profile at which to run the simulation. The values are used to
// compute both the equilibrium moisture content in the wood and the diffusivity of water vapor
// in the lumens (cell cavities) of the wood. Note that this is given as a fraction, rather than
// as a percentage.

Function {

  Hsim[] = ($Time < 4 * days) ? 0.95 - 0.45 * $Time / (4 * days) :
           ($Time < 6 * days) ? 0.50 :
           ($Time < 7 * days) ? 0.50 + 0.15 * ($Time - 6 * days) / (1 * days) : 0.65;

}

//============================================================================================//
//  Cut planes                                                                                //
//============================================================================================//

// The cut planes aren't part of the simulation, but are used by the post-processing functions
// to prepare cross sections that Gmsh will display to us after the simulation is completed.

// They are currently set so that the cut planes are through the middle of the slab in each of
// the three coordinate directions, but you can move them around as desired.

  xCut =  0.75 * inches;
  yCut = 10.0 * inches;
  zCut =  0.75 * inches;

//********************************************************************************************//
//********************************************************************************************//
//********************************************************************************************//
//                                                                                            //
//  Do not modify anything below this line unless you really, truly know what you're doing.   //
//                                                                                            //
//********************************************************************************************//
//********************************************************************************************//
//********************************************************************************************//

//********************************************************************************************//
//                               Danger, Will Robinson! Danger!                               //
//********************************************************************************************//
//                             No user-serviceable parts inside.                              //
//********************************************************************************************//
//                              Warranty void if seal is broken.                              //
//********************************************************************************************//
//                                     Call key operator.                                     //
//********************************************************************************************//

//============================================================================================//
//  Regions                                                                                   //
//============================================================================================//

// We define the various regions of the model, so that we assign material properties on a per-
// region basis.

Group {
  Sur_WiW  = Region[{2000}];               // exposed surface
  Vol_Wood = Region[{3000}];               // wood volume
  Vol_Wax  = Region[{3100}];               // wax volume (if any)
  Vol_WiW  = Region[{Vol_Wood, Vol_Wax}];  // total volume
  Tot_WiW  = Region[{Sur_WiW, Vol_WiW}];   // everything
}

//============================================================================================//
//  Equilibrium moisture content                                                              //
//============================================================================================//

// We compute the equilibrium moisture content, as a function of relative humidity and
// temperature, using the two-hydrate Hailwood/Horrobin model, Eq. 3 in Simp73, and with
// parameter formulas given following Wood10, Eq. 4-5.

Function {

  W[]  = 330.0   + 0.452    * Tf[] + 0.00415     * Tf[] * Tf[];
  K[]  =   0.791 + 0.000463 * Tf[] - 0.000000844 * Tf[] * Tf[];
  K1[] =   6.34  + 0.000775 * Tf[] - 0.0000935   * Tf[] * Tf[];
  K2[] =   1.09  + 0.0284   * Tf[] - 0.0000904   * Tf[] * Tf[];

  Uemc[] = (1800 / W[]) * (K[] * Hsim[] / (1 - K[] * Hsim[])
         + (K1[] * K[] * Hsim[] + 2 * K1[] * K2[] * K[] * K[] * Hsim[] * Hsim[])
         / (1 + K1[] * K[] * Hsim[] + K1[] * K2[] * K[] * K[] * Hsim[] * Hsim[]));

}

//============================================================================================//
//  Sorption isotherm                                                                         //
//============================================================================================//

// In order to compute the diffusivity of water vapor through the lumens (air-filled cell
// cavities) in the wood, we need to know the inverse of the derivative of the moisture content
// (u) with respect to relative humidity (h). We will use the Bradley formula, Eq. 10 in Simp73,
// largely because we're lazy and because everything has already been worked out for us using
// that formula.

Function {

  // L1, L2 and L3 are the Bradley formula parameters (renamed from K1, K2 and K3 to avoid
  // conflict with the Hailwood/Horrobin parameters above).

  L1[] = 0.839  + 0.0000202 * Tf[] - 0.00000156 * Tf[] * Tf[];                    // Simp73 (22)
  L2[] = 3.56   + 0.00392   * Tf[] - 0.0000445  * Tf[] * Tf[];                    // Simp73 (23)
  L3[] = 0.0219 + 0.0000164 * Tf[];                                               // Simp73 (24)

  // dhdu is the derivative of relative humidity with respect to moisture content (we get this
  // by differentiating the Bradley formula; there is an extra factor of 100 because we've
  // expressed humidity as a fraction but moisture content as a percentage, and we'll need them
  // to be in the same units in the formula for Dv below).

  dhdu[] = 100 * -L2[] * Exp[Log[L1[]] * $1]
         * Log[L1[]] * Exp[-(L2[] * Exp[Log[L1[]] * $1] + L3[])];

}

//============================================================================================//
//  Basic diffusivity formulas                                                                //
//============================================================================================//

// We derive a formula for the diffusivity as a function of moisture content and temperature by
// first formulating its components, and then combining those to obtain the final diffusivity
// tensor.

Function {

  //--------------------------------------------------------------------------------------------
  //  First, define some basic constants and simulation conditions...
  //--------------------------------------------------------------------------------------------

  // gas constant (cal mol^-1 K^-1)

  R = 1.9872041;

  // gas constant (cm^3 cm-Hg mol^-1 K^-1) - don't you just love mixed units?

  RcmHg = 6236.37;

  // density of liquid water (g cm^-3)

  rho = 1.0;

  // atmospheric pressure (cm-Hg)

  P = 76;

  // saturated vapor pressure of water in air (cm-Hg)

  p0[] = 8.75E7 * Exp[-10400 / (R * Tsim[])];                                    // Siau84 (1.2)

  // specific gravity of moist cell wall (unitless), as a function of moisture content (Siau84
  // uses 1.5 as the specific gravity of pure cellulose/lignin; we modify that to 1.54 based on
  // more recent data.)

  G[] = 1.54 / (1 + 0.015 * $1);                                                // Siau84 (6.19)

  // square root of fractional lumen area for a given dry specific gravity

  a[] = Sqrt[1 - Gsim / 1.54];

  //--------------------------------------------------------------------------------------------
  //  Next, the component diffusivities...
  //--------------------------------------------------------------------------------------------

  // diffusivity of water vapor in air (cm^2 s^-1)

  Da[] = 0.220 * (76 / P) * Exp[Log[Tsim[] / 273] * 1.75];                      // Siau84 (6.15)

  // diffusivity of water vapor in cell wall (cm^2 s^-1), as a function of moisture content

  Dv[] = 18 * Da[] * p0[] * dhdu[$1] / (G[$1] * rho * RcmHg * Tsim[]);          // Siau84 (6.18)

  // transverse bound water diffusivity (cm^2 s^-1), as a function of moisture content

  // This is the diffusivity perpendicular to the fiber axis, through the cell wall "stuff"
  // (cellulose, hemicellulose, pectin and lignin), as a function of moisture content

  Dbt[] = 0.07 * Exp[-(9200 - 70 * $1) / (R * Tsim[])];                         // Siau84 (6.14)

  // longitudinal bound water diffusivity (cm^2 s^-1), as a function of moisture content

  // This is the diffusivity along the fiber axis, through the cell wall "stuff." It is
  // approximated as simply 2.5 times the transverse diffusivity.

  Dbl[] = 2.5 * Dbt[$1];                                                        // Siau84 (6.11)

  //--------------------------------------------------------------------------------------------
  //  Then the compound diffusivities...
  //--------------------------------------------------------------------------------------------

  // net transverse diffusivity (cm^2 s^-1), as a function of moisture content

  Dtr[] = (1 / (1 - a[] * a[])) * Dbt[$1] * Dv[$1]
        / (Dbt[$1] + Dv[$1] * (1 - a[]));                                       // Siau84 (6.22)

  // net longitudinal diffusivity (cm^2 s^-1), as a function of moisture content

  Dlo[] = 1 / ( (1 - a[] * a[])
              * (1 / (Dv[$1] * a[] * a[] + Dbl[$1] * (1 - a[] * a[]))
              + (1 - a[]) / (100 * Dbl[$1] * a[] * a[])));                      // Siau84 (6.26)

  //--------------------------------------------------------------------------------------------
  //  Finally, the overall diffusivity tensor to be used in the simulation. It is assumed that
  //  the fiber axis of the slab is aligned along the Y axis of the geometry.
  //--------------------------------------------------------------------------------------------

  Diff[Vol_Wood] = TensorDiag [ Dtr[$1], Dlo[$1], Dtr[$1] ];

  //--------------------------------------------------------------------------------------------
  //  For the wax coating (if present), we forego all of the fancy math, and just stick in a
  //  number that seems reasonable, based on the scant published data available.
  //--------------------------------------------------------------------------------------------

  Diff[Vol_Wax] = 3.0E-9;  // typical value for paraffin or carnauba wax; candelilla wax is
                           // about a factor of three smaller, beeswax is about a factor of
                           // three larger

}

//============================================================================================//
//  Constraints - This is where we specify the boundary conditions (i.e., equilibrium         //
//  moisture content at the surface) and initial conditions (i.e., initial moisture content   //
//  of the slab and wax layers).                                                              //
//                                                                                            //
//  Because we don't have sorption isotherm data for wax, we assume that the initial          //
//  moisture content of the wax is the same as in the wood. Since the wax is very thin, this  //
//  should be close enough that at most the first couple of time steps will be affected.      //
//============================================================================================//

Constraint {
  { Name Init_u;
    Case {
      { Region Vol_WiW; Type Init; Value Uinit; }  // initialize volume moisture content
    }
  }
  { Name Sta_u;
    Case {
      { Region Sur_WiW; Type Assign; Value 0.9; TimeFunction Uemc[]; }  // fix surface moisture content
    }
  }
}

//============================================================================================//
//  FEA boilerplate - This is just some basic stuff required for GetDP to understand the      //
//  kind of problem that we're trying to solve.                                               //
//============================================================================================//

Jacobian {
  { Name JVol;
    Case {
      { Region All; Jacobian Vol; }
    }
  }
  { Name JSur;
    Case {
      { Region All; Jacobian Sur; }
    }
  }
}

Integration {
  { Name I1 ;
    Case {
      { Type Gauss;
        Case {
          { GeoElement Point      ; NumberOfPoints 1; }
          { GeoElement Line       ; NumberOfPoints 3; }
          { GeoElement Triangle   ; NumberOfPoints 4; }
          { GeoElement Quadrangle ; NumberOfPoints 4; }
          { GeoElement Tetrahedron; NumberOfPoints 4; }
          { GeoElement Hexahedron ; NumberOfPoints 6; }
          { GeoElement Prism      ; NumberOfPoints 6; }
        }
      }
    }
  }
}

FunctionSpace {
  { Name Hgrad_u; Type Form0;
    BasisFunction {
      { Name sn; NameOfCoef Tn; Function BF_Node; Support Tot_WiW;
        Entity NodesOf[All]; }
    }
    Constraint {
      { NameOfCoef Tn; EntityType NodesOf ; NameOfConstraint Sta_u; }
      { NameOfCoef Tn; EntityType NodesOf ; NameOfConstraint Init_u; }
    }
  }
}

//============================================================================================//
//  Formulation - This is where we explain to GetDP what the problem looks like.              //
//============================================================================================//

Formulation {
  { Name WiW_u ; Type FemEquation;
    Quantity {
      { Name U; Type Local; NameOfSpace Hgrad_u; }
    }
    Equation {
      // This is the Laplacian part of the diffusion equation: div (D grad u).
      Galerkin { [ Diff[{U}] * Dof{d U}, {d U} ];
                 In Vol_WiW; Integration I1; Jacobian JVol;  }

      // This is the time-dependent part of the diffusion equation: du/dt.
      Galerkin { DtDof [ Dof{U}, {U} ];
                 In Vol_WiW; Integration I1; Jacobian JVol;  }
    }
  }
}

//============================================================================================//
//  Resolution - This is where we explain to GetDP how we want it to solve the problem. We    //
//  use an adaptive time loop because at the beginning, the moisture gradients are very       //
//  (infinitely counts as "very") steep, so we need a very small time step. But as soon as    //
//  the gradients start to flatten out, small time steps are just a waste of processing       //
//  power, so we allow the time steps to increase as much as possible.                        //
//============================================================================================//

Treltol     =  0.02;         // relative tolerance of the moisture content (unitless)
Tabstol     =  0.0004;       // absolute tolerance of the moisture content (percent)
Tstart      =  0;            // start time
Tstep_init  = 15 * minutes;  // initial (trial) time step
Tstep_min   =  1 * seconds;  // minimum time step

// Tend and Tstep_max are defined above, in the "user adjustable" section.

Breakpoints = {(Tstart+Tstep_max):Tend:Tstep_max};  // list of specific time points to be met
                                                    // (s); we use the max time step so that
                                                    // our final result data falls on whole
                                                    // multiples of the time step

Resolution {
  { Name LinearAdaptive;
    System {
      { Name U; NameOfFormulation WiW_u; }
    }
    Operation {
      InitSolution U; SaveSolution U;
      TimeLoopAdaptive [ Tstart, Tend, Tstep_init, Tstep_min, Tstep_max
                       , "Gear_2"
                       , List[Breakpoints]
                       , System { { U, Treltol, Tabstol, LinfNorm } }
                       ]
      {
        Generate U;
        Solve U;
      }
      {
        SaveSolution U;
      }
    }
  }
}

//============================================================================================//
//  Post-processing - This is where we tell GetDP how to prepare the solution data so that    //
//  Gmsh can display to us.                                                                   //
//============================================================================================//

PostProcessing {
  { Name WiW; NameOfFormulation WiW_u;
    Quantity {
      { Name U; Value{ Local{ [ {U} ]; In Vol_Wood; } } }
    }
  }
}

PostOperation {
    { Name cutX ; NameOfPostProcessing WiW ;
      Operation {
        Print[ U, OnCut {{ xCut, 0, 0 }{ xCut, 1, 0 }{ xCut, 0, 1 }}, File "cutX.pos" ];
      }
    }

    { Name cutY ; NameOfPostProcessing WiW ;
      Operation {
        Print[ U, OnCut {{ 0, yCut, 0 }{ 1, yCut, 0 }{ 0, yCut, 1 }}, File "cutY.pos" ];
      }
    }

    { Name cutZ ; NameOfPostProcessing WiW ;
      Operation {
        Print[ U, OnCut {{ 0, 0, zCut }{ 1, 0, zCut }{ 0, 1, zCut }}, File "cutZ.pos" ];
      }
    }
}


