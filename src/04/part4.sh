#!/bin/bash

source ../03/data.sh
source ./part4.conf

function part4 {
    re='^[1-6]{1}?$'
    if ([ $column1_font_color ] && [[ $column1_font_color =~ $re ]]) 
    then    
        one=$column1_font_color
    else 
        one=1
    fi

    if ([ $column1_bachground ] && [[ $column1_bachground =~ $re ]])
    then    
        two=$column1_bachground
    else 
        two=6
    fi

    if ([ $column2_font_color ] && [[ $column2_font_color =~ $re ]])
    then    
        three=$column2_font_color
    else 
        three=1
    fi

    if ([ $column2_bachground ] && [[ $column2_bachground =~ $re ]])
    then    
        four=$column2_bachground
    else 
        four=6
    fi

    data_of_system $one $two $three $four
    conf_file $one $two $three $four
}

function conf_file {
    font=1
    bg=2
    echo ""
    echo "Column 1 background = "$(echo_conf $two $bg)
    echo "Column 1 font color = "$(echo_conf $one $font)
    echo "Column 2 background = "$(echo_conf $four $bg)
    echo "Column 2 font color = "$(echo_conf $three $font)
}

function echo_conf {
    case "$1" in
    1) if [ $2 -eq 1 ]
       then
       echo "default (white)"
       else
       echo "1 (white)"
       fi ;;
    2) echo "2 (red)" ;;
    3) echo "3 (green)" ;;
    4) echo "4 (blue)" ;;
    5) echo "5 (purple)" ;;
    6) if [ $2 -eq 2 ] 
       then
       echo "default (black)"
       else
       echo "6 (black)" 
       fi ;;
    esac
}






