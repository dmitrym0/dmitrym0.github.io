+++
title = "AI from the trenches"
author = ["Dmitry Markushevich"]
date = 2025-09-30
lastmod = 2026-10-01T13:00:50-07:00
tags = ["opensource", "AI"]
draft = false
+++

I want to share some of my thoughts and experiences with the AI revolution. Although the argument about the nature of the LLMs is ongoing ([stochastic parrots](https://en.wikipedia.org/wiki/Stochastic_parrot) or not?) I'm somewhat reluctant to use the "AI" label. When I think AI, I think, higher level features, like perhaps Data from Star Trek. An elevated mind if you will. I'm with folks calling LLMs "fancy auto-completes". Some of the failure modes I see don't scream "intelligence" to me, but I'm not very firm on that. After all [Eliza](https://en.wikipedia.org/wiki/ELIZA) was very believable, had fairly high [Turing test scores](https://en.wikipedia.org/wiki/Turing_test), but was at it's core extremely simple and certainly not intelligent. I've been using Chatbots fairly extensively in my work, but I can't share any of the specifics of course. I've also been using chatbots to improve my open source project, [org-hyperscheduler](https://github.com/dmitrym0/org-hyperscheduler). Since it's open source I can share a couple of interesting tidbits without exposing proprietary information.

[org-hyperschedule](https://github.com/dmitrym0/org-hyperscheduler) is an Emacs package for displaying calendar data. You can think of Emacs as being the server, with the calendar being rendered in the browser. The data comes in via web-sockets. I originally wrote a pretty basic, ugly implementation of the front end in plain JavaScript. I wanted to use Claude/ChatGPT to "vibe-code" a new, good looking front end and add some improvements to the server side (Emacs).

This is a somewhat ideal scenario because there's relatively little code. The "server" is about 300 lines of Lisp code, so is the single page application. The heavy lifting is done by Emacs and the [tui-calendar](https://ui.toast.com/tui-calendar) JavaScript component.


## The Good {#the-good}


### Svelte {#svelte}

I initially wanted to create the new front end in React, but decided to go with something simpler, [Svelte](https://svelte.dev). My prompt was not very sophisticated. It asked for the plain JS front end to be converted to a Svelte project with the original functionality preserved. I also asked it to make it "look pleasant". Within about 30 seconds, I had a decent looking Svelte based SPA that functioned well, with zero involvement from me.

{{< figure src="~/Downloads/org-hyperscheduler-v2.png" width="75%" >}}


### ELisp - Elegant Lisp {#elisp-elegant-lisp}

One of the new features I wanted, was to be able to classify calendar events based on event attributes. This is a feature that assigns colour and category to visually separate events in the calendar. This was the extent of my prompt, but I was surprised with the results:

```elisp

(defcustom org-hyperscheduler-calendar-categories
  '(
    (work
     :name "Work Calendar"
     :color "#000000"
     :bg-color "#FFFF6e"
     :border-color "#FFFF6e"
     :read-only t
     :matcher (lambda (item) (string= (cdr (assoc "CALENDAR-ID" item))
                                      "dmitr@work.com")))
    (done
     :name "Done Items"
     :color "#000000"
     :bg-color "#C0C0C0"
     :border-color "#C0C0C0"
     :read-only t
     :matcher (lambda (item) (string= (cdr (assoc "TODO" item)) "DONE"))))
```

The revelation to me here, was the inclusion of the `matcher` lambda. I did not have a specific implementation in mind when I requested this, but the result was certainly more elegant than anticipated. I've seen similar implementations prior but I'm not sure I would've been able to come up with this on my own.

Briefly, when org-hyperscheduler iterates over events it runs each category's matcher lambda over each event until the matcher returns `true`. That signifies that the event has been categorized and no further processing is necessary. This is both flexible, clear and concise -- hallmarks of good code in my opinion.


## The Bad {#the-bad}


### Caching {#caching}

This is an example of poor prompting, but also why it's hard to call LLMs "intelligent". Getting all of the calendar data is a relatively expensive operation, so I wanted the agenda to be cached in browser's session storage. There was a naive implementation in the old front end already. I asked Claude to improve caching using Svelte's modules. Claude (Sonnet 4 at the time) pulled in SvelteKit, which is a server side framework, implemented as a proxy in front of Emacs. I'd argue here, that this is less than intelligent because introducing <span class="underline">another</span> server as part of this project makes zero sense in any context. I ended up rolling it back.


### Infinite Loops {#infinite-loops}

Up till now, I've never managed to completely hang Safari, so this was a new and interesting one for me. One feature I really wanted to add was incremental updates. Rather than having to send the full agenda on every update, I wanted to send individual changes. This clashed with the existing code causing an infinite loop that caused Safari to be completely inoperable, requiring a `kill -9`. I did manage to fix this with careful prompting. I described the symptoms and the potential cause of the issue and Claude successfully diagnosed it.


## Developer Experience {#developer-experience}

I have used LLMs in a number of ways; via the chatbot interface directly and using specialty tools.

Copying and pasting code into ChatGPT works fine, but it doesn't scale very far. It's decent for one off tiny shell scripts for instance. This is something I outgrew quite quickly.

Of the specialty tools I have used [Cursor](https://cursor.com), [Aider](https://aider.chat) and [Claude Code](https://www.claude.com/product/claude-code).

Cursor is a modified VSCode distribution with some secret sauce sprinkled in. It's a good introduction to coding assistants and is generally quite pleasant. I have largely left it behind, primarily for the same reasons I left the original VSCode et al, in favor of Emacs. I prefer a more streamlined, keyboard driven experience.

Claude Code and Aider are my daily drivers. The main difference between the two and Cursor is that Claude Code and Aider live in the terminal. Aider in particular can integrate with most any LLM back-ends via [LiteLLM](https://www.litellm.ai). Both of these tools run in the console and adopt a command line based approach. The biggest difference between the two is that Claude Code is happy to burn through large number of tokens to satisfy user's requests while Aider tries to be frugal. What this means in practice, is that you have to be more explicit with the scope of changes when working with Aider. Claude Code will run with what it has and try and figure things out on it's own but at an additional cost.

In terms of prompting, I've been fairly successful by decomposing features into very narrow slices of functionality. This is difficult to describe precisely, but it's primarily about removing any ambiguity from the prompt. A good rule of thumb for sizing agile user stories is "big enough to contain useful functionality, but small enough to estimate somewhat accurately". I'm using a similar approach to LLM prompting. I ask for code that I could write myself in no more than an hour. This allows me to inspect and understand the code that is being generated, constrain the context window somewhat and reduce the blast radius if we get off the rails. In practical terms it means that I start the prompt with "Lets plan a new feature. This is what I need" and then focus on a specific subset of the proposed functionality until I'm satisfied that it's working as desired.


## Conclusion {#conclusion}

I definitely had a bit of anxiety entering the AI era. There was a widespread expectation that LLMs would replace developers pretty damn soon and I got caught up in it. It's early enough that it might happen still. In "[No Silver Bullet](https://en.wikipedia.org/wiki/No_Silver_Bullet)", Brooks talks about **essential complexity** and **accidental complexity**. Accidental complexity is how to write a `for` loop in Golang. [Essential complexity](https://en.wikipedia.org/wiki/Programming_complexity) is understanding and solving problems at a more conceptual level. The "why" of a business problem, for instance. While LLMs excel at solving accidental complexity problems -- how do I deploy this application to kubertnetes -- they are not quite there for essentially complexity problems. The evolution of AI and coding assistants seem comparable to the shift from low level to high level languages. The productivity gains have been incredible but they didn't solve the ultimate problem of software engineering.

The other issue I'm pondering is the craftsmanship of software engineering. Manually writing every line of code is very satisfying, but more than that, it's "[programming as theory building](https://pages.cs.wisc.edu/~remzi/Naur.pdf)":

> ...the quality of the designing programmer’s work is related to the quality of the match between his theory of the problem and his theory of the solution....the quality of a later programmer’s work is related to the match between his theories and the previous programmer’s theories.

In other words, my code is only as good as my understanding of the problem and the solution. If I'm maintaining someone else's code my contributions are only as good as my understanding of the original author's solution. Moving forward, it seems as given that most code is going to be written by LLMs. We are likely to have only a surface level understanding of the solution space because we are not writing the code, and because reading code is genuinely hard:

> Everyone knows that debugging is twice as hard as writing a program in the first place. So if you’re as clever as you can be when you write it, how will you ever debug it?

So what does this all mean for the overall software industry? No idea, and I would be skeptical about any and all predictions. We are living through a tectonic shift in the software industry and it's exhilarating.
