+++
title = "Journaling prompts in Emacs"
author = ["Dmitry Markushevich"]
date = 2022-07-17
lastmod = 2023-05-22T12:33:08-07:00
tags = ["Emacs", "Misc"]
draft = false
+++

One of my daily rituals is journaling. It's been shown to have positive impact on quality of life (citation needed). I find it helps me decompress but it's also a permanent record of my thoughts and my life's minutiae.

I usually set a timer for 5 minutes and go to town. One particular challenge I have, is that some times I don't really know what to write about. Recently I came upon the idea of journaling prompts. So far, journaling prompts come in the form of questions:

> What do I know to be true that I didn’t know a year ago?
>
> What distractions get in the way of being my most productive?

In Emacs, it's trivial to automate prompt generation. I used org-mode's capture templates and here's what I came up with:

A function to grab a prompt:

```elisp
(defun dm/get-journaling-prompt ()
  "Returns a single line from journaling prompts."
  (save-window-excursion
    (find-file (concat org-roam-directory "journaling_prompts.org"))
    (goto-char (point-max))
    (let* ((number-of-prompts (- (line-number-at-pos) 10)))
      (goto-line (+ 10 (random number-of-prompts)))
      (s-chomp (thing-at-point 'line t)))))
```

and then in my capture templates:

```elisp
("dj" "Journal" entry
 (file+olp+datetree ,(concat org-directory "/personal-daily-2022.org"))
 "* Entered on %U

  Prompt: %(dm/get-journaling-prompt)

%?")
```

It's wonderfully simple, the `%(dm/get-journaling-prompt)` simply executes the expression and returns the result. As usual, more in the [docs](https://orgmode.org/manual/Template-expansion.html).

The result looks like this:

{{< figure src="/ox-hugo/2022-07-17_13-10-28_screenshot.png" >}}

It's an easy way to get journaling if nothing else comes up.
