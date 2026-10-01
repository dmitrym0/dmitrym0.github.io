+++
title = "Build all the software"
author = ["Dmitry Markushevich"]
date = 2026-10-01
lastmod = 2026-10-01T12:44:39-07:00
tags = ["development", "opensource", "xterra"]
draft = false
+++

In the past 6 months I've built tons of personal software. This software is something that I wanted to build and the LLMs enabled me to, quickly and cheaply. Before I dive in, by the way of a disclaimer: this post was fully written by me and therefore all the load bearing assumptions are mine.

In this post:

-   desk control: lowering and raising my standing desk from my computer
-   xterra dashboard: a touch screen to display information my old car cannot
-   [shepherd](https://github.com/dmitrym0/shepherd): a way to wrangle multiple LLM agents


## Desk Control {#desk-control}

I'll start with my standing desk integration because it highlights an interesting LLM failure mode.

I wanted two things:

-   activate my desk going up and down from my computer
-   track how much I actually stand and sit

This desk has a bluetooth interface, so naturally someone reverse engineered the protocol, and there's a [linak-controller](https://github.com/rhyst/linak-controller) python library that exposes most of the functionality.

So claude created a wrapper for me. I can now invoke [Raycast](https://www.raycast.com/) and lower/raise the desk without touching the controller:

{{< figure src="/ox-hugo/2026-10-01_08-53-09_screenshot.png" >}}

Furthermore, I have a persistent process running in the background that monitors how much time I spent sitting/standing/on the floor:

{{< figure src="/ox-hugo/2026-10-01_08-54-22_screenshot.png" >}}

It's a [swiftbar](https://swiftbar.app/) plugin that queries the desk height and displays it in my menu bar. Today, I've only been sitting, I should stand up.

Now the failure mode. Every once in a while, the desk controller stops responding. I've added plenty of debug logging to the daemon to capture what's going on. Yet Claude still cannot figure it out. The wrapper itself is 500+ lines of code.

I've tried multiple times to "vibe-fix" it with no success so far. I await a more sophisticated model that can troubleshoot a 500 line script.

You can see what my full screen with the swiftbar controls looks below:

{{< figure src="/ox-hugo/2026-10-01_10-51-11_screenshot.png" >}}


## xterra dashboard/obd2 scanning {#xterra-dashboard-obd2-scanning}

My [Nissan Xterra](https://en.wikipedia.org/wiki/Nissan_Xterra) was built in 2010 and while that's not that old, it's missing a number of handy features available in newer vehicles.

When offroading, it's really handy to know how far the vehicle is leaned over. This helps to make sure you don't accidentally roll your vehicle. Newer vehicles typically include this by default but my xterra is too old.

What I decided instead was to use an integrated eps32/lcd prototyping widget to build my own:

<iframe width="560" height="315" src="https://www.youtube.com/embed/M9A5KV2Q4B8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The next step was to fetch tire pressure from the onboard computer. It does poll the tire pressure sensors but this information is not displayed anywhere. Only critically low pressure illuminates a dash light. I wanted to see the actual tire pressures so I can adust them while off-roading.

This was a much more complicated endeavour. Nissan does not publish this information so with the help of Claude I built tool that sniffs CANBus traffic and managed to identify the data that the BCM recieves from the TPMS subsystem  that carries pressure data.

{{< figure src="/ox-hugo/2026-10-01_11-18-55_screenshot.png" >}}

At this point in time, I manage to shortout the obd2 connector, and spent a couple of hours looking for the correct fuse to replace.

{{< figure src="/ox-hugo/2026-10-01_11-21-30_screenshot.png" >}}

The bottom line here is that claude enabled me to build a fully functional dashboard on an esp32 in C++, a platform that I'm not familiar in a language that I haven't used in over a decade.


## shepherd {#shepherd}

I'm typically working on multiple projects simulteneously. I prefer using claude code, or open code in the terminal. After about a couple of iTerm tabs, it becomes nearly impossible to manage the complexity.

My solution was to extract tracking and monitoring subsystem from [herdr](https://herdr.dev/).

My workflow is very simple. Run claude code or opencode via shepherd. Shepherd now manages the running instances of claude code. I poll shepherd to see if claude code needs my attention and raise a red flag.

{{< figure src="/ox-hugo/2026-10-01_11-46-42_screenshot.png" >}}

In the screenshot above, you can see nearly a dozen agents running. Most of them are idle, except the last one that needs my attention.

I can either use the swiftbar shortcut to navigate to the appropriate agent tab, or use the raycast integration if I dont want to use the mouse.

The credit here is to the herdr team that did all the heavy lifting.

Shepherd itself is open source as well, find it it on github: [spepherd on github](https://github.com/dmitrym0/shepherd).
