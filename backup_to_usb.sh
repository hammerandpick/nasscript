#!/bin/sh

# requirements: you have a usb drive mounted to the given mount points
# this drive is encrypted with ecryptfs

# 1. script will mount encypted data folder to a mount point
# 2. script will start a backup with rsync. the links are verified so you may safely copy a structre with multiple links to a file

ENCDATA=/volumeUSB1/usbshare/encrypted/
SOURCE=/volume2/snapshots/
BACKUP=/volumeUSB1/usbshare/backup_no_enc/

sudo mount -t ecryptfs $ENCDATA $BACKUP

# if your pc has not enough memory
# and folders are like daily.0/ daily.1/ ...

if [ $# -eq 0 ] || [ "$1" = "-d" ] || [ "$1" = "--daily" ] ; then
  echo "copy daily.*"
  rsync -az -H --progress --delete --numeric-ids --include='daily.*/***' --exclude='*' $SOURCE $BACKUP
  else echo "skip daily." 
fi

if [ $# -eq 0 ] || [ "$1" = "-w" ] || [ "$1" = "--weekly" ] ; then
  echo "copy weekly.*"
  rsync -az -H --progress --delete --numeric-ids --include='daily.6/***' --include='weekly.*/***' --exclude='*' $SOURCE $BACKUP
  else echo "skip weekly."
fi

if [ $# -eq 0 ] || [ "$1" = "-m" ] || [ "$1" = "--monthly" ] ; then
  echo "copy monthly.*"
  # ATTENTION refering to weekly (eg. in month ) may not work, since rsync will perform operation in alphabetical order
  rsync -az -H --progress --delete --numeric-ids --include='daily.6/***' --include='monthly.*/***' --exclude='*' $SOURCE $BACKUP
  else echo "skip monthly."
fi

if [ $# -eq 0 ] || [ "$1" = "-y" ] || [ "$1" = "--yearly" ] ; then
  echo "copy yearly.*"
  rsync -az -H --progress --delete --numeric-ids --include='daily.6/***' --include='weekly.3' --include='monthly.11/***' --include='yearly.*/***' --exclude='*' $SOURCE $BACKUP
  else echo "skip yearly."
fi

if [ "$1" = "-f" ] || [ "$1" = "--full" ] ; then
  echo "performing full copy."
  # if your pc has enough memory
  rsync -az -H --progress --delete --numeric-ids $SOURCE $BACKUP
  else "skipping full copy."
fi
