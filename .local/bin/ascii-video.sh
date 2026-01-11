#!/bin/bash

while true; do
  for frame in ~/ascii_video/ascii/*.txt; do
    clear
    cat "$frame"
    sleep 0.04
  done
done
