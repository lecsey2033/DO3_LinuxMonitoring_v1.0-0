#!/bin/bash

function data_of_system {

    first=$(choice_color $1 $2)
    second=$(choice_color $3 $4)
    #сетевое имя
    hostname=$(hostname)
    echo -e "${first}HOSTNAME: ${second}$hostname\033[0m"

    #временная зона в виде: America/New_York UTC -5
    type_zone=$(timedatectl | awk '{print $3}' | awk '(NR==4)')
    time_zone=$(timedatectl | awk '{print $6}' | awk '(NR==2)')
    difference_time_zone=$(timedatectl | awk '{print $5}' | awk '(NR==4)' | cut -b -2)
    echo -e "${first}TIMEZONE: ${second}$type_zone $time_zone $difference_time_zone\033[0m"

    #текущий пользователь который запустил скрипт
    user=$(users)
    echo -e "${first}USER: ${second}$user\033[0m"

    #тип и версия операционной системы
    type_OS=$(hostnamectl | awk '{print $3}' | awk '(NR==7)')
    version_OS=$(hostnamectl | awk '{print $4}' | awk '(NR==7)')
    echo -e "${first}OS: ${second}$type_OS $version_OS\033[0m"

    #текущее время в виде: 12 May 2020 12:24:36
    DATE=$(date "+%d %B %Y %T")
    echo -e "${first}DATE: ${second}$DATE\033[0m"

    #время работы системы
    UPTIME=$(uptime -p)
    echo -e "${first}UPTIME: ${second}$UPTIME\033[0m"

    #время работы системы в секундах
    UPTIME_SECOND=$(awk '{print $1}' /proc/uptime)
    echo -e "${first}UPTIME_SECOND: ${second}$UPTIME_SECOND seconds\033[0m"

    #ip-адрес машины в любом из сетевых интерфейсов
    IP=$(ip a | awk '{print $2}' | awk '(NR==3)')
    echo -e "${first}IP: ${second}$IP\033[0m"

    #сетевая маска любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx
    MASK=$(ipcalc $IP | awk '{print $2}' | awk '(NR==2)')
    echo -e "${first}MASK: ${second}$MASK\033[0m"

    #ip шлюза по умолчанию
    GATEWAY=$(ip route | awk '{print $3}' | awk '(NR==1)')
    echo -e "${first}GATEWAY: ${second}$GATEWAY\033[0m"

    #размер оперативной памяти в Гб c точностью три знака после запятой в виде: 3.125 GB
    RAM_TOTAL=$(awk '{print $2}' /proc/meminfo | awk '(NR==1)' | awk '{printf "%.3f",$1/1024/1024}')
    echo -e "${first}RAM_TOTAL: ${second}$RAM_TOTAL GB\033[0m"
    RAM_USED=$(free | awk '{print $3}' | awk '(NR==2)' | awk '{printf "%.3f", $1/1024/1024}')
    echo -e "${first}RAM_USED: ${second}$RAM_USED GB\033[0m"
    RAM_FREE=$(free | awk '{print $4}' | awk '(NR==2)' | awk '{printf "%.3f", $1/1024/1024}')
    echo -e "${first}RAM_FREE: ${second}$RAM_FREE GB\033[0m"

    # размер рутового раздела в Mб с точностью два знака после запятой в виде: 254.25 MB
    SPACE_ROOT=$(df -i / | awk '{print $2}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    SPACE_ROOT_FREE=$(df -i / | awk '{print $4}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    SPACE_ROOT_USED=$(df -i / | awk '{print $3}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    echo -e "${first}SPACE_ROOT: ${second}$SPACE_ROOT MB\033[0m"
    echo -e "${first}SPACE_ROOT_USED: ${second}$SPACE_ROOT_USED MB\033[0m"
    echo -e "${first}SPACE_ROOT_FREE: ${second}$SPACE_ROOT_FREE MB\033[0m"
}

function output {
    re='^[1-6]{1}?$'  
    if [ $# -ne 4 ]
    then 
        echo -e "\033[31menter 4 parameters\033[0m"
    elif ! ([[ $1 =~ $re ]] && [[ $2 =~ $re ]] && [[ $3 =~ $re ]] && [[ "$4" =~ $re ]])
    then
        echo -e "\033[31menter a parameter in the range from 1 to 6\033[0m"
    elif [ $1 -eq $2 ] || [ $3 -eq $4 ]
    then
        if [ $1 -eq $2 ]
        then
            echo -e "\033[31mparameters '1' and '2' must be different"
        fi
        if [ $3 -eq $4 ]
        then
            echo -e "\033[31mparameters '3' and '4' must be different"
        fi
        echo -e "try entering the parameters again\033[0m"
    else
        data_of_system $1 $2 $3 $4
    fi
}

function choice_color_of_text {
    case "$1" in
    1) echo "\\033[37m" ;;
    2) echo "\\033[31m" ;;
    3) echo "\\033[32m" ;;
    4) echo "\\033[34m" ;;
    5) echo "\\033[35m" ;;
    6) echo "\\033[30m" ;;
    esac
}

function choice_color_of_bg {
    case "$1" in
    1) echo "\\033[47m" ;;
    2) echo "\\033[41m" ;;
    3) echo "\\033[42m" ;;
    4) echo "\\033[44m" ;;
    5) echo "\\033[45m" ;;
    6) echo "\\033[40m" ;;
    esac
}

function choice_color {
    text=$(choice_color_of_text $1)
    bg=$(choice_color_of_bg $2)
    echo "$text$bg"
}
