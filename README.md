# Running Paint.NET on Wine

This is a temporary project for getting Paint.NET to work under Wine.

See the discussions on the Paint.NET forums [here](https://forums.getpaint.net/topic/134148-getting-the-latest-pdn-version-working-on-linux-wine-work-in-progress/).

This contains a set of patches to be applied to upstream Wine. These changes are experimental and are published for other developers to contribute / learn from.

## FAQ

### What's missing in Wine for Paint.NET to run on Linux?

Paint.NET heavily relies on the Direct2D API (`d2d1.dll`), which happens to be severely underdeveloped in Wine.

It also relies on the Windows Animation Manager API (`UiAnimation.dll`), another underdeveloped component in Wine.

### How long until Paint.NET can be used on xyz distro?

It's going to be a long time before any of this is remotely ready for general use. However, the goal is to eventually get Paint.NET running more or less right out of the box with a standard up-to-date Wine installation.

### Will this project support MacOS?

Wine itself does support MacOS, however we are not testing on MacOS for now. If you can test and debug on MacOS, that would be appreciated, even if it's just a confirmation that it does/doesn't work.

If you have any questions, please post on the Paint.NET [forum thread](https://forums.getpaint.net/topic/134148-getting-the-latest-pdn-version-working-on-linux-wine-work-in-progress/) in the github discussions, or on the [discord server](https://discord.gg/7Qe3frA)

## Setting up for Wine development

If all you want to do is use Paint.NET, I suggest waiting for an official release, or for these patches to be brought into upstream WINE. Setting this up is not for the faint of heart, so you should either be prepared to spend several hours setting things up, or just wait until mainline WINE supports Paint.NET.

I highly suggest using a virtual machine or chroot environment to complete everything here.

The simplest way is to use the helper script: [[link](https://github.com/bluesillybeard/Paint.NETOnWine/blob/master/pdnhelper.sh)]. It has all of the instructions, encoded directly in the form of a CLI interface that does everything* more or less automatically. The script has instructions built-in, however this readme contains a more detailed guide.

\* The helper script will not install the required dependencies automatucally, as that depends on what distro you are using - and can even be quite involved for certain dependencies.

### Setting up using the helper script

1. Download the helper script. It is in this repository since that seemed like a decent place to put it, but it is meant to be downloaded by itself. Here is a link directly to the file on the master branch: https://github.com/bluesillybeard/Paint.NETOnWine/blob/master/pdnhelper.sh.
2. Place the helper script in a reasonable location. `~/Projects/pdnonwine/` is a reasonable location. Note that it will download and create a bunch of files and folders in that location.
3. Install the required dependencies to build wine, which are listed on the page linked here: https://gitlab.winehq.org/wine/wine/-/wikis/Building-Wine
    - IMPORTANT: You do not need to install all of them, in fact quite a lot of them are not required
    - NOTE: You may skip this step if you want to repeatedly run the configure script and install the missing dependencies one at a time. The WINE configure script will error and list out the missing dependency. This is generally a bad experience though.
4. Install `cabextract`. On Debian it's available as a plain apt package: `sudo apt install cabextract`. Your favorite distro likely provides it as a standard package.
5. Install `winetricks`. Your favorite distro may or may not provide it as a package, so here is a link to its repo: https://github.com/Winetricks/winetricks
6. Install `git` if you don't already have it
7. You will also need a MINGW cross compiler. On debian this can be installed via `sudo apt install gcc-mingw-w64 g++-mingw-w64`
    - This is not listed in the building wine guide, for whatever reason

Assuming you have done everything correctly, now you may run each of the script commands in this order:
1. `./pdnhelper.sh download`
    - This will download the WINE source code as well as these patches
2. `./pdnhelper.sh makescripts`
    - This will create a handful of useful scripts. You may skip this step.
3. `./pdnhelper.sh applypatch`
    - This will use git to apply these patches to the WINE source code.
4. `./pdnhelper.sh configure`
    - This one will likely spit out a bunch of errors the first few times as you install any missing dependencies. The WINE building guide, nor this guide, lists out all of the dependencies that are required at build time. It's nothing to be scared of, just look out for when it says "missing xyz" or "could not find xyz", which will list out what needs to be installed. Each time, just install the dependency listed, then re-run this sub command.
5. `./pdnhelper.sh make`
    - This will take really quite a while to run. On my computer it takes 5 minutes. The script does a 64-bit only build, so it is still half the time of a standard build of WINE.
6. `./pdnhelper.sh createprefix`
    - This will open on a popup window, first to set up the wine prefix.
    - IMPORTANT: when WINE asks whether to install Mono, make sure to click "Cancel". Installing wine mono will cause issues if you want to run any installers or a version of Paint.NET from before they started bundling .NET into the package.

Now, WINE has been fully set up to attempt to run Paint.NET. The installers are not a priority, so I suggest downloading the portable version and putting it somewhere convenient. Note that the portable release zip uses back slashes instead of forward slashes for the file paths, which will mess up certain zip extraction software on Linux. You may have to do some manual clean-up to get the files in the right folders.

The `makescripts` sub command should have created another script called `wine` in the directory you ran it from. This is a wrapper for the version of wine that was just build, so you can simply type `./wine paintdotnet.exe` instead of `WINEPREFIX=$PWD/prefix $PWD/build/install/bin/wine paintdotnet.exe`.

### Other notes

You may want to install .NET Framework in order to run Paint.NET 4.x or the installer. If the steps above were followed correctly, you can simply run `./winetricks dotnet48` in the same folder you completed the steps. Note that if you accidentally clicked "Install" instead of "Cancel" in step 6, this will not work. In the event you did hit "Install", you can delete the `prefix` folder that the script created, and re-run `./pdnhelper.sh createprefix`.

### Setting up manually

If for some reason you don't want to use the helper script, the helper script itself is a better guide than I care to write here. So go ahead and read the source code of the script itself, which is linked here: https://github.com/bluesillybeard/Paint.NETOnWine/blob/master/pdnhelper.sh. It is only 172 or so lines of code, and half of it is just help messages for the various commands.

## Roadmap

- Post all known issues on the [issue tracker](https://github.com/bluesillybeard/Paint.NETOnWine/issues)
- Fix most of the major problems with Paint.NET v4.0
- Get Paint.NET v5.x running at all
- Fix all of the crashes
- Fix most of the usability problems
- Figure out what to do from there

## Shoutouts

This section is to give credit to those whose contributions are not present on GitHub otherwise:

- [Rick Brewster](https://github.com/rickbrew) for creating Paint.NET to begin with and encouraging this project
- [toe_head2001](https://github.com/toehead2001) for creating the initial patchset that was used to get this project started
- Several others on the Paint.NET forum for inspiring and motivating this project
