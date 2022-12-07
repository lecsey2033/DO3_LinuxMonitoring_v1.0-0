#!/bin/bash

function regex() {
    re='^[+-]?[0-9]+([.][0-9]+)?$'
    if [[ $1 =~ $re ]]
    then
        echo 'error: enter not a number'
    else
        echo $1
    fi
}