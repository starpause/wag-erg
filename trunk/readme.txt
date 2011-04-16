Readme for WagErg

Developer Notes

Fonts do not display

There is currently a problem with the Air font manager which causes fonts to not display.
The result is that the buttons do not have labels.
Starpause has opened a bug with Adobe.
The work around suggested by Adobe is to use only the AFEFontManager.
In the air-config.xml file in your Flex/Air SDK frameworks folder, locate the
<managers> section. Comment out the other font managers.

You may also need to do this is the air-config.xml file located in the
BB PlayBook SDK.

