#! /usr/bin/env bash
set -uvx
set -e
scribble --markdown --dest . --dest-name README.md meta-json.scrbl
