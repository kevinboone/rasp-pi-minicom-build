#!/bin/bash
# modprobe a bunch of module names, which may be supplied as one long
#  (space-separated) argument, or multiple arguments, or some mixture of
#  the two.

if [[ $1 == "" ]]; then
  # Do nothing -- it's not an error to have any empty list
  exit 0 
fi

for arg in "$@"
do
  modlist=($arg)
  for i in "${modlist[@]}" ; do
    /sbin/modprobe $i 
  done
done

