#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
echo "BETA only supported 8 grade. algebra,geometry"
printf "Input the name of book:"
read -r book
if [ -z $book ]; then
	echo input something
	exit 1
fi
book="$(printf $book|tr '[:upper:]' '[:lower:]')" # converting upper case to lower case
if [ -n $book ]; then
	if [ $book == "algebra" ]; then
		book="$algebra"
		bookn="Algebra" # adds bookn var to identify which ex was downloaded in the end
	elif [ $book == "geometry" ]; then
		book="$geometry"
		bookn="Geometry"
	else
		echo "input geometry or algebra"
		exit 1
	fi
else
	echo "input book name next time"
	exit 1
fi
printf "input number of the exercise:"
read -r ex
ex="${ex//./-}" # converting "." to "."
echo "downloading from $book$ex"
wget -O "$ex-tmp" "$book-$ex" &>/dev/null || { echo "failed to download!"; exit 1; }
url=$(cat "$ex"-tmp|grep imgs.kzgdz.com|awk -F'"' '{print $6}') 
rm "./$ex-tmp" # removing temporary file to not use much space for no reason
# also deleting in ./ directory because sometime downloading some non existient file can cause - in name which triggers "--help" in rm
if [ -n $url ]; then # can be empty if some of commands fails
	echo "found img "$url" " 
else
	echo "not found.. exiting"
	exit 1
fi
wget -O "$bookn-$ex.jpg" "$url" &>/dev/null|| { echo "failed to download!"; exit 1; } # deleting output to have cleaner look
echo "saved $bookn-$ex.jpg" # saying out loud that file was downloaded because there's no output from wget
