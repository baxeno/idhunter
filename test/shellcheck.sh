#!/bin/bash

set -u # exit if an uninitialized variable is used
set -e # exit if any statement returns a non-true value

PATH="$HOME/.cabal/bin:$PATH"


shellcheck -V

shellcheck ../scripts/search.sh

