+++
title = "Safari App Extensions; migrating from .safariextz"
author = ["Dmitry Markushevich"]
date = 2018-10-08
lastmod = 2023-05-22T12:33:09-07:00
tags = ["Development", "MacOS"]
draft = false
+++

I’ve dabbled with a Safari extension for a project on and off for a while. For Safari 12, I read that .safariextz-style extensions are no longer supported. I went forth to investigate what changed and how I could port my old extension to Safari 12.

The short story is that the packaging has changed, but the bulk of the existing extension should just work once new conventions are adopted. I imagine the new changes are spurred by Apple’s desire to unify distribution — new extensions are wrapped as a mac application, require a signature and are distributed through the Mac App Store.

I went looking for documentation and stumbled upon the [Extending your App with Safari App Extensions - WWDC 2016 - Videos - Apple Developer](<https://developer.apple.com/videos/play/wwdc2016/214/>) presentation which laid everything out.

There are three major parts:

-   Content blocking
-   Modifying page behaviour
-   Extending Safari UI

The video starts out describing how to develop the new Safari App Extensions. You need Xcode and dev certificate. The new thing here is that Safari App Extensions are distributed as part of a macOS application and therefore can invoke native code from that application. Neat.

The presenters then go into some specific examples of functionality that Safari App Extensions can have.

They mention that **content blocking** is built upon a model at compile time (?) so there’s no run time evaluation. This is to achieve required speed. The content blocking  API is consistent across macOS and iOS. One interesting tidbit is that  the content blockers don’t get access to individual requests, only the “content blocking” model does. This is for privacy reasons.

The second part was about **Modifying page behavior**, really the part I was looking for.  The important info here is that CSS/JS from your old extensions simply transition to the new app. These assets need to be described in the app’s Info.plist, for example for JS you’d use \`SFSafariContentScript\`[0]. There’s a new messaging API for the JS to talk to the native code.

Final, third demo was related to **Extending Safari UI**. Safari App Extension can extend Safari’s UI via popovers that house \`NSView\`s. It sounded like it’d be relatively easy to extend your app’s existing NSViews to show up in Safari. Not something I’m interested, but nevertheless cool.

I went searching for more WWDC notes, and haven’t found much[1]. It’s an excellent resource.

Looks like converting to the new format isn’t so bad. Plus Apple has an [official conversion how to](<https://developer.apple.com/documentation/safariservices/safari_app_extensions/converting_a_legacy_safari_extension_to_a_safari_app_extension>).

[0]: More keys in the Info.plist in the [official documentation](<https://developer.apple.com/documentation/safariservices/safari_app_extensions/safari_app_extension_info_property_list_keys/about_safari_app_extension_default_keys>).

[1]: I did find this though:[WWDC 2018 Notes — Procrastinative Ninja](<https://procrastinative.ninja/2018/07/02/wwdc-2018-notes/>).
