
build: local/bin/topframe

dev:
	go run ./topframe.go

clean:
	rm -fr dist
	rm -f local/bin/topframe

release:
	git tag v$(version:dev=)
	git push origin v$(version:dev=)
	goreleaser release --rm-dist
	@echo "==> Remember to update ./version! Current contents: $(version)"

local/bin/topframe: topframe.go data/*
	go build -ldflags $(ldflags) -o local/bin/topframe .

version=$(shell cat version)
branch=$(shell git branch --show-current)
ldflags="-X main.Version=$(version:dev=$(branch))"

# macdriver's generated cgo calls a few methods missing from newer macOS SDKs.
# On x86_64 (BOOL is signed char) modern clang makes that a hard error.
CGO_CFLAGS ?= -O2 -g
CGO_CFLAGS += -Wno-error=int-conversion
export CGO_CFLAGS