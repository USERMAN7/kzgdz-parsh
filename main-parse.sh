#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/v34-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
english="https://kzgdz.com/8-class/anglijskij-jazyk-excel-for-kazakhstan-grade-8-students-book-virdzhiniija-jevans-8-klass-2019/u173-ex" 
output_dir="./"
cycle=0
verbose=0
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
			echo "--verbose,-v	sets verbose mode on by togling one variable"
			exit 0
			;;
		--interactive|-i) # what do i even code here bruh
			;;
		--verbose|-v)
			printf "Verbose mode set on!\n"
			verbose=1;;
		--book|-b)
			case $2 in
				geometry)
					book="$geometry"
					bookn="Geometry";;
				chemistry)
					book="$chemistry"
					bookn="Chemistry";;
				algebra)
					book="$algebra"
					bookn="Algebra";;
				english)
					book="$english"
					bookn="English";; # Testing!
				*)
					echo "you can put here algebra,geometry,chemistry. Failed:$2" >&2
					exit 1;;
			esac
			;;
		--exercise|-e)
			echo "Needs to be run as third argument after --book"
			exit 1;;
		--out-dir|-O)
			echo "Can be run but not necesarry after --exercise as fifth arg"
			exit 1;;
	esac
	case $3 in 
		--exercise|-e)
			if [[ -n $4 ]]; then
				ex=$(echo $4)
				ex="${ex//./-}" # converting "." to "-"
			else
				echo "Pass exercise number" >&2
				exit 1
			fi;;
		*)
			echo "You must pass something here" >&2
			exit 1;;
	esac
	case $5 in
		--out-dir|-O)
			if [ -d $6 ]; then
				output_dir="$6"
			else
				echo "Not valid path:"$6"" >&2
				exit 1
			fi;;
	esac

		wget -O "${output_dir}${ex}-tmp" "$book-$ex" &>/dev/null|| {
			echo "Failed to download url:$book-$ex";
			rm "${output_dir}$ex-tmp";
			exit 1; }
		url=$(grep "imgs.kzgdz.com" ${output_dir}$ex-tmp|awk -F'"' '{print $6}')
		url=$(printf "$url" | tr -s '[:space:]' ' ')
		rm "${output_dir}${ex}-tmp"
		IFS=' ' read -r -a ur <<< "$url"
		for img_url in "${ur[@]}"; do
		if [[ $cycle == 0 ]]; then
		wget -O "${output_dir}${bookn}-${ex}.jpg" "$img_url" &>/dev/null|| {
			echo "failed to download $img_url";
			exit 1; 
		}
		echo "${bookn}-$ex.jpg was saved"
		else
		wget -O "${output_dir}${bookn}-${ex}-${cycle}.jpg" "$img_url" &>/dev/null|| {
			echo "failed to download $img_url";
			exit 1;
		}
		printf "${bookn}-${ex}-${cycle}.jpg was saved\n"
		fi
		((cycle++))
	done
	exit 0
else
	echo "No arguments were supplied defaulting to --interactive,-i"
fi

    echo "BETA only supported 8 grade. algebra,geometry,chemistry,(english testing)"
printf "Input the name of book:"
read -r book
book="$(echo $book|tr '[:upper:]' '[:lower:]')" # converting upper case to lower case
if [ -n $book ]; then
	case $book in
		algebra)
			book="$algebra"
			bookn="Algebra"
			printf "Enter exercise:"
			read -r ex;;
		geometry)
			book="$geometry"
			bookn="Geometry"
			printf "Enter exercise:"
			read -r ex;;
		chemistry)
			book="$chemistry"
			bookn="Chemistry"
			printf "Enter paragraph number then exercise:"
			read -r ex;;
		english)
			book="$english"
			bookn="English"
			printf "Enter exercise then how many times it was in the book:"
			read -r ex;;
		*)
			echo "Input any valid name" >&2
			exit 1;;
		esac
else
	echo "input book name next time" >&2
	exit 1
fi

ex="${ex//./-}" # converting "." to "."
echo "Downloading from $book$ex"
wget -O "$ex-tmp" "$book-$ex" &>/dev/null || { echo "failed to download!"; rm "./$ex-tmp"; exit 1; }
url=$(grep "imgs.kzgdz.com" $ex-tmp|awk -F'"' '{print $6}') 
url=$(echo "$url" | tr -s '[:space:]' ' ')
rm "./$ex-tmp" # removing temporary file to not use much space for no reason
# also deleting in ./ directory because sometime downloading some non existient file can cause - in name which triggers "--help" in rm
echo "Found img $url"
IFS=' ' read -r -a ur <<< "$url"
for img_url in "${ur[@]}"; do
	    if [[ $cycle == 0 ]]; then
		    wget -O "${output_dir}${bookn}-${ex}.jpg" "$img_url" &>/dev/null|| { echo "failed to download $img_url"; exit 1; }
	    	    echo "${bookn}-${ex}.jpg was saved"
    	    else
	    	wget -O "${output_dir}${bookn}-${ex}-${cycle}.jpg" "$img_url" &>/dev/null|| { echo "failed to download $img_url"; exit 1; }
	    	echo "${bookn}-${ex}-${cycle}.jpg was saved"
	    fi
	    ((cycle++))
done
