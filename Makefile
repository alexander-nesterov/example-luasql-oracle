SHELL := /bin/bash
LUA_VERSION := v5.4.4
LUASQL_VERSION := v2.4.0
LUA_SYS_VER := 5.4
LUA_INC := $(shell pwd)/lua

.PHONY: clone
clone:
	@git clone https://github.com/lua/lua.git --branch $(LUA_VERSION) --single-branch
	@git clone https://github.com/keplerproject/luasql.git --branch $(LUASQL_VERSION) --single-branch

.PHONY: build
build:
	export LUA_SYS_VER=$(LUA_SYS_VER); \
	export LUA_INC=$(LUA_INC); \
	cd luasql && make oci8

.PHONY: clean
clean:
	@rm -rf lua
	@rm -rf luasql