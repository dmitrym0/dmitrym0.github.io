+++
title = "Small Dashboard"
author = ["Dmitry Markushevich"]
date = 2026-03-15
lastmod = 2026-10-01T13:02:19-07:00
tags = ["projects"]
draft = false
+++

An impulse buy on Aliexpress resulted in a cool little project. I saw this on youtube somewhere, advertised as a companion to home assistant. For $9 canadian, I couldn't pass it up.

{{< figure src="/ox-hugo/2026-03-15_18-26-46_screenshot.png" >}}

It's a 1.8" LCD display, driven by an ESP32 microcontroller. It connects to your WiFi and can display time/temperature, has a rudimentary image gallery. There are many different versions including ones that have a tap button on top; mine doesn't.

As part of it's functionality it exposes a webserver -- you can change it's settings, upload images, etc. Of course this be automated.

I pressed into service as a small dashboard, and it's been quite useful.

There are various types of information I present. Even though the display is tiny, and the resolution is 200x200 or so, having an always on dedicated display is handy.


## Meeetings {#meeetings}

It's helpful to know when my next meeting is, so I don't miss it. Since small dashboard shows the next meeting screen 80% of the time, I also show the remaining pomodoro time ("P 13:41"). The obscured part of the screen shot is the meeting title.

{{< figure src="/ox-hugo/2026-03-15_18-35-48_screenshot.png" >}}


## Health {#health}

This screen is a gentle reminder to meditate and exercise. The data is pulled in via Garmin API.

{{< figure src="/ox-hugo/2026-03-15_18-38-09_screenshot.png" >}}


## Road cameras {#road-cameras}

My final screen captures the views from various road cameras. There's no particular reason for this -- it's just interesting to keep an eye on the snowline in the winter, or watch a car travel the road at night.

{{< figure src="/ox-hugo/2026-03-15_18-40-48_screenshot.png" >}}


## On my desk {#on-my-desk}

The small tv is really tiny. I didn't realize how small it is, but it does provide surprising utility. I would like to reimplement it in something larger and more controllable in the future.

Below is the actual unit on my desk, next to the ikea temperature/clock/alarm unit.

{{< figure src="/ox-hugo/2026-03-15_18-45-21_screenshot.png" >}}
