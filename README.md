# Directory Backup
this project helps the user to backup the directory after applying any changes or updates on any folder inside it

## Overview
The project is a backup directory where we can find 2 folders one for the source and the other for the backup.
When we create any folder inside the source, a folder is created with the date of applying this change in the backup folder.
There is a max limit for the updates can be initialized in the program if we reached this limit the oldbackup folders will be removed.

## Installation
-install ubuntu and virtualbox which is the enviroment of running the operating system 

-install make on ubuntu to run the make file that run the bash script
```bash
sudo apt install make
```
-make sure bash is installed
-make sure cronjob is installed

## Components
- backup.sh-> the script file
- Makefile -> the makefile that run the script
- backup-cron.sh -> the script that will be run by the cronjob
- Readme.md 

## Getting Started
1-open ubunto on the virtualbox.

2-open lab2 in the documents folder

3-open the terminal then call the make file that run the program

```bash
make
```
or
```bash
make all
```
or Run the script directly by writting this command in the terminal
```bash
./backupd.sh source backup 5 5
```
where 5 -> interval_secs, 5 -> max_backups

4-press ctrl+c to stop the program

## Usage
-The backup script backupd.sh will automatically backup the directory

-First we should sent the arguments to the script trought the following lines of codes:
```bash
if [ $# -ne 4 ]; then
  echo "usage : $0 src_dir backup_dir interval_secs max_backups"
  exit 1
fi  

src_dir=$1
backup_dir=$2
interval_secs=$3
max_backups=$4
```
-Then inside a while loop we do our logic

-Save the state of the current source folder ina text file called directory-info.new.txt

-check the diffrence between the directory-info.new and directory-info.last,if no changed happened nothing is done and if there is a change create a folder in the backup folder carrying the date of this change and copy all the changes occured on the source inside it
```bash
        #save the state of the current source
        ls -lR $src_dir > directory-info.new.txt

	# check diff
	diff directory-info.last.txt directory-info.new.txt
	if [ $? -eq 0 ]; then
	echo "No change"
	else
	echo "folder changed"
	current_time=$(date  "+%F-%H-%M-%S")
	mkdir $backup_dir/$current_time
	cp -r $src_dir $backup_dir/$current_time
```
-check the max limit for backups ,if it is reached delete the first backup folder
```bash
current_backups=$(ls $backup_dir | wc -l)
	while [ $current_backups -gt $max_backups ];
	do
		oldest_backup=$(ls $backup_dir | head -n 1)
		echo "Updating:removing old backup...!"
		rm -r $backup_dir/$oldest_backup
		current_backups=$(ls $backup_dir | wc -l)
	done
```
-concatunate the directory-info.new on the directory-info.last for the next iteration then sleep for interval of time
```bash
cat directory-info.new.txt > directory-info.last.txt
sleep $interval_secs
```
-Then write a make file that calls that script, it contains two target the first one check if there is a backup directory or not to create a one,while the second takes the parameters to call the script
```bash
all: create_backup_dir run_bash_script


create_backup_dir:
	@mkdir -p $(BACKUP_DIR)
			
   
run_bash_script:   
	@./$(SCRIPT) $(SRC_DIR) $(BACKUP_DIR) $(INTERVAL_SECS) $(MAX_BACKUPS)
```

## Configuration of cronjob

- open the terminal and write the following code to run the cronjob
```bash
crontab -e
```

- then select
```bash
/bin/nano  <-----easiest
```

- write the following cronjob expression if you want to run the backup every minuite
```bash
* * * * * /bin/sh /home/mohamedmorsy/Documents/lab2/backup-cron.sh
```

this will run the backup-cron.sh script every minuite which same as backupd.sh but modified by remoning the sleep interval_secs

## Example of cronjob expression

the following cronjob expression if you want to run the backup every 3rd Friday of the month at 12:31 am
```bash
31 0 15-21 * 5 /bin/sh /home/mohamedmorsy/Documents/lab2/backup-cron.sh
```


 
