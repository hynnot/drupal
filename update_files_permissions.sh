#!/bin/bash

user="root"
group="www-data"
files_drupal_path="./sites/default/files"

echo "Changing ownership for all directories and files: chown -R "${user}":"${group}" ."
chown -R ${user}:${group} .

echo "Changing permissions for all directories to 750"
find . -type d -exec chmod u=rwx,g=rx,o= {} \;

echo "Changing permissions for all files to 640"
find . -type f -exec chmod u=rw,g=r,o= {} \;

echo "Changing permissions for all directories to 770"
find $files_drupal_path -type d -exec chmod ug=rwx,o= {} \;

echo "Changing permissions for all files to 640"
find $files_drupal_path -type f -exec chmod ug=rw,o= {} \;
