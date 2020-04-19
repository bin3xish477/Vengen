#!/bin/bash

# This file will clone Vengen's repo
# and will create a symbolic link to the
# Vengen source file.

git clone https://github.com/binexisHATT/Vengen.git

sleep 4

cd Vengen

sleep 1

ln ./vengen.sh /bin/vengen
