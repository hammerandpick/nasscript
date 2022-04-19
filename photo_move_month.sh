#!/usr/bin/env bash

if ( ! getopts :ft opt); then
	echo "Usage: `basename $0` -t type -f folder [-r 300][-m 100][-v][-a] -h for help";
	exit $E_OPTERROR;
fi

TIMERANGE=300
MAXFILES=""
LOGFILE="/volume1/Bilder/copy_log_$(date "+%Y-%m").txt"
DESTPATH="/volume1/Bilder"
BASEPATH="/volume1/photo/$FOLDER"

while getopts :f:m:r:t:vh OPTION
do
	case $OPTION in
	r)  if ! [ "$OPTARG" -eq "$OPTARG" ] 2> /dev/null
		then
		    echo "-r use integers for range, (300 default)"
			exit 1
		else
			TIMERANGE=$OPTARG
		fi
		;;
	f)  FOLDER=$OPTARG
		;;
	m)  if ! [ "$OPTARG" -eq "$OPTARG" ] 2> /dev/null
	    then
			echo "-m use integers for range"
			exit 1
		else
			MAXFILES=" | head -n $OPTARG"
		fi
		;;

	t)  TYPE=$OPTARG
		;;
	v)  echo "only testing"
		VERBOSE=1
		;;
	h)  echo "usage `basename $0` [options]"
		echo "-f [] which folder should be moved? argument is folder name"
		echo "-h    show this help"
		echo "-m [] maximum nuber of files as parameter"
		echo "-r [] number of days (300 default) which should be kept as parameter"
		echo "-t [] which file type is to be moved? filename as argument"
		echo "-v    test mode. do nothing to file system"
		exit 1
		;;

#option error handling

	\?)
		echo "Invalid option: $OPTARG" >&2
		exit 1
        ;;
	:)
		echo "Option $OPTARG requires an argument." >&2
        exit 1
		;;
	esac
done

if [ ! $TYPE ]; then
	echo "filetype is missing"
	exit 1
fi

if [ ! $FOLDER ]; then
	echo "folder is missing"
	exit 1
fi

shopt -s nullglob
find  $BASEPATH -maxdepth 1 -iname "*.$TYPE" -mtime +$TIMERANGE -type f -print0 | while IFS= read -r -d '' file; do
	FILENAME="${file##*/}"
	YEAR=`date --date="@$(stat --format "%Y" "$BASEPATH/$FILENAME")" +"%Y"`
	MONTH=`date --date="@$(stat --format  "%Y" "$BASEPATH/$FILENAME")" +"%m"`
	DEST="$DESTPATH/$YEAR/$MONTH/$FOLDER"

	if [ ! -d "$DEST" ] && [ "$VERBOSE" != 1 ]; then
		echo "Creating folder $DEST"
		echo "Creating folder $DEST" >> $LOGFILE
		mkdir -p "$DEST"
	fi

	echo "$FILENAME is being moved to $DEST/$FILENAME"
	echo "$BASEPATH/$FILENAME;->;$DEST/$FILENAME;;" >>$LOGFILE
	
	if [ "$VERBOSE" != 1 ]; then
		mv "$BASEPATH/$FILENAME" "$DEST/$FILENAME"
	else
		echo "verbose mode"
	fi

done
