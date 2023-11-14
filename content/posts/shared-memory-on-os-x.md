+++
title = "Working with shared memory on OS X"
author = ["Dmitry Markushevich"]
date = 2010-04-05
lastmod = 2023-05-22T12:33:09-07:00
tags = ["Development"]
draft = false
+++

If you're working with Qt's [QSharedMemory](https://duckduckgo.com/?q=qsharedmemory&t=osx&ia=web), on Mac OS X you're working with System V shared memory subsystem. If your data is sizable, the first limit you'll hit in the maximum segment size, which is for some reason around 4 megs. To increase it invoke this magic incantation:

```bash
sudo sysctl -w kern.sysv.shmmax=33554432
```

and to see other shared mem related kernel variables:

```bash
sysctl -A|grep shm
```

If you'd like these settings to remain after you reboot your machine follow the instruction [here](http://www.spy-hill.net/help/apple/SharedMemory.html).

The other problem you're likely to hit is that shared memory persists between processes (as it probably should) unless you detach and then destroy the QSharedMemory object. This makes testing somewhat inconvenient. You can monitor
 and remove shared segments with `ipcs` and `ipcrm` commands. The first command lists shared segments, the second deletes them.

Again, I've only verified this on Mac OS X 10.5, but it should work on other Unix-like systems that support System V IPC.
