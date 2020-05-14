#!/bin/bash

# This file will clone Vengen's repo
# and will create a symbolic link to the
# Vengen source file.

git --version 2>&1 >/dev/null
git_version_status=$?

if [ $git_version_status -eq 0 ];
then
  git clone https://github.com/binexisHATT/Vengen.git
  sleep 2
  cd Vengen
  sleep 1
  sudo ln -s ./src/vengen.sh /bin/vengen
  sleep 1
  rm ../install.sh
else
  echo "Git needs to be installed for this installation... Please install it!"
fi
