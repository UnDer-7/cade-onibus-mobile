#!/usr/bin/env bash

echo "-----------------------"
echo "STARTING THE PROXY..."
cd ~
cd Android/Sdk/platform-tools/
./adb reverse tcp:8080 tcp:8080
printf "\nPROXY REALIZADO\n"
echo "-----------------------"
