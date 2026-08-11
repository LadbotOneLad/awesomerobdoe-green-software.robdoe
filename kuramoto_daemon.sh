#!/bin/bash
cd ~/robdoerootauthority
while true; do
    ./kuramoto_stream >> kuramoto.log 2>&1
    sleep 1
done
