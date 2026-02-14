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

If you have any questions, please post on the Paint.NET [forum thread](https://forums.getpaint.net/topic/134148-getting-the-latest-pdn-version-working-on-linux-wine-work-in-progress/) or in the github discussions.

## Setting up for Wine development

I highly suggest using a virtual machine to complete everything here.

Clone the Wine repository from [WineHQ GitLab](https://gitlab.winehq.org/wine/wine), apply the patches found here, and follow Wine's [building guide](https://gitlab.winehq.org/wine/wine)

Building Wine can be an absolute hassle, but it's a mandatory step if you want to contribute to the project.

If all you want to do is use Paint.NET, I suggest waiting until this project is merged into mainline Wine as all changes here are experimental until then. Setting this up is not for the faint of heart, so you should either be prepared to spend several hours setting things up, or just wait until mainline Wine supports Paint.NET.

## Setting up for running Paint.NET

Once you have Wine built and installed, you need to set up your Wine prefix for running Paint.NET.

First, run `winecfg` to initialize the prefix.

Next, use `winetricks` to install the Microsoft .NET Framework with `winetricks dotnet48` - Wine mono exists as an alternative to this, but Paint.NET does not run on wine mono. DO NOT install wine mono before or after installing Microsoft .NET Framework, that will cause issues.

Install Arial and Calibri fonts with `winetricks arial calibri`. Paint.NET will actually crash in the text selection menu without these.

These patches are only tested with Paint.NET v4.0 for the time being. The Internet Archive is a reputable place to source older versions of Paint.NET, but be aware that they are entirely unsupported, and the goal is to get the latest version working.

## Roadmap

- Post all known issues on the [issue tracker](https://github.com/bluesillybeard/Paint.NETOnWine/issues)
- Fix most of the major problems with Paint.NET v4.0
- Update to the latest version of Paint.NET
- Fix all of the crashes
- Fix most of the usability problems
- Submit to upstream Wine
- Wait for the next stable Wine release

## Shoutouts

This section is to give credit to those who are not listed as contributors on GitHub

- [Rick Brewster](https://github.com/rickbrew) for creating Paint.NET to begin with and encouraging this project
- [toe_head2001](https://github.com/toehead2001) for creating the initial patchset that was used to get this project started
- Several others on the Paint.NET forum for inspiring and motivating this project
