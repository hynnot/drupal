#!/bin/bash

SERVER_FROM=$1
SERVER_TO=$2

PATH_WEB_FOLDER=/srv/www-drupal
PATH_DRUPAL_ROOT=/srv/www-drupal/drupal-7.x
PATH_BACKUPS=/srv/www-drupal/backups

DATABASE=drupaldb
USER_DATABASE=drupaldbuser
PASSWORD_DATABASE=??????

EXT=tar.gz
DATE=$(date +"%d-%m-%y_%H-%M")

# ACTIONS IN FROM SERVER
echo "\nCREATE BACKUP:"
echo $PASSWORD_DATABASE | ssh root@$SERVER_FROM drush -r $PATH_DRUPAL_ROOT archive-dump --destination=$PATH_BACKUPS/$SERVER_FROM-$DATE.$EXT --overwrite
echo "\nDOWNLOAD BACKUP:"
scp root@$SERVER_FROM:$PATH_BACKUPS/$SERVER_FROM-$DATE.$EXT .

# ACTIONS IN TO
echo "\nSEND BACKUP:"
scp $SERVER_FROM-$DATE.$EXT root@$SERVER_TO:$PATH_WEB_FOLDER/
echo "\nIMPORT BACKUP:"
ssh root@$SERVER_TO mv $PATH_WEB_FOLDER/drupal-7.x $PATH_BACKUPS/drupal-7.x_$DATE
# Tenemos que poner la PASSWORD DE LA DATABASE A MANO!
ssh root@$SERVER_TO drush archive-restore $PATH_WEB_FOLDER/$SERVER_FROM-$DATE.$EXT --destination=$PATH_DRUPAL_ROOT --db-url=pgsql://$USER_DATABASE:$PASSWORD_DATABASE@localhost/$DATABASE --overwrite
