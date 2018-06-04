#!/bin/bash

source mailcow.conf
source backup.conf

#Einbinden der localen Backupkonfiguration die nicht überschrieben wird.
if [[ -f "backup.local.conf" ]]; then
	source backup.local.conf
fi

DATE=$(date +"%Y%m%d_%H%M%S")

function check_structure {

	if [[ -d $BACKUPDIR ]]; then
		echo "Das angegebene Backup Verzeichnis: " $BACKUPDIR
	else 
		mkdir $BACKUPDIR
	fi

	if [[ -d $ARCHIVDIR ]]; then
		echo "Das angegebene Archiv Verzeichnis: " $ARCHIVDIR
	else 
		mkdir $ARCHIVDIR
	fi
	

}

function archiv_move {
	mv $BACKUPDIR/mailcow* $ARCHIVDIR/ 
}

function del_live_backup {
	rm $BACKUPDIR/mailcow* -R
}

function del_old_backups {
	find $ARCHIVDIR -mtime +$ARCHIV_HISTORY -exec rm {} \;
}

function backup_all {
    BACKUP_LOCATION=$BACKUPDIR helper-scripts/backup_and_restore.sh backup all
}

check_structure
if [[ $ENABLE_ARCHIV == "yes" ]]; then 
	archiv_move
    del_old_backups
else 
	del_live_backup
fi
backup_all


