#!/bin/bash

echo -e "
### This shell script is going to manage the cluster for ease of practice during the trainings.
### This shell script downloads a manager into server and can perform the following actions...
        1. Create Cluster
        2. Delete Cluster
        3. Manage Cluster 
            a. Increase number of nodes
            b. Delete number of nodes
"

echo -e "Installing Pre-requisites"

Check_() {
    while true ; do 
        for i in \| \/ \- \\ \| \/ \- \\; do 
            echo -n -e "\r$1  $i  "
            sleep 0.5
        done                                                                                    
    [ -f /tmp/print-stat ] && break 2
    done
}

Stat() {
    case $1 in 
        install) 
            if [ $3 -eq 0 ]; then 
                echo -e "Tool $2  - \e[32mINSTALLED\e0m"
                return
            else
                echo -e "Tool $2 - \e[31mNOT-INSTALLED\e[0m"
                return 1
            fi
            ;;
    esac
}

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

fi 