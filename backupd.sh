#bin/bash

if [ $# -ne 4 ]; then
  echo "Needs 4 argumtents: src_dir backup_dir interval_secs max_backups"
  exit 1
fi  

src_dir=$1
backup_dir=$2
interval_secs=$3
max_backups=$4

#Initialize directory-info.last.txt with the current state
ls -lR $src_dir > directory-info.last.txt

while [ true ];
do
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

	#cleanup old backups after reaching maximum backups
	current_backups=$(ls $backup_dir | wc -l)
	while [ $current_backups -gt $max_backups ];
	do
		oldest_backup=$(ls $backup_dir | head -n 1)
		echo "Updating:removing old backup...!"
		rm -r $backup_dir/$oldest_backup
		current_backups=$(ls $backup_dir | wc -l)
	done
		



fi
cat directory-info.new.txt > directory-info.last.txt
sleep $interval_secs
done
