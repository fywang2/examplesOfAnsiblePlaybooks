#!/bin/bash
HOST=localhost
USER=root
PASS=PASS
MYSQLIP=MYSQLIP
BACKUP_DIR=/opt/mysql/mysql_backup
DB=all_databases_${MYSQLIP}

mkdir -p $BACKUP_DIR
touch $BACKUP_DIR/mysql_backup.log

DATE=$(date +%F_%H-%M-%S)
BACKUP_NAME=$BACKUP_DIR/${DB}_${DATE}.sql.gz

echo >> $BACKUP_DIR/mysql_backup.log 
echo "$(date +%F_%H-%M-%S) mysql backup begin..." >> $BACKUP_DIR/mysql_backup.log 

if ! mysqldump -h$HOST -u$USER -p$PASS -A | gzip > $BACKUP_NAME 2>/dev/null; then
    echo "$BACKUP_NAME backup failure." >> $BACKUP_DIR/mysql_backup.log 
else     
    echo "$BACKUP_NAME backup success." >> $BACKUP_DIR/mysql_backup.log 
fi
echo "$(date +%F_%H-%M-%S) mysql backup end." >> $BACKUP_DIR/mysql_backup.log 

#仅保留三个备份文件，避免大量占用磁盘空间
ls -t $BACKUP_DIR/${DB}_* | sed -n '4,$p' | xargs -I {} rm -rf {} 
#日志仅保留200行，避免大量占用磁盘空间
tail -n 200 $BACKUP_DIR/mysql_backup.log > $BACKUP_DIR/mysql_backup.log.bak
tail -n 200 $BACKUP_DIR/mysql_backup.log.bak > $BACKUP_DIR/mysql_backup.log
