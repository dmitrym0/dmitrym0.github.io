+++
title = "What do LLMs know vs what they understand"
author = ["Dmitry Markushevich"]
date = 2026-03-28
lastmod = 2026-10-01T13:02:40-07:00
tags = ["projects", "AI", "programming"]
draft = false
+++

I’ve been working on my iOS app which I meant to build for a while. Of course I used Claude code.
It is interesting to explore the limits of LLMs. I definitely hit it (the limit) this time.

The app is really simple — make a network request and display the result. The problem is Claude Code doesn’t seem to know how to structure UI and networking code.

You don't want to make any IO requests on the main thread because the main thread is used to keep the UI responsive. If you do end up making a request on the main thread, you'll notice that your user interface stutters and becomes unresponsive since the execution is paused waiting for a network packet to come back. The way to avoid this particular problem is to delegate networking or any other IO to a background thread. This has been true ever since Apple introduced it's first iPhone SDK back in the 2010s. This is also true for Android development.

Yet, when I inspected Claude Code's output it was hapilly performing networking requests on the main thread. I've been out of iOS/Android development for a long time so I wanted to double check. I asked Claude; so it does know about these problems:

{{< figure src="/ox-hugo/claude-2.png" >}}

So if it knows that it's a bad idea, why is it still doing it?

The obvious answer is that the model was trained this way…

I wish I understood what that meant really. At the moment, I don’t have a good intuition about its limitations and intuition is a must for using something efficiently.

It's really tempting to just let claude code run amock and trust it, but instead we have to remain professional and disciplined. Have to perform careful code reviews and rigorously test the generated code. At some point these tools may become excellent, but they are not there yet.
