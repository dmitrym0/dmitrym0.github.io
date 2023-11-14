+++
title = "Omnifocus style reviews with org-mode"
author = ["Dmitry Markushevich"]
date = 2020-01-07T00:00:00-08:00
lastmod = 2023-05-22T12:33:08-07:00
tags = ["Emacs", "orgmode"]
draft = false
+++

I started using Emacs and org-mode in earnest in the middle of 2019. At that point in time I was using Omnifocus to track my tasks and Bearapp for notes. I was missing
plaintext functionality. Since then I've reproduced most of the functionality that Omnifocus offerred except one particular feature: reviews.

In GTD, reviews occupy a pretty important niche. Without regular task and project reviews task lists tend to grow out of control and become polutted. One important consideration for a
task list is for it to closely resemble the actual state of what you have to do.

I went looking for a way to do automated reviews in org, and found [org-review](https://github.com/brabalan/org-review).

org-review relies on the `LAST_REVIEW` property to determine when the next review (`NEXT_REVIEW`) should happen and out of the box this property is not generated.

I wrote a bit of elisp to auto generate these properties for all `TODO` entries when a file is saved. This guarantees that the entry will bubble up for review a month after creation. Month is a default review duration
that can be configured via `REVIEW_DELAY` property.

Add this somewhere in `~/.emacs` or similar.

```elisp
(defun my/org-add-next-review-property ()
  "Add NEXT_REVIEW property to headlines that don't have one"
  (interactive)
  (org-map-entries '(unless (org-entry-get nil "NEXT_REVIEW") (org-review-insert-last-review)) "TODO=\"TODO\"")
)


(add-hook 'org-mode-hook
  (lambda ()
  (add-hook 'before-save-hook 'my/org-add-next-review-property 'local)))
```

The process will look something like this:

1.  Add a `TODO` task to inbox
2.  Once a file is saved the `*_REVIEW` properties are generated.
3.  ... some time passess ...
4.  Hit `C-c a R` to start the review mode.
5.  Hit `C-c C-r` to review selected items.
