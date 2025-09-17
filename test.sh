#!/usr/bin/env bash
if [ -z $# ]; then
	printf "It simply wasnt made for that!";
	exit 0;
fi
h=1
case $1 in
	--verbose)
		echo set verbose on!
		verbose=1
		echo $#
		echo $h
		;;
esac

