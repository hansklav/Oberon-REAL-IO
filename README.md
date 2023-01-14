# Oberon-REAL-IO
Improved REAL I/O procedures for Project Oberon 2013.

To do these tests you have to compile the following four modules with the ORP compiler:
  ORP.Compile Limits.Mod Reals.Mod Texts1.Mod TestRealIO.Mod ~

[ If you make changes to the original Texts.Mod you have to compile (part of) the whole Oberon System, 
   otherwise you might end up with a system that does not boot anymore. This sounds more daunting than it is.
   Just use the text Rebuild.Tool from my GitHub pages and compile the line containing Texts.Mod and then
   compile ALL THE LINES BELOW THAT LINE (middle-click each ORP.Compile). That's it!     ]
