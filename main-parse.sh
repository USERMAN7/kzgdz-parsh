#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
echo "BETA only supported 8 grade. algebra,geometry"
printf "Input the name of book:"
read -r book
if [ -n $book ]; then
	if [ $book == "algebra" ]; then
		book="$algebra"
		bookn="Algebra"
	elif [ $book == "geometry" ]; then
		book="$geometry"
		bookn="Geometry"
	fi
fi
printf "input number of the exercise:"
read -r ex
#ex="${ex//./-}"
echo "downloading from https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-$ex"
wget -O "$ex-tmp" "$book-$ex"|| { echo "failed to download!"; exit 1; }
url=$(cat "$ex"-tmp|grep imgs.kzgdz.com|gawk -F'"' '{print $6}')
rm "$ex-tmp"
wget -O "$bookn-$ex.jpg" "$url" || { echo "failed to download!"; exit 1; }
