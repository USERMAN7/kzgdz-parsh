#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
echo "BETA, only supported Geometry 8 grade."
echo "For example if you're looking for exercise 2.30 you should type "2-30" that is correct syntax"
echo "input number of the exercise:"
read -r ex
echo "downloading from https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-$ex"
wget -O "$ex-tmp" "$geometry$ex"|| { echo "failed to download!"; exit 1; }
url=$(cat $ex-tmp|grep imgs.kzgdz.com|gawk -F'"' '{print $6}')
rm "$ex-tmp"
wget -O "Geometry-$ex.jpg" $url
