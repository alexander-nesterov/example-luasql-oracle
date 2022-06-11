SHELL := /bin/bash

LUA_VERSION := v5.4.4
LUASQL_VERSION := v2.4.0
LUA_SYS_VER := 5.4
LUA_INC := $(shell pwd)/lua

ORACLE_LIBS_URL := https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip
ORACLE_SDK_URL := https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip
DRIVER_LIBS_oci8 := "-L $(shell pwd)/instantclient-lib/instantclient_21_6"
DRIVER_INCS_oci8 := "-I $(shell pwd)/instantclient-sdk/instantclient_21_6/sdk/include"

.PHONY: clone
clone:
	@git clone https://github.com/lua/lua.git --branch $(LUA_VERSION) --single-branch
	@git clone https://github.com/keplerproject/luasql.git --branch $(LUASQL_VERSION) --single-branch

.PHONY: download
download:
	@wget -O instantclient-libs.zip $(ORACLE_LIBS_URL)
	@wget -O instantclient-sdk.zip $(ORACLE_SDK_URL)
	@unzip instantclient-lib.zip -d instantclient-libs
	@unzip instantclient-sdk.zip -d instantclient-sdk
	@rm instantclient-libs.zip
	@rm instantclient-sdk.zip

.PHONY: build
build:
	export LUA_SYS_VER=$(LUA_SYS_VER); \
	export LUA_INC=$(LUA_INC); \
	export DRIVER_LIBS_oci8=$(DRIVER_LIBS_oci8); \
	export DRIVER_INCS_oci8=$(DRIVER_INCS_oci8); \
	cd luasql && make oci8

.PHONY: clean
clean:
	@rm -rf lua
	@rm -rf luasql
	@rm -rf instantclient-libs
	@rm -rf instantclient-sdk