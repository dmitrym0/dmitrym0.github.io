+++
title = "How to check for X-Send-File (or X-Accel-Redirect)"
author = ["Dmitry Markushevich"]
date = 2018-09-11
lastmod = 2023-05-22T12:33:09-07:00
tags = ["Development"]
draft = false
+++

Some web requests should not be handled by the application framework. Requests hitting a dynamic API endpoint should be processed by application (in my case typically Ruby on Rails). Static assets (such as files) should be served by the webserver, bypassing Ruby on Rails completely.

Why?

There are a couple of reasons.

The biggest one is performance. NGINX and Apache are significantly better and faster at serving files than a Ruby process. It’s the whole reason for their existence.

Secondly, leaving Ruby processes out of serving static files frees that process up to serve dynamic requests.

For example, here Ruby is serving a font file. It ties the ruby process up for over half a second for no reason.

```bash { hl_lines=["8"] }
I, [2018-09-02T22:50:21.284547 #33169]  INFO — : Sent file ff133.ttf (0.3ms)
I, [2018-09-02T22:50:21.284839 #33169]  INFO — : Completed 200 OK in 633ms (ActiveRecord: 61.4ms)
```

It should be noted, that webservers typically have hundreds of threads serving requests, whereas the application (Ruby on Rails) has on the order of tens of processes. So tying a ruby process up to serve files is wasteful.

The alternative is [XSendfile](<https://www.nginx.com/resources/wiki/start/topics/examples/xsendfile/>). Once the application determines that it does not need to serve the file it can signal the webserver to take over.

I always struggle to remember how  to identify requests served by Rails vs requests served by the web server.

Turns out it’s pretty simple.

If the response contains \`X-Request-ID\` header, then it was served by Rails. Otherwise it was served by the webserver.

[Matt Bricston](<https://mattbrictson.com/accelerated-rails-downloads>) has more info.
