#! /bin/env bash

export $(cat .env)

if [[ ! -d $BACKUP_FOLDER ]]; then
BACKUP_FOLDER=$(mktemp -d)
fi

TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")
BACKUP="$BACKUP_FOLDER/$TIMESTAMP.sql"

docker exec -ti  priminf-database-1 mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $BACKUP

if [[ "$?" != "0" ]]; then
  echo "ERROR AL CREAR EL DUMP"
  exit 1
fi

echo "Backup guardado en $BACKUP"

command -v upload-backup

if [ "$?" == "0" ]; then
  upload-backup $BACKUP
else 
  echo "El comando 'upload-backup' no está definido. Backup local en $BACKUP"
fi
