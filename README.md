# Makefile for golang

```
Makefile template for build golang apps.
```

#### Quick Start

Copy Makefile to you golang app top directory, and type `make`. If you want to debug, type `DEBUG=1 make`.

The binaries will be generate under the directory: ./bin/

#### Usages

You can use `make help` to show usages, as follow:

```
TARGETS:
  all                             builds binaries for current platform
  all-build                       builds binaries for all platforms
  build                           builds binaries for current platform
  clean                           removes built binaries and temporary files
  check                           report likely mistakes in packages
  format                          gofmt (reformat) package sources
  help                            prints this message

INFOS:
  current platform: darwin/amd64
  all support platforms: linux/amd64 linux/arm linux/arm64 darwin/amd64 windows/386 windows/amd64
```
