# sdcarter/dev development container

I created this image so I'd have a consistent and complete development environment I could run anywere.

```docker
docker run -it --rm --hostname dev \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /path/to/code:/root/git \
  -v /path/to/.ssh:/root/.ssh \
  sdcarter/dev:latest
```
