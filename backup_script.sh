#!/bin/bash
 
#### JOB: backup script to rsync home data to external usb hd
#### OS: built and tested on fedora 22
#### REQUIREMENTS: pv
#### AUTHOR: david ziswiler
#### DATE: 20.10.15

### TODO: Versioning


# define vars
USBDRIVENAME="USB"
SOURCE=/home/$USER/
TARGET=/run/media/$USER/$USBDRIVENAME
FULLFOLDER=$TARGET/Backup/full
DIFFFOLDER=$TARGET/Backup/diff
ARCHFOLDER=$TARGET/Backup/archive
DATE=`date +%Y_%m_%d_%H_%M`

# check if usb hd is mounted
if mountpoint -q ${TARGET}; then
	echo "OK - $USBDRIVENAME is mounted"
else
	echo "ERROR - $USBDRIVENAME is NOT mounted"
	exit 0
fi


# Check here if user wants full or differential backup
echo '********** Please select backup type (f)ull  or (d)ifferential  [f/d]: '
read answere

if [ "${answere}" = "f" ] ; then

    ## FULL BACKUP:

    # check if folder exists
	if [ ! -d $FULLFOLDER ] ; then
	    mkdir -p $FULLFOLDER
	    echo "INFO - Folder $FULLFOLDER has been created"
	else
	    echo "OK - Folder $FULLFOLDER already exists"
	fi

    # check if arch folder exists
	if [ ! -d $ARCHFOLDER ] ; then
	    mkdir -p $ARCHFOLDER
	    echo "INFO - Folder $ARCHFOLDER has been created"
	else
	    
	    echo "OK - Folder $ARCHFOLDER already exists"

	    echo "### INFO - Move last FULL backup to archive"
		mv $FULLFOLDER/* $ARCHFOLDER
		
		echo "### INFO - delete all backups older than last two"
		cd $ARCHFOLDER
		ls -tr | head -n -2 | xargs rm
	
	fi

	# run full backup
	echo "### INFO - Starting FULL Backup of $SOURCE"
	tar -cvzf $FULLFOLDER/$DATE.tar.gz $SOURCE | pv -p --timer --rate --bytes
	echo "### INFO - FULL Backup of $SOURCE done"

elif [ "${answere}" = "d" ] ; then

	## DIFF BACKUP:

	# check if folder exists
	if [ ! -d $DIFFFOLDER ] ; then
        mkdir -p $DIFFFOLDER
        echo "INFO - Folder $DIFFFOLDER has been created"
	else
        echo "OK - Folder $DIFFFOLDER already exists"
	fi

	# run diff backup
	echo "### INFO - Starting DIFF Backup of $SOURCE"
	sudo rsync -vrlptg --exclude-from 'exclude-list.txt' "${SOURCE}" "${DIFFFOLDER}" --info=progress2
	echo "### INFO - DIFF Backup of $SOURCE done"
else
	echo "ERROR - you did not enter f or d"
	exit 0
fi