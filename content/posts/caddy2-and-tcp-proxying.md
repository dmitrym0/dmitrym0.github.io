+++
title = "Caddy 2 and TCP Proxying"
author = ["Dmitry Markushevich"]
date = 2022-03-14
lastmod = 2023-05-22T12:33:10-07:00
tags = ["DevOps"]
draft = false
+++

How to configure Caddy2 to proxy TCP streams.

To illustrate the architecture, I have the following entities running in Docker.

{{< figure src="/ox-hugo/gateway-overview-v1.png" >}}

I'm using [Caddy 2](https://caddyserver.com) as a reverse proxy, but it looks like it supports many more scenarios. Previously I used nginx, or traeffic. The appeal of Caddy is that it supports TLS (with LetsEncrypt) out of the box and integrates with [Consul](https://caddyserver.com/docs/modules/caddy.storage.consul) for an eventual clustering solution with Nomad.

Startup with Caddy was very simple. Configuration with `Caddyfile` is quite straightforward. I was up and proxying internal HTTP services in no time. I did hit a snag when I needed to proxy non HTTP, in this case an MQTT stream. Turns out it's not very difficult but there's no good description of how to do it.

First, you need to build caddy with [caddy-l4](https://github.com/mholt/caddy-l4) plugin:

```dockerfile
FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-l4

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```

Since `caddy-l4` does not support `Caddyfile` s, the configuration needs to be in JSON. Since I already started with a `Caddyfile`, I converted it to JSON:

```sh
caddy adapt —config Caddyfile —adapter Caddyfile
```

I then merged the output with the following manually crafted JSON:

```json
"layer4": {
    "servers": {
        "servername": {
            "listen": ["0.0.0.0:1883"],
            "routes": [
                {
                    "handle": [
                        {"handler": "tls"},
                        {"handler": "proxy", "upstreams": [{"dial": ["mqtt-server:1883"]}]}
                    ]
                }
            ]
        }
    }
}
```

This JSON directs Caddy to:

1.  establish a connection on port 1883
2.  terminate the TLS
3.  pass the unencrypted connection to `mqtt-server` (this hostname is provided and resolved by Docker)

Finally, I had to modify the default execution string for the caddy container in my `docker-compose.yml`:

```yml
caddy:
  image: falcon-caddy:2
  restart: unless-stopped
  ports:
    - "80:80"
    - "443:443"
    - "1883:1883"   # mqtt
  volumes:
    - ./caddy/caddyfile.json:/etc/caddy/caddyfile.json
  environment:
  command: ['caddy', 'run', '-config', '/etc/caddy/caddyfile.json']
```
