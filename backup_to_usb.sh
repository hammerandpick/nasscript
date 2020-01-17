#!/bin/sh

ENCDATA=/volumeUSB1/usbshare/encrypted/
SOURCE=/volume2/snapshots/
BACKUP=/volumeUSB1/usbshare/backup_no_enc/

sudo mount -t ecryptfs $ENCDATA $BACKUP
rsync -az -H --progress --delete --numeric-ids $SOURCE $BACKUP
