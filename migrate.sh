#!/bin/bash
set -e
All(){
Dir
for f in /$FROM/\@appstore/*
do 
	pkg="${f##*/}"
	echo $pkg
	/var/packages/$pkg/scripts/start-stop-status stop
	mv /$FROM/\@appstore/$pkg /$TO/\@appstore
	rm /var/packages/$pkg/target
	ln -s /$TO/\@appstore/$pkg /var/packages/$pkg/target
	ls -l /var/packages/$pkg
	/var/packages/$pkg/scripts/start-stop-status start
done
exit 1
}
Run(){
Dir
for f in /$FROM/\@appstore/*
do 
	pkg="${f##*/}"
	echo $pkg
	read -p "proceed?(y/n) " pcd
	if [ "$pcd" == "y" ]; then
		/var/packages/$pkg/scripts/start-stop-status stop
		mv /$FROM/\@appstore/$pkg /$TO/\@appstore
		rm /var/packages/$pkg/target
		ln -s /$TO/\@appstore/$pkg /var/packages/$pkg/target
		ls -l /var/packages/$pkg
		/var/packages/$pkg/scripts/start-stop-status start
	else
		break
	fi
done
}

FROM='NONE'
TO='NONE'

opts=":f:t:ah"
while getopts $opts option
do
	case ${option} in
		f) FROM=${OPTARG};;
		t) TO=${OPTARG};;
		h)
			Help
			;;
		a)
			All
			;;
		\? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
		:  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
		*  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
	esac
done

if [ $FROM != 'NONE' ] && [ $TO != 'NONE' ]; then
	Run
else
	Help
fi
