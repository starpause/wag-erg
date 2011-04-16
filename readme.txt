Readme for WagErg

Developer Notes

local.properties
----------------
Copy the example-local.properties file and rename it local.properties.
This properties file contains all the settings you need for your local development
environment, such as locations of SDKs and code-signing certs. Edit it as per the
the brief instructions given in the file. You do not need to set properties for
target platforms you are not going to build.

Fonts do not display
--------------------
There is currently a problem with the Air font manager which causes fonts to not display.
The result is that the buttons do not have labels.
Starpause has opened a bug with Adobe.
The work around suggested by Adobe is to use only the AFEFontManager.
In the air-config.xml file in your Flex/Air SDK frameworks folder, locate the
<managers> section. Comment out the other font managers.

You may also need to do this is the air-config.xml file located in the
BB PlayBook SDK.

