#!/bin/sh

# requirements: you have a usb drive mounted to the given mount points
# this drive is encrypted with ecryptfs

# 1. script will mount encypted data folder to a mount point
# 2. script will start a backup with rsync. the links are verified so you may safely copy a structre with multiple links to a file

ENCDATA=/volumeUSB1/usbshare/encrypted/
SOURCE=/volume2/snapshots/
BACKUP=/volumeUSB1/usbshare/backup_no_enc/

sudo mount -t ecryptfs $ENCDATA $BACKUP
# if your pc has enough memory
rsync -az -H --progress --delete --numeric-ids $SOURCE $BACKUP
# if your pc has not enough memory
# and folders are like daily.0/ daily.1/ ...  
#rsync -az -H --progress --delete --numeric-ids --include='daily.*/***' --exclude='*' $SOURCE $BACKUP
#rsync -az -H --progress --delete --numeric-ids --include='daily.6/***' --include='weekly.*/***' --exclude='*' $SOURCE $BACKUP
#rsync -az -H --progress --delete --numeric-ids --include='weekly.3/***' --include='monthly.*/***' --exclude='*' $SOURCE $BACKUP
#rsync -az -H --progress --delete --numeric-ids --include='daily.6/***' --include='weekly.3' --include='monthly.11/***' --exclude='*' $SOURCE $BACKUP
