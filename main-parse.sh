#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/v34-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
english="https://example.com" # dummy
output_dir="./"
if [ -n "$1" ]; then
	case $1 in 
		--help|-h) # help menu currently there are no some commands that are here -_-
			# but they will be added
			echo "--help,-h	 for this help menu"
			echo "--out-dir,-O	 to specify the output directory, \"./main-parser.sh -O /sdcard/Pictures\" for example"
			echo "--interactive,-i	for interactive mode where you can type out which book and which exercise you want to download"
			echo "--book,-b	note always needs to be first argument, example of use \"./main-parser.sh --book chemistry\" then exercise needs to be passed see below"
			echo "--exercise,-e	needs to be passed after book arg see above for explanation. can be passed like --exercise 1.4 or -e 1.4 for some books like chemistry you need to pass paragraph first then exercise use -e 3.7 "
			echo "		example you can use it by typing \" ./main-parse.sh --book algebra -e 1.5 -O /sdcard/Pictures\" "
			exit 0
			;;
		--interactive|-i) # what do i even code here bruh
			;;
		--book|-b)
			case $2 in
				geometry)
					book="$geometry"
					bookn="Geometry"
					;;
				chemistry)
					book="$chemistry"
					bookn="Chemistry"
					;;
				algebra)
					book="$algebra"
					bookn="Algebra"
					;;
				english)
					book="$english"
					bookn="English" # dummy
					;;
				*)
					echo "you can put here algebra,geometry,chemistry. Failed:$2" >&2
					exit 1
					;;
			esac
			;;
		--exercise|-e)
			echo "Needs to be run as third argument after --book"
			exit 1
			;;
		--out-dir|-O)
			echo "Can be run but not necesarry after --exercise as fifth arg"
			exit 1
			;;
	esac
	case $3 in 
		--exercise|-e)
			if [[ -n $4 ]]; then
				ex=$(echo $4)
				ex="${ex//./-}" # converting "." to "-"
			else
				echo "Pass exercise number" >&2
				exit 1
			fi
			;;
		*)
			echo "You must pass something here" >&2
			exit 1
	esac
	case $5 in
		--out-dir|-O)
			if [ -d $6 ]; then
				output_dir="$6"
			else
				echo "Not valid path:"$6"" >&2
				exit 1
			fi
			;;
	esac

		wget -O "${output_dir}${ex}-tmp" "$book-$ex" &>/dev/null|| {
			echo "Failed to download url:$book-$ex";
			exit 1; }
		url=$(cat "$ex"-tmp|grep imgs.kzgdz.com|awk -F'"' '{print $6}') 
		url=$(echo "$url" | tr -s '[:space:]' ' ')
		rm "${output_dir}${ex}-tmp"
		IFS=' ' read -r -a ur <<< "$url"
		cycle=0
		for img_url in "${ur[@]}"; do
		if [[ $cycle == 0 ]]; then
		wget -O "${output_dir}${bookn}-${ex}.jpg" "$img_url" &>/dev/null|| {
			echo "failed to download $img_url";
			exit 1; 
		}

		else
		wget -O "${output_dir}${bookn}-${ex}-${cycle}.jpg" "$img_url" || {
			echo "failed to download $img_url";
			exit 1;
		}

		fi
		echo "${bookn}-${ex}-${cycle}.jpg was saved"
		((cycle++))
	done
	exit 0
else
	echo "No arguments were supplied defaulting to --interactive,-i"
fi

while [ $# -gt 0 ]; do
	  echo "Argument: $1"
	    shift
    done
echo "BETA only supported 8 grade. algebra,geometry,chemistry"
printf "Input the name of book:"
read -r book
book="$(printf $book|tr '[:upper:]' '[:lower:]')" # converting upper case to lower case
if [ -n $book ]; then
	if [ $book == "algebra" ]; then
		book="$algebra"
		bookn="Algebra" # adds bookn var to identify which ex was downloaded in the end
	elif [ $book == "geometry" ]; then
		book="$geometry"
		bookn="Geometry"
	elif [ $book == "chemistry" ]; then
		book="$chemistry"
		bookn="Chemistry"
	else 
		echo "input geometry,algebra or chemistry" >&2
		exit 1	
	fi
else
	echo "input book name next time" >&2
	exit 1
fi
if [ $book != "$chemistry" ]; then
printf "input number of the exercise:"
read -r ex
	if [ -z $ex ]; then
	echo "input something" >&2
	exit 1
	fi
else
	printf "Input number of paragrapth then exercise:"
	read -r ex
	if [ -z $ex ]; then
		echo "input something" >&2
		exit 1
	fi
fi
ex="${ex//./-}" # converting "." to "."
echo "Downloading from $book$ex"
wget -O "$ex-tmp" "$book-$ex" &>/dev/null || { echo "failed to download!"; exit 1; }
url=$(cat "$ex"-tmp|grep imgs.kzgdz.com|awk -F'"' '{print $6}') 
url=$(echo "$url" | tr -s '[:space:]' ' ')
rm "./$ex-tmp" # removing temporary file to not use much space for no reason
# also deleting in ./ directory because sometime downloading some non existient file can cause - in name which triggers "--help" in rm
echo "Found img $url"
IFS=' ' read -r -a ur <<< "$url"
cycle=0
for img_url in "${ur[@]}"; do
	    if [[ $cycle == 0 ]]; then
		    wget -O "${output_dir}${bookn}-${ex}.jpg" "$img_url" &>/dev/null|| { echo "failed to download $img_url"; exit 1; }
    	    else
	    	wget -O "${output_dir}${bookn}-${ex}-${cycle}.jpg" "$img_url" &>/dev/null|| { echo "failed to download $img_url"; exit 1; }
	    fi
	    echo "${bookn}-${ex}-${cycle}.jpg was saved"
	    ((cycle++))
done
#wget -O "$bookn-$ex.jpg" "$url" &>/dev/null|| { echo "failed to download!"; exit 1; } # deleting output to have cleaner look
#echo "saved $bookn-$ex.jpg" # saying out loud that file was downloaded because there's no output from wgefor url in $urls; do
