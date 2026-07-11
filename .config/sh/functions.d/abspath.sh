#!/bin/sh
abspath() { (cd "$1" && pwd); } # absolute, but avoid dereferencing symlinks
