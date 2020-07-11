#!/bin/bash

LOG_PATH=$ARGO_HOME/log

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function log_info() {
    message=$1
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${TS} [INFO] $message" 2>&1 | tee -a "$RT_LOGFILE_LOC"
}


function log_debug() {
    message=$1
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${TS} [DEBUG] $message" 2>&1 | tee -a "$RT_LOGFILE_LOC"
}



function log_start() {
    message=$1
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${TS} [START] $message" 2>&1 | tee -a "$RT_LOGFILE_LOC"
}


function log_end() {
    message=$1
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${TS} [END] $message" 2>&1 | tee -a "$RT_LOGFILE_LOC"
}
