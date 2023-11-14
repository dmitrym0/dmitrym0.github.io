+++
title = "ncdu - ncurses disk usage"
author = ["Dmitry Markushevich"]
date = 2016-12-07
lastmod = 2023-05-22T12:33:09-07:00
tags = ["Linux"]
draft = false
+++

{{< figure src="/ox-hugo/screenshot_2019-07-12_11-15-18.png" >}}

At some point harddrive space was cheap, but with the advent of SSDs and cheap “Cloud VMs” that is no longer the case. For example, the cheapest VM on VULTR is $5/month and has a 15 gig SSD drive. It's suddenly very important to maximize drive usage again. This is where [ncdu](<https://dev.yorhel.nl/ncdu>) comes in. It displays a nice ncurses interface that visualizes the usage breakdown.

So useful key bindings:

-   \`?\` - help
-   \`g\` - to switch display modes
-   \`d\` - to kill a subdirectory tree

There's a commercial app for Mac that I use and love (because my Mac only has a 256 SSD) called [DaisyDisk](<https://daisydiskapp.com/>).
