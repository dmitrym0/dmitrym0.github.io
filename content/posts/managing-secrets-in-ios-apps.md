+++
title = "Managing  secrets in open source iOS apps"
author = ["Dmitry Markushevich"]
date = 2020-01-23
lastmod = 2023-05-22T12:33:09-07:00
tags = ["Development", "OpenSource", "iOS"]
draft = false
+++

One of the issues that open source authors have to deal with is secrets management. The small utility app I'm working on relies on Dropbox API. Before you can work with Dropbox API though, you have to generate an API key.
The API key identifies the application to Dropbox and needs to remain mostly secret. A bad actor could impersonate the application author by stealing the API key.

This is a long winded way of saying that API keys must be kept out of public repositories. How can this be achieved?

Turns out it's fairly straightforward. Xcode supports configuration schemes, via `xcconfig` files.

The process is straightforward.

1.  Create a new configuration settings file (via File &gt; New File, use the filter box)
2.  Add the settings to file the (the format is `key = value`)
3.  Specify the configuration in project target
4.  Configure the `Info.plist` file (see below)
5.  Use in code.


## Config file and settings {#config-file-and-settings}



{{< figure src="/ox-hugo/screenshot_2020-01-24_11-48-51.png" >}}


## Contents of the config file {#contents-of-the-config-file}



{{< figure src="/ox-hugo/screenshot_2020-01-24_11-54-09.png" >}}


## Info.plist {#info-dot-plist}



{{< figure src="/ox-hugo/screenshot_2020-01-24_11-55-34.png" >}}

qq\*\*\*\* Using the variables in code



`Info.plist` values are going to be set at compile time.  To retrieve them something like this can be used:

`let dropBoxApiKey = Bundle.main.object(forInfoDictionaryKey:"DROPBOX_API_KEY")`


## References {#references}



There's some additional info in the following posts:

-   [Managing secrets within an iOS app | Lord Codes](https://www.lordcodes.com/posts/managing-secrets-within-an-ios-app?utm_source=medium&utm_medium=article&utm_campaign=ios_app_development)
-   [Keeping secrets out of Git in iOS](https://medium.com/ios-os-x-development/keeping-secrets-out-of-git-in-your-ios-app-c01a357e824b)
-   [Using Xcode Configuration (.xcconfig) to Manage Different Build Settings](https://www.appcoda.com/xcconfig-guide/)


## PS: Removing sensitive data from git history {#ps-removing-sensitive-data-from-git-history}



I would be remiss if I didn't include instructions [on how to remove sensitive data from you repository's history](https://medium.com/bam-tech/remove-sensitive-information-from-your-git-repository-10cb421f1b84).
