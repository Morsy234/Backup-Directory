#!bin/sh



src_dir=/home/mohamedmorsy/Documents/lab2/source
backup_dir=/home/mohamedmorsy/Documents/lab2/backup
max_backups=5
current_state=/home/mohamedmorsy/Documents/lab2/directory-info.new.txt
last_state=/home/mohamedmorsy/Documents/lab2/directory-info.last.txt


#Function to compare directory structures
function are_directories_equal {
    diff -r "$1" "$2"
    return $?
}

#save the state of the current source
ls -lR $src_dir > $current_state

# check diff
if are_directories_equal $last_state $current_state; then
echo "No change"
else
echo "folder changed"
current_time=$(date  "+%F-%H-%M-%S")
mkdir -p $backup_dir/$current_time
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
cat $current_state > $last_state

