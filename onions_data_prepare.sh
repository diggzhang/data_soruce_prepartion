#!/bin/bash
set -e # exit on error

#---------------------------------------------------------------------
# What: 召唤线上准备onions数据源的脚本
#
# comment: 执行此脚本后，会跳到线上的vpcdoor，然后经过vpcdoor召唤x-home的onions业务库相关
#          的备份脚本
#
# Built-in tools:     ssh vpndoor交互ssh-key确保无密码访问
# Internal script:    null
# Pre-execution:      null
# Post-execution:     /home/master/yangcongDatabase/v4collections/temp/01_onionsFirstReadyCollecion.sh
#
# author:      Xingze Zhang
# contact:     xingze@guanghe.tv/diggzhang@gmail.com
# since:       20180608
#
# Update:
#   20180608 - diggzhang - 初始化脚本
#
#---------------------------------------------------------------------

# SCRIPT CONFIGURATION
#---------------------------------------------------------------------

if [ $(uname) = "Darwin" ]
then
    echo "Alias date to gdate on macOS"
    echo "Ref: https://stackoverflow.com/questions/7216358/date-command-on-os-x-doesnt-have-iso-8601-i-option"
    alias  date="gdate"
fi

SCRIPT_NAME=$(basename "$0")
VERSION=0.1

# Global variables
YEAR=$(date -d -0day '+%Y')
MONTH=$(date -d -0day '+%m')
DAY=$(date -d -0day '+%d')
LOGFILE=/tmp/airflow_scheduling_"$YEAR$MONTH$DAY".log
WORK_DIR=/home/master/dag_scheduler_jobs/onions_data_source/

#---------------------------------------------------------------------
# UTILITY FUNCTIONS
#---------------------------------------------------------------------

# log message to screen and log file
log ()
{
    echo "[${SCRIPT_NAME}]: $1" >> "$LOGFILE"
    echo "[${SCRIPT_NAME}]: $1"
}

# Define script functions here

onions_data_preparetion() {
    log $(date)
    ssh -p 233 backup@vpcdoor "/bin/bash /home/backup/Scripts/data_dev/vpcdoor_onions_preparetion.sh"
    log $(date)
}


main()
{
    log "version $VERSION"
    log "(1/1) onions_data_preparetion"
    onions_data_preparetion >> "$LOGFILE"
}

main "$@"
