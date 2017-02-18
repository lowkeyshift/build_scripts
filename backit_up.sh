#!/bin/bash
#
# PARAMETERS ./SCRIPT.sh [User] [domain or IP] [/path/to/source] [/path/to/backup/mount]


set -e -o pipefail

LOG_FILE=/var/log/backup.log
HOST=$1;
USER=$2;
SRC_PATH=$3;
DEST_PATH=$4;

echo " Event: Backing up ${SRC_PATH} to ${DEST_PATH} "

if [ ! -z "$DIR" ]; then

/usr/bin/rsync -harv --progress --log-file ${LOG_FILE} --stats --sparse --keep-dirlinks -v \
    --hard-links  --executability --delete-after -ax ${SRC_PATH} root@${HOST}:${DEST_PATH}

(ssh root@${HOST} "./create_zfs_snapshot.sh")

else
    echo "You cannot leave your paths blank!"
    echo "Example: PARAMETERS ./SCRIPT.sh [User] [domain or IP] [/path/to/source] [/path/to/backup/mount] "
fi

exit 0