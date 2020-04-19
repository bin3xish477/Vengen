#!/bin/bash

# This file will clone Vengen's repo
# and will create a symbolic link to the
# Vengen source file.

git --version 2>&1 >/dev/null
git_version_status=$?

if [ $git_version_status -eq 0 ];
then
  git clone https://github.com/binexisHATT/Vengen.git
  sleep 3
  cd Vengen
  sleep 1
  ln ./src/vengen.sh /bin/vengen
else
  echo "Git needs to be installed for this installation... Please install it!"
fi
