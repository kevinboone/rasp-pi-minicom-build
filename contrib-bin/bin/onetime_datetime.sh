#!/bin/bash
URL=http://google.com
MAX_TRIES=5
DELAY=30

tries=0
notset=true

while $notset && (( $tries < $MAX_TRIES ))
do
  logger --socket-errors=off -s $0: Getting time from $URL
  response=`curl -s --head $URL | grep ^Date: | sed 's/Date: //g'` 
  if [ -z "$response" ]; then
    logger --socket-errors=off -s $0: No response -- sleeping
    sleep $DELAY 
    tries=$(($tries+1))
  else
    notset=false
    date -s "$response" > /dev/null
  fi 
done

if (( $tries == $MAX_TRIES )); then
  logger --socket-errors=off -s $0: Could not get date from $URL after $MAX_TRIES attempts -- giving up 
fi

