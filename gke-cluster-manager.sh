#!/bin/bash

echo -e "

### This shell script downloads a manager into server and can perform the following actions...
        1. Create Cluster
        2. Delete Cluster
        3. Manage Cluster 
            a. Increase number of nodes
            b. Delete number of nodes
"

echo -e "Installing Pre-requisites\n"

Check_() {
    MSG=$1
    rm -f /tmp/print-stat
    while true ; do 
        for i in \| \/ \- \\ \| \/ \- \\; do 
            echo -n -e "\r$MSG  $i  "
            sleep 0.5
        done                                                                                    
    [ -f /tmp/print-stat ] && return
    break
    done
}

Stop_Check() {
    sleep 4
    #echo -n -e "\r                                                                                                 "
    touch /tmp/print-stat
}

Stat() {
    case $1 in 
        install) 
            if [ $3 -eq 0 ]; then 
                Stop_Check
                echo -e "\rTool $2  - \e[32mINSTALLED\e[0m"
                return
            else
                Stop_Check
                echo -e "\rTool $2 - \e[31mNOT-INSTALLED\e[0m"
                return 1
            fi
            ;;
    esac
}

IStat() {
    if [ $2 -eq 0 ]; then 
        echo -e "Installing $1 - \e[32mSUCCESS\e[0m"
    else 
        echo -e "Installing $1 - \e[31mFAILURE\e[0m"
        Stop_Check 
        exit 1
    fi
}

### Main Program

## Check Root Privileges
if [ $(id -u) -ne 0 ]; then 
    echo -e " \e[1;31m You should be root user to perform this script. Run with sudo or run as root user\n\e[0m"
    exit 1
fi

Check_ "Checking Kubectl" & &>/dev/null
which kubectl &>/dev/null 
Stat install "kubectl" $?                 
if [ $? -ne 0 ]; then 
    echo '[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/google.repo
    yum install kubectl -y &>/dev/null
    IStat kubectl $?
    Stop_Check
fi 

Check_ "Checking gcloud" & &>/dev/null
which gcloud &>/dev/null 
Stat install gcloud $?
if [ $? -ne 0 ]; then 
    echo '[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/google.repo
    yum install google-cloud-sdk -y &>/dev/null 
    IStat gcloud $?
    Stop_Check
fi 

#echo 
Check_ "You are suppose to open the following URL in a browser and get the code and copy it over here" & &>/dev/null
sleep 6
Stop_Check
sleep 4

gcloud auth login 