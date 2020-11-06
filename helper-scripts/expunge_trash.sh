#!/bin/bash
# Path to mailcow-dockerized, e.g. /opt/mailcow-dockerized
cd ..

/usr/local/bin/docker-compose exec -T dovecot-mailcow doveadm expunge -A mailbox 'Trash' savedbefore 180d