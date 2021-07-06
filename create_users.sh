print_last_result()
{
	if [ $? -eq 0 ]
	then
		echo -e "  \033[32mOK\033[0m"
	else
		echo  -e "  \033[31mERROR\033[0m"
	fi
}

func()
{
	user=$1
	echo -n "creating user $user..."
	adduser --disabled-password --gecos "$user FTP user" --shell /usr/sbin/nologin --add_extra_groups $user
	print_last_result

	echo -n "setting password for $user..."
	echo $user:ftp4$user | chpasswd -c SHA512
	print_last_result
	
	echo
}

if [ ! $# -eq 1 ]
then
	echo "usage: $0 <file>"
	echo -e "   \033[1m<file>\033[0m  text file with one by line user names to create"
	exit
fi 

cat $1 | while read line
do
	line=`echo $line | sed "s/#.*//g"`
	if [ $line ] 	
	then
		func $line
	fi
done
