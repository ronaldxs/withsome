#!/bin/bash

######################################################################
# Small bash driver program that runs expect test script.
# You are working with alpha software: - PLEASE DO RUN THIS - THANKS
######################################################################

cd "$( dirname "$0" )"
wcl () { wc -l "$@" ; }
export -f wcl
./t.exp
