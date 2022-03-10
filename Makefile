#!/bin/bash
#
# Copyright (C) 2022 smallmuou <smallmuou@163.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# for debug
DEBUG_MAKEFILE ?=
ifeq ($(DEBUG_MAKEFILE),1)
    $(warning *************** debug mode ***************)
else
    # If we're not debugging the Makefile, don't echo recipes.
    MAKEFLAGS += -s
endif

# Go
GO := go
GOFLAGS :=

# The binaries to build (just the basenames)
BIN := hello

# The all platforms we support.
ALL_PLATFORMS := linux/amd64 linux/arm linux/arm64 darwin/amd64 windows/386 windows/amd64

# The current platform
OS := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))

all: # @HELP builds binaries for current platform
all: build

# For the following OS/ARCH expansions, we transform OS/ARCH into OS_ARCH
build-%:
	echo "# building for $(firstword $(subst _, ,$*))/$(lastword $(subst _, ,$*)) ..."
	mkdir -p bin/$(firstword $(subst _, ,$*))_$(lastword $(subst _, ,$*))
	cd bin/$(firstword $(subst _, ,$*))_$(lastword $(subst _, ,$*)); \
	CGO_ENABLE=0 GOOS=$(firstword $(subst _, ,$*)) GOARCH=$(lastword $(subst _, ,$*)) \
	$(GO) build ../../
	echo "output to bin/$(firstword $(subst _, ,$*))_$(lastword $(subst _, ,$*))"

all-build: # @HELP builds binaries for all platforms
all-build: format $(addprefix build-, $(subst /,_, $(ALL_PLATFORMS)))

build: # @HELP builds binaries for current platform
build: format build-$(OS)_$(ARCH)
	echo

clean: # @HELP removes built binaries and temporary files
clean:
	echo "remove bin/ ..."
	rm -rf bin

check: # @HELP report likely mistakes in packages
	$(GO) vet

format: # @HELP gofmt (reformat) package sources
	$(GO) fmt

help: # @HELP prints this message
help:
	@echo "VARIABLES:"
	echo "  BIN = $(BIN)"
	echo "  OS = $(OS)"
	echo "  ARCH = $(ARCH)"
	echo "  GOFLAGS = $(GOFLAGS)"
	echo
	echo "TARGETS:"
	grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)     \
	    | awk '                                   \
	        BEGIN {FS = ": *# *@HELP"};           \
	        { printf "  %-30s %s\n", $$1, $$2 };  \
		'
