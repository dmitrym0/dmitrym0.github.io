+++
title = "RAID5: Recovering from 2-drive failure during rebuild"
author = ["Dmitry Markushevich"]
date = 2015-07-13T00:00:00-07:00
lastmod = 2023-05-22T12:33:08-07:00
tags = ["Linux"]
draft = false
+++

RAID is amazing technology. It lets us take a bunch of cheap disks an arrange them in various configurations that present these disks as one large disk. A particularly popular type of RAID for home users is RAID5. A RAID5 array is typically comprised of 3 disks, however only 2/3 of the disk space is available since 1/3 of the space is used for recovery purposes if one of the disks fail. This is in fact the configuration I’ve arranged my home RAIDi in. I have a RAID5 that consists of 3 disks, 2TB each. The usable space is 4TB with the remaining 2TB used for redundancy (parity).

By design, RAID5 can easily handle a single drive failure but it turns out that single drive failure frequently leads to second drive failure which is not something that RAID5 can handle. Let me explain.

With a single drive failure, you simply purchase a new disk with similar physical characteristics and replace it in the array. When the RAID management system detects a new disk, it attempts to rebuild the array using the redundant data available on the rest of the array. This process touches every piece of data on the existing drives and sometimes causes a second drive failure. The common wisdom is that with the second drive gone it is no longer possible to rebuild the array. However depending on the actual failure type this is not necessarily so. I know because I recently went through this exact scenario.

One of my drives started throwing S.M.A.R.T. errors a few months back so I decided to replace it before it failed catastrophically. I inspected the other two drives in the array and they showed no errors. I replaced the malfunctioning disk, initiated array rebuild, and went to sleep with the rebuild process progressing nicely. In the morning, I saw that the rebuild has failed with linux kernel reporting hardware errors trying to access an existing drive in the array.

At this point in time my RAID5 looked like this:

-   Disk 1: Healthy (from original array)
-   Disk 2: Hardware failure #2 (from original array)
-   Disk 3: Blank (new disk to replace hardware failure #1)

At this point I despaired and gave up on the whole affair. I knew I had backups for the most important data (family pictures) I really didn’t save anything other than that: school projects, music. While it wasn’t catastrophic, the idea of trying to recover all of this data manually was too heartbreaking so I wanted to give my RAID one more chance. I started googling.

Turns out that hard drive failures may be localized and a wonderful tool called [ddrescue](http://www.gnu.org/software/ddrescue) may be the way out. During the rebuild RAID software reads the data from the drive sequentially and aborts when it encounters an error. `ddrescue` attempts to avoid the damaged sectors by reading the data forwards and backwards. So, I purchased another empty disk and managed to copy the data off the damaged disk. At the end of the process `ddrescue` reported that it failed to copy 140kBytes or so, which everything considered is not so bad. I added the drives back to the array and it worked! The rebuild went smoothly and now I’m back to a functioning 3 disk RAID5 array. Even though 140kB are technically gone, I haven’t been able to identify what’s missing. Some sort of checksumming would be great for next time.

So, it is possible to recover from two disk failure on Linux software RAID5 depending on the actual failure condition. In the future, I’ll be more proactive in replacing drives. Additionally it makes sense to increase the number of drives in the array to increase fault tollerance. Finally, it would be nice to have some automated monitoring, perhaps with monit and pushbullet.
