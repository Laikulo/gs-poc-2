#!/usr/bin/env bash
set -e -x
./render.py
exec sudo ./inst.sh
