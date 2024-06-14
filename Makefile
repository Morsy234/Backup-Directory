# parameters
SRC_DIR := source
BACKUP_DIR:= backup
INTERVAL_SECS:= 5
MAX_BACKUPS:= 5

SCRIPT := backupd.sh


all: create_backup_dir run_bash_script


create_backup_dir:
	 @mkdir -p $(BACKUP_DIR)
	
		
   
run_bash_script:   
	@./$(SCRIPT) $(SRC_DIR) $(BACKUP_DIR) $(INTERVAL_SECS) $(MAX_BACKUPS)
