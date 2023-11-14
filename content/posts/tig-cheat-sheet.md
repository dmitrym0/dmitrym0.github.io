+++
title = "Efficient commit workflow with tig"
author = ["Dmitry Markushevich"]
date = 2018-08-30
lastmod = 2023-05-22T12:33:08-07:00
tags = ["Development"]
draft = false
+++

One of the recommended source control practices is to [commit frequently, and often](http://stackoverflow.com/questions/107264/how-often-to-commit-changes-to-source-control).   I prefer to keep my commits terse and focused, however in practice I’m working on a couple related but independent things in parallel. At commit time, I prefer to tease loosely related things apart and commit them separately.

One way to do that is with the interactive git-add facility that can be invoked with `git add -p`:

{{< figure src="/ox-hugo/screenshot_2020-01-07_16-16-56.png" >}}

It’s a lovely little interface:

-   file name is shown at the top of the output
-   location of the change set is shown
-   the prompt is asking whether I want to stage the change (`y`),  ignore the changes this file (`d`) and various other obscure options.

This process works for the majority of my commit needs. It allows me to review every change before staging it to ensure that only necessary changes get pushed to the central repo.

My main issue with this process is that it’s too linear. When the number of changes exceeds a certain threshold I have trouble remembering what functionality I’m currently committing. I can’t easily inspect the existing staged hunks. The process becomes cumbersome.

This is where [tig](http://jonas.nitro.dk/tig/), a **text-mode interface for Git** comes in. I’m a huge fan of console tools because they are incredibly fast and **tig** is no exception.

Upon launching **tig** you’re presented with the following view:

{{< figure src="/ox-hugo/screenshot_2020-01-07_16-21-55.png" >}}

I’m currently interested in the “unstaged changes”. Hitting `enter` shows a diff between HEAD and current working directory.

But we’re interested more in the stage view that can be activated by hitting `S` (case matters!):

{{< figure src="/ox-hugo/screenshot_2020-01-07_16-23-51.png" >}}

This view should be familiar to anyone who has used `git status`.  This main view can be navigated with arrow keys. Hitting `enter` on a file name  will show a secondary window with a diff. This view can be navigated with the `j` and `k` keys (vi-like).

{{< figure src="/ox-hugo/screenshot_2020-01-07_16-19-48.png" >}}

At this point, we can select individuals lines to stage with the `1` key, or hit `u` to stage the whole file.  Individual lines can be staged when there’s some cruft you don’t want to commit - such as debugging statements.

When all changes have been staged, you can hit  `C` to commit from inside **tig**, or exit (`q`) and commit as you normally would from command line.

Here’s a small [tig cheat sheet](http://ricostacruz.com/cheatsheets/tig.html) for reference.
