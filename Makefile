.ONESHELL:
SHA := $(shell git rev-parse --short=8 HEAD)
GITVERSION := $(shell git describe --long --all)
BUILDDATE := $(shell date -Iseconds)
VERSION := $(or ${VERSION},devel)

BINARY := firewall-policy-controller

.PHONY: test
test:
	go test -v -cover ./...

.PHONY: all
bin/$(BINARY): test
	GGO_ENABLED=0 \
	GO111MODULE=on \
		go build \
			-trimpath \
			-tags netgo \
			-o bin/$(BINARY) \
			-ldflags "-X 'github.com/metal-pod/v.Version=$(VERSION)' \
					-X 'github.com/metal-pod/v.Revision=$(GITVERSION)' \
					-X 'github.com/metal-pod/v.GitSHA1=$(SHA)' \
					-X 'github.com/metal-pod/v.BuildDate=$(BUILDDATE)'" . && strip bin/$(BINARY)

.PHONY: all
all:: bin/$(BINARY);
