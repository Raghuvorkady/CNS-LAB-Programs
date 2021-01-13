### Reference:

For downloading the package ns-allinone-2.35, use [this](https://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.35/) link.

For installing the package, refer to [this](https://youtu.be/qt9NkCi9ZRI) video.

Try to run the .TCL file, and if it doesn't work out for you; run the following commands

```
sudo apt-get update -y
sudo apt-get install -y libperl4-corelibs-perl
```

After successful execution of the above steps, try to run the program by,
```
ns program_name.tcl
```

Note:
- You will need to edit 'raghavendrakm' in the following lines(line 79, 80) with your system username, in the file p5.tcl and p6.tcl:
```
set GETRC "/home/raghavendrakm/ns-allinone-2.35/ns-2.35/bin/getrc"
set RAW2XG "/home/raghavendrakm/ns-allinone-2.35/ns-2.35/bin/raw2xg"
```
