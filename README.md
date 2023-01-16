# Oberon-REAL-IO
## Improved REAL I/O procedures for Project Oberon 2013.

In 2020 I reported about unexpected wrong output of various borderline REAL values by the present versions of the [Project Oberon](http://www.projectoberon.com/) procedures Texts.WriteReal and Texts.WriteRealFix. 
See: https://lists.inf.ethz.ch/pipermail/oberon/2020/015007.html 

Most of those who replied to my post agreed with me that this behaviour is not as it should be and deserves improvement.

Recently I tried and made improvements to these procedures, which you can find in this repository.
See my post in the Oberon Mailing List (https://lists.inf.ethz.ch/pipermail/oberon/2023/016546.html).

To do the tests in TestRealIO.Mod you have to compile the following four modules with the ORP compiler:
```
  ORP.Compile Limits.Mod Reals.Mod Texts1.Mod TestRealIO.Mod ~
```
If you make changes to the original Texts.Mod you have to compile (part of) the whole Oberon System, 
otherwise you might end up with a system that does not boot anymore. This sounds more daunting than it is.
Just use the text Rebuild.Tool and compile the line containing Texts.Mod and then
compile ALL THE LINES BELOW THAT LINE (in a strict downward order middle-click each ORP.Compile). That's it!

```
[ Rebuild.Tool ]

Rebuild the whole Oberon System (including the compiler):
-------------------------------------------------------
ORP.Compile  Kernel.Mod/s  FileDir.Mod/s  Files.Mod/s  Modules.Mod/s ~
ORL.Link Modules ~
ORL.Load Modules.bin ~

ORP.Compile Input.Mod/s  Display.Mod/s  Viewers.Mod/s ~
ORP.Compile Fonts.Mod/s  Texts.Mod/s ~
ORP.Compile Oberon.Mod/s ~
ORP.Compile MenuViewers.Mod/s ~
ORP.Compile TextFrames.Mod/s ~
ORP.Compile System.Mod/s ~
ORP.Compile Edit.Mod/s ~
ORP.Compile ORS.Mod/s  ORB.Mod/s ~
ORP.Compile ORG.Mod/s  ORP.Mod/s ~

Then restart the system.
```

