# DemoIconPalette
Swift popup icon menu demonstration using FontAwesome

Developed on xcode 8.3.1
Deployment target is iOS 10.3

This example single-page application is a design study of having an icon palette appear near where the user taps on the screen. Here's a screenshot:
![Alt text](./DemoScreenShot.png?raw=true "Screenshot png")
In order to run the demonstration app successfully. You may need to install the font file 'FontAwesome.ttf'. An excellent reference is http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/.

### Modifying the buttons
The icons on the button palette are implemented in code in the file ButtonPaletteController.swift. ButtonDialog.swift is written in a general fashion so creating different palettes is possible with minimal effort.

### Disclaimer
Prefer Apple's Human Interface Guidelines in every case. This demo is written in the spirit of wordless instructions for internationization. Please consider your options careful before using this somewhere you shouldn't.

### Enhancements
The next natural step would be to configure the icons in JSON and/or XML and have the callback stubs auto-generated. Also, no testing was done to try out varying the opacity of a palette.

