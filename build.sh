#!/usr/bin/env bash

make clean
make
st-flash erase
st-flash --reset write output/*.bin 0x8000000

