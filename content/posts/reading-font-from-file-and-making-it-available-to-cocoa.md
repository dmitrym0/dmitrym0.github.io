+++
title = "Reading a font from file an making it available to Cocoa"
author = ["Dmitry Markushevich"]
date = 2009-02-06T00:00:00-08:00
lastmod = 2023-05-22T12:33:08-07:00
tags = ["Cocoa", "MacOS"]
draft = false
+++

This is another programming related post.

Say you have a true type font that's not part of the OS font set in a file. You've read the contents of the file into memory and now want to make it available to Cocoa. How?

Turns out that ATSUI comes to the rescue:

```C++

ATSFontContainerRef container;
OSStatus status = ATSFontActivateFromMemory((LogicalAddress)[fontData bytes],           // buffer with font data
            [fontData length],          // size of font data
            kATSFontContextLocal,       // for use only in this application
            kATSFontFormatUnspecified,  // reserved
            NULL,                       // reserved
            kATSOptionFlagsDefault,     // reserved
            &container);                // on output, will contain the activated font
// find the number of font references in the container (goes to numItems)
ItemCount numItems;
status = ATSFontFindFromContainer(container, kATSOptionFlagsDefault, 0, NULL, &numItems);
NSLog(@"There are %d references in the container\n", numItems);
// load the individual fonts
ATSFontRef *ioArray = malloc(numItems * sizeof(ATSFontRef));
status = ATSFontFindFromContainer(container, kATSOptionFlagsDefault, numItems, ioArray, &numItems);
CFStringRef fontName = nil;
ATSFontGetName (ioArray[fontIndex], kATSOptionFlagsDefault, &fontName);
NSFont* myFont = [NSFont fontWithName:(NSString*)fontName size:24];
```

`myFont` now contains the NSFont reference to your font. Easy.
