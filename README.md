LAP Water
========

Moisture models for wood drying (and eventually wood movement)

### Hardware requirements

A computer having at least a four-core CPU and 2 GB of RAM is recommended. While the simulations will run on a lesser machine,
you may find that you can't use the computer for anything else while a simulation is running. And simulations typically run for
hours.

### Additional software required

You will need to download and install the Gmsh and GetDP packages available from http://www.montefiore.ulg.ac.be/~geuzaine/.
Gmsh is the mesh generator and provides a graphical user interface. GetDP is the finite element solver, and runs within Gmsh.
Both are available for Windows, Mac OS X and Linux systems.

### Quick start

1. Click the **Download ZIP** button on this page to download all of the model files from this site.
1. After installing Gmsh and GetDP, start Gmsh.
1. Select **File|Open** and open one of the <code>.pro</code> files.
1. Click on the graphical image of the model and drag the mouse to rotate it around as desired. Use the mouse wheel to zoom in
and out.
1. In the tree that's displayed on the left side of the screen, click the down-arrow next to **Post-processing** (near the
bottom), and ensure that all three options (cutX, cutY and cutZ) are selected. This will cause GetDP to compute all three cut
planes after the simulation has run.
1. Click the **Run** button. The first thing that happens is that the mesh is generated. Once that process has completed, the
mesh will be displayed graphically. (You need to zoom way in to see the individual mesh elements.)
1. As soon as the mesh has been generated, GetDP will begin execution and solve the time-dependent behavior of the model. This
will take on the order of a few hours to complete.
1. Once the simulation has completed, one of the three cut planes will be displayed, but it will be obscured by the mesh. To
hide the mesh, select **Tools|Visibility** from the menu, click the **Numeric** tab at the top of the popup window, and click
the **Hide** button next to **Element** in the list (you don't need to hide anything else).
1. You should now be able to see the solution on the displayed cut plane. Display the other two cut planes by checking their
corresponding checkboxes (all labeled **U**).
1. Use the right- and left-arrow keys to run through the time steps of the simulation. Note that the time steps at the
beginning of the run are very small, and get larger as the simulation runs.

That's the basic idea. I've only scratched the surface of what you can do with Gmsh and GetDP, but you'll have to read the
(skimpy and sometimes confusing) documentation to learn more.

### Going beyond the basics.

The <code>.geo</code> and <code>.pro</code> files are human-readable specifications of the problem to be solved. Look inside
them with an ordinary text editor (e.g., NotePad) to see what they're all about.

#### <code>.geo</code> files

The <code>.geo</code> files are geometry files. They describe the geometrical characteristics of the problem; i.e., the
shape(s) and size(s) of all of the bits and pieces that make up the model. The format of the files is extremely simplistic,
but that means that specifying something as straightforward as a cube still takes lines and lines of equations. A word of
caution: Gmsh is very forgiving of errors you make in your geometric specification. GetDP is the exact opposite, and if, for
example, one of your edges or faces has the wrong polarity, GetDP will either crash with an undecipherable error, or give you
results that have no connection to reality. Solving these kinds of problems is beyond the scope of this mini-tutorial...

#### <code>diffusion.pro</code> file

The <code>diffusion.pro</code> file contains all of the physics of the problem. Look inside to see various parameters that you
can modify to vary the simulation conditions.

If you plan to create a new problem, copy one of the <code>.geo</code> files as a starting point (call the new file
<code>myProblem.geo</code>, for example, and also create a corresponding <code>myProblem.pro</code> file. Inside that file, add
a single line that links to <code>diffusion.pro</code>. (See the existing files for examples.) Once you have those two files,
you can open <code>myProblem.pro</code> in Gmsh and run a simulation against your new problem.

## To do

I'd like to eventually get to the point where this site hosts a fully interactive system that allows you to directly import
geometry from SketchUp or other CAD program, and let the system figure out how to convert it into the format the Gmsh and GetDP
require.

I'd also like to be able to model wood movement as well, but that might take a greater investment of effort than I have time
for at the moment. We'll see...

===

This work is licensed under the <a rel="license" href="http://opensource.org/licenses/MIT">MIT License (MIT)</a>.
