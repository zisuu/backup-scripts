#!/bin/bash
 
#### JOB: backup pfsense config
#### OS: built and tested on fedora 22
#### REQUIREMENTS: -
#### AUTHOR: david ziswiler
#### DATE: 23.12.15

# define vars
DATE="config_`date +%Y_%m_%d_%H_%M`"
ACCOUNT=root
PFSENSE=192.168.100.254
SOURCE=/cf/conf/config.xml
TARGETDIR=/home/$USER/Downloads/pfSense_backup/

# check if folder exists
if [ ! -d $TARGETDIR ] ; then
    mkdir -p $TARGETDIR
    echo "INFO - Folder $TARGETDIR has been created"
else
    echo "OK - Folder $TARGETDIR already exists"
fi

# get config
echo "********** getting config now from $PFSENSE"

scp $ACCOUNT@$PFSENSE:$SOURCE $TARGETDIR$DATE.xml

echo "********** DONE! Filename: $DATE.xml"
exit 0
