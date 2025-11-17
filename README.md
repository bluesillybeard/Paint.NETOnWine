# Running Paint.NET on WINE

This is a temporary project for getting Paint.NET to work under WINE.

See the discussions on the Paint.NET forums [here](https://forums.getpaint.net/topic/134148-getting-the-latest-pdn-version-working-on-linux-wine-work-in-progress/)

This contains a set of patches to be applied to upstream WINE. These changes are experimental and are published for other developers to contribute / learn from.

## Getting Started

I highly suggest using a virtual machine to complete everything here.

Paint.NET has 32 bit and 64 bit components, so you need to do a WOW64 build. I suggest using a chroot environment for building, and a regular VM environment for installing/testing/debugging.

Clone [WINE from gitlab](https://gitlab.winehq.org/wine/wine), apply the patches here, and follow WINEs [building guide](https://gitlab.winehq.org/wine/wine)

Building wine can be an absolute hassle, but it's a mandatory step if you want to contribute to the project.

If all you want to do is use Paint.NET, I suggest waiting until this project is merged into mainline WINE as all changes here are experimental until then. Setting this up is not for the faint of heart, so you should either be prepared to spend several hours setting things up, or just wait until mainline WINE supports Paint.NET.

## Setting up

Once you have wine built and installed, you need to set up your system for running Paint.NET.

First, run `winecfg` to initialize the prefix.

Next, use winetricks to install Microsofts dotnet framework with `winetricks dotnet48` - Wine mono exists as an alternative to this, but Paint.NET does not run on wine mono. DO NOT install wine mono before or after installing microsoft dotnet, that will cause issues.

Next, source `UiAnimation.dll` from a reputable source. I personally grabbed it from an actual windows installation. The 64 bit version is found at `C:\Windows\System32\UiAnimation.dll` and the 32 bit one at `C:\Windows\SysWOW64\UiAnimation.dll`. They must be copied to their equivalent locations in the wine prefix, which is `~/.wine/drive_c` by default.

Use `winecfg` to add `uianimation.dll` to the dll overrides.

Install Arial, Segui UI, and Calibri fonts on your system. Paint.NET will actually crash in the text selection menu without these. I copied them from my windows install, but these fonts are popular enough to be found in various places.

These patches are only tested with Paint.NET v4.0 for the time being. The Internet Archive is a reputable place to source older versions of Paint.NET, but be aware that they are entirely unsupported and the goal is to get the latest version working.

## Roadmap

Part 1:
- post all known issues on the github issue tracker
- Split patches by file for easier browsing
- Fix most of the major problems with Paint.NET v4.0
- Update to the latest version of Paint.NET
- Fix all of the crashes
- Fix most of the usability problems
- submit to upstream WINE
- wait for the next release
- write a public guide for installing.using Paint.NET on Linux

Once that is completed, the next step will be eliminating the need to copy UiAnimation.dll from a windows install so Paint.NET can work out-of-the-box.

## Shoutouts

This section is to give credit to those who are not listed as contributors on Github

- Rick Brewster for creating Paint.NET to begin with
- toe_head2001 for laying the groundwork for getting this project going
- Several others on the Paint.NET forum for inspiring and motivating this project


