#!/bin/bash

# Configurable Bits
patchRepo=Paint.NETOnWine
sourceRepo=winesrc

command=$1

if test ! $command; then # command is set

command="help"

fi # command is set

if test $command == "help"; then # command

page=$2

if test ! $page; then # page is set

page=1

fi # page is set

if test $page == "setup"; then # help page

echo "the 'setup' command runs the download, applypatch, configure, and createprefix commands"
echo "Use this command to set everything up for building WINE for $patchRepo automatically"

elif test $page == "makescripts"; then # help page

echo "the 'makescripts' command creates 'wine' and 'winetricks' wrappers that automatically set the prefix"

elif test $page == "download"; then # help page

echo "the 'download' commmand downloads wine from the wine gitlab, and downloads the $patchRepo patches"

elif test $page == "applypatch"; then # help page

echo "the 'applypatch' command applies the patches from $patchRepo to the WINE source code."
echo "Note, that this will reset any changes you have made to WINE itself!"

elif test $page == "configure"; then # help page

echo "the 'configure' command configures WINEs makefile"

elif test $page == "createprefix"; then # help page

echo "the 'creapteprefix' command sets up the wine prefix for testing paint.net"

elif test $page == "make"; then # help page

echo "the 'make' command runs the makefile in order to build WINE"

elif test $page == "makepatch"; then # help page

echo "the 'makepatch' command generates the patche files based on the working changes in the WINE git folter"
echo "This actually deletes the old patches, then iterates over every file in the WINE repo and does the following: "
echo "    1. check if the file has actually changed, goes to the next file if not"
echo "    2. use 'git diff' to get a diff (aka patch) of that file compared to the most recent commit "
echo "    3. put that diff to the corresponding location in the $patchRepo git folder"
echo "After this command is run, the new patches are in the $patchRepo git folder and may be committed and/or submitted to the repository"

else # help page

echo "Usage: $0 [command] [arguments]"
echo "Commands:"
echo "    help         - prints this help message. You can use help [command] to get more info about a specific command."
echo "    guide        - prints out a full setup guide"
echo "    setup        - runs the download, makescripts, applypatch, configure, make, and createprefix commands"
echo "    makescripts  - Makes 'winetricks' and 'wine' wrapper scripts to automatically call them with the correct prefix"
echo "    download     - downloads wine and patches from git repos"
echo "    applypatch   - applies patches to wine"
echo "    configure    - configure wine build"
echo "    createprefix - configure wine prefix"
echo "    make         - runs make install in order to build wine"
echo "    makepatch    - create the patches to submit to the $patchRepo repo"
echo "For most users, simply run the 'setup' command"
echo "Also, take a look at the 'wine' and 'winetricks' scripts"

fi # help page

elif test $command == "guide"; then # command

echo ""
echo "Basic guide on setting up PDN on wine"
echo "Note: a full version of the guide is available in the github repos readme: https://github.com/bluesillybeard/Paint.NETOnWine"
echo ""
echo "The first thing you need are most of the dependencies listed on the WINE build guide page"
echo "    Link: https://gitlab.winehq.org/wine/wine/-/wikis/Building-Wine"
echo "WINEs configure script will let you know if you are missing any dependencies."
echo "You will need to install winetricks"
echo ""
echo "You will also need cabextract in order for some fonts to be extracted when setting up the prefix."
echo ""
echo "Then you can run '$0 download', '$0 makescripts', '$0 applypatch', '$0 configure', '$0 make', and '$0 createprefix' in that order."
echo "Take a look at those individual commands help texts for more info."
echo ""
echo "After editing the source code, you only need to run '$0 make' to rebuild WINE with the new source code changes."
echo "To update your local copy of the patches repo, run '$0 makepatch'."

elif test $command == "makescripts"; then # command

echo $'#!/bin/bash\nWINEPREFIX=\"$PWD/prefix" $PWD/build/install/bin/wine $@' > wine
chmod +x wine

echo $'#!/bin/bash\nWINE=\"$PWD/build/install/bin/wine\" WINEPREFIX=\"$PWD/prefix" winetricks $@' > winetricks
chmod +x winetricks

echo $'#!/bin/bash\nWINE=\"$PWD/build/install/bin/wine\" WINEPREFIX=\"$PWD/prefix" $PWD/build/install/bin/winecfg $@' > winecfg
chmod +x winecfg

elif test $command == "download"; then # command

git clone https://gitlab.winehq.org/wine/wine.git $sourceRepo
git clone https://github.com/bluesillybeard/Paint.NETOnWine.git $patchRepo

elif test $command == "applypatch"; then # command

# Clear out any working changes (this is what makes applypatch a bit dangerous!)
# There is definitely a better way to also remove untracked files
git -C $sourceRepo add .
git -C $sourceRepo checkout -f master

find $patchRepo -name "*.patch" -type f | sort | while read -r patchfile; do # loop over patch files

git apply --directory $sourceRepo $patchfile

done # loop over patch files

elif test $command == "configure"; then # command

mkdir -p ./build
cd build
../$sourceRepo/configure --enable-win64 --prefix=$PWD/install
cd ..

elif test $command == "make"; then # command

cd build
make install -j$(nproc)
cd ..

elif test $command == "createprefix"; then # command

# This does the initial prefix creation and sets it to windows 10
./winetricks win10

# Hack to fix a bug in winetricks
ln -s $PWD/prefix/drive_c/windows/regedit.exe $PWD/prefix/drive_c/windows/syswow64/

./winetricks arial calibri corefonts
./winetricks dxvk

elif test $command == "makepatch"; then # command

git -C $sourceRepo ls-files -mo | sort | while read -r srcfile; do # Loop over wine source files

mkdir -p $(dirname $patchRepo/$srcfile)
git -C $sourceRepo diff -- $srcfile > $patchRepo/$srcfile.patch
echo "Created patch for $sourceRepo/$srcfile and placed it in $patchRepo/$srcfile.patch"


done # Loop over wine source files


else # command

echo "Unknown command '$command', try '$0 help'"

fi # command
