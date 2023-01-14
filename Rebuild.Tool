Rebuild the whole Oberon system (including the compiler):
--------------------------------------------------------
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

Then restart the system:
(macOS:) cmd-Q, then in Terminal:
./risc --fullscreen DiskImage/Oberon-2020-08-18.dsk
