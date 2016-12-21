#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  ./osx.sh $@
else
  ./linux.sh $@
fi
