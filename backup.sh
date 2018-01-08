#!/bin/bash

source mailcow.conf
source backup/backup.conf

#Einbinden der localen Backupkonfiguration die nicht überschrieben wird.
if [[ -f "backup/backup.local.conf" ]]; then
	source backup/backup.local.conf
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
	mv $BACKUPDIR/backup_* $ARCHIVDIR/ 
}

function del_live_backup {
	rm $BACKUPDIR/backup_*
}

function del_old_backups {

	find $ARCHIVDIR -mtime +$ARCHIV_HISTORY -exec rm {} \;

}

# MySQL Dump erstellen
function backup_mysql {
	docker-compose exec -T mysql-mailcow mysqldump --default-character-set=utf8mb4 -u${DBUSER} -p${DBPASS} ${DBNAME} > backup_${DBNAME}_${DATE}.sql
    mv backup_${DBNAME}_${DATE}.sql $BACKUPDIR/backup_${DBNAME}_${DATE}.sql
	echo "MySQL Backup erfolgreich abgeschlossen."	
}

# Mailboxen Packen 
function backup_maildir {
	docker run --rm -i -v $(docker inspect --format '{{ range .Mounts }}{{ if eq .Destination "/var/vmail" }}{{ .Name }}{{ end }}{{ end }}' $(docker-compose ps -q dovecot-mailcow)):/vmail -v ${PWD}:/backup debian:stretch-slim tar cvfz /backup/backup_vmail.tar.gz /vmail
	mv backup_vmail.tar.gz $BACKUPDIR/backup_vmail_${DATE}.tar.gz
	echo "Mailboxen erfolgreich gesichert."	
}

check_structure
if [[ $ENABLE_ARCHIV == "yes" ]]; then 
	archiv_move
    del_old_backups
else 
	del_live_backup
fi
backup_mysql
backup_maildir


