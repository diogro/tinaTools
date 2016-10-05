Docker install
```
curl -fsSL https://get.docker.com/ | sh
```

Launch tinaTools
```
docker run -ti --rm -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ~/projects/CTtests:/home/developer/CTscans \
           diogro/tinatools
```

