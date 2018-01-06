#!/bin/bash

source mailcow.conf
source ${PWD}/backup/backup.conf
source ${PWD}/backup/backup.local.conf

DATE=$(date +"%Y%m%d_%H%M%S")

function check_structure {
	
	if (!is_dir($BACKUPDIR)) {
		mkdir ($BACKUPDIR);
		echo "Backup Verzeichnis angelegt."
	} 

	if (!is_dir($ARCHIVDIR)) {
		mkdir ($ARCHIVDIR);
		echo "Backup Archiv Verzeichnis angelegt."
	}

}

function archiv_move {
	mv $BACKUPDIR/backup_* $ARCHIVDIR/
}

function backup_mysql {

	docker-compose exec -T mysql-mailcow mysqldump --default-character-set=utf8mb4 -u${DBUSER} -p${DBPASS} ${DBNAME} > backup_${DBNAME}_${DATE}.sql
    mv backup_${DBNAME}_${DATE}.sql $BACKUPDIR/backup_${DBNAME}_${DATE}.sql
	echo "MySQL Backup erfolgreich abgeschlossen."	
}

function backup_maildir {

	docker run --rm -i -v $(docker inspect --format '{{ range .Mounts }}{{ if eq .Destination "/var/vmail" }}{{ .Name }}{{ end }}{{ end }}' $(docker-compose ps -q dovecot-mailcow)):/vmail -v ${PWD}:/backup debian:stretch-slim tar cvfz /backup/backup_vmail.tar.gz /vmail
	mv backup_vmail.tar.gz $BACKUPDIR/backup_vmail_${DATE}.tar.gz
	echo "MySQL Backup erfolgreich abgeschlossen."	
}




cd ${PWD}

check_structure
archiv_move
backup_mysql
backup_maildir


