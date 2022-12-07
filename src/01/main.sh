#!/bin/bash

source ./regex.sh

if [ $# -ne 1 ]
then
    echo "error: enter only one argument"
else
    regex $1
fi
