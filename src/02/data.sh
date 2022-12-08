#!/bin/bash

function data_of_system {

    #сетевое имя
    echo 'HOSTNAME: '$(hostname)

    #временная зона в виде: America/New_York UTC -5
    type_zone=$(timedatectl | awk '{print $3}' | awk '(NR==4)')
    time_zone=$(timedatectl | awk '{print $6}' | awk '(NR==2)')
    difference_time_zone=$(timedatectl | awk '{print $5}' | awk '(NR==4)' | cut -b -2)
    echo "TIMEZONE: $type_zone $time_zone $difference_time_zone"

    #текущий пользователь который запустил скрипт
    echo 'USER: '$(users)

    #тип и версия операционной системы
    type_OS=$(hostnamectl | awk '{print $3}' | awk '(NR==7)')
    version_OS=$(hostnamectl | awk '{print $4}' | awk '(NR==7)')
    echo "OS: $type_OS $version_OS"

    #текущее время в виде: 12 May 2020 12:24:36
    DATE=$(date "+%d %B %Y %T")
    echo "DATE: $DATE"

    #время работы системы
    UPTIME=$(uptime -p)
    echo "UPTIME: $UPTIME"

    #время работы системы в секундах
    UPTIME_SECOND=$(awk '{print $1}' /proc/uptime)
    echo "UPTIME_SECOND: $UPTIME_SECOND seconds"

    #ip-адрес машины в любом из сетевых интерфейсов
    IP=$(ip a | awk '{print $2}' | awk '(NR==3)')
    echo "IP: $IP"

    #сетевая маска любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx
    MASK=$(ipcalc $IP | awk '{print $2}' | awk '(NR==2)')
    echo "MASK: $MASK"

    #ip шлюза по умолчанию
    GATEWAY=$(ip route | awk '{print $3}' | awk '(NR==1)')
    echo "GATEWAY: $GATEWAY"

    #размер оперативной памяти в Гб c точностью три знака после запятой в виде: 3.125 GB
    RAM_TOTAL=$(awk '{print $2}' /proc/meminfo | awk '(NR==1)' | awk '{printf "%.3f",$1/1024/1024}')
    echo "RAM_TOTAL: $RAM_TOTAL GB"
    RAM_USED=$(free | awk '{print $3}' | awk '(NR==2)' | awk '{printf "%.3f", $1/1024/1024}')
    echo "RAM_USED: $RAM_USED GB"
    RAM_FREE=$(free | awk '{print $4}' | awk '(NR==2)' | awk '{printf "%.3f", $1/1024/1024}')
    echo "RAM_FREE: $RAM_FREE GB"

    # размер рутового раздела в Mб с точностью два знака после запятой в виде: 254.25 MB
    SPACE_ROOT=$(df -i / | awk '{print $2}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    SPACE_ROOT_FREE=$(df -i / | awk '{print $4}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    SPACE_ROOT_USED=$(df -i / | awk '{print $3}' | awk '(NR==2)' | awk '{printf "%.2f", $1/1024}')
    echo "SPACE_ROOT: $SPACE_ROOT MB"
    echo "SPACE_ROOT_USED: $SPACE_ROOT_USED MB"
    echo "SPACE_ROOT_FREE: $SPACE_ROOT_FREE MB"
}

function saving_info(){
    echo "Save data to a file? Y/N"

    read line

    if [ "$line" = "Y" ] || [ "$line" = "y" ]
    then 
    name_file=$(date "+%d %B %Y %T")
    exec > "$name_file.status"
    data_of_system
    fi
}
