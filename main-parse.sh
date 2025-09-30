#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/v34-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
russian="https://kzgdz.com/8-class/russkij-jazyk-sabitova-8-klass-2018/u239-"
imangali="https://kzgdz.com/8-class/algebra-abylkasimova-8-2018/u7-"
output_dir="./"
cycle=0
int=0
verbose=0
download() {
		ex="${ex//./-}" # converting "." to "."
		echo "Downloading from $book$ex"
		wget -O "$ex-tmp" "$book-$ex" &>/dev/null || { echo "failed to download!"; rm "./$ex-tmp"; exit 1; }
		url=$(grep "imgs.kzgdz.com" "$ex"-tmp|awk -F'"' '{print $6}') 
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
}
if [ -n "$1" ]; then
	case $1 in 
		--help|-h) # help menu currently there are no some commands that are here -_-
			# but they will be added
			printf "%s--help,-h   for this help menu\n"
			printf "%s--version,-V	to print current version\n"
			printf  "%s--out-dir,-O   to specify the output directory, \"./main-parser.sh -O /sdcard/Pictures\" for example\n"
			printf  "%s--interactive,-i   for interactive mode where you can type out which book and which exercise you want to download\n"
			printf  "%s--book,-b   note always needs to be first argument, example of use \"./main-parser.sh --book chemistry\" then exercise needs to be passed see below\n"
			printf  "%s--exercise,-e   needs to be passed after book arg see above for explanation. can be passed like --exercise 1.4 or -e 1.4 for some books like chemistry\n	 you need to pass paragraph first then exercise use -e 3.7 \n"
			printf "	example you can use it by typing \" ./main-parse.sh --book algebra -e 1.5 -O /sdcard/Pictures\" \n"
			exit 0
			;;
		--book|-b)
			case $2 in
				geometry)
					book="$geometry"
					bookn="Geometry";;
				chemistry)
					book="$chemistry"
					bookn="Chemistry";;
				chemistry-z)
					chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/z34-zadacha-"
					book="$chemistry"
					bookn="Chemistry-zadacha";;
				algebra)
					book="$algebra"
					bookn="Algebra";;
				russian)
					book="$russian"
					bookn="Russian";;
				imangali)
					book="$imangali"
					bookn="Imagali";;
				*)
					printf "You can put here algebra,geometry,chemistry,chemistry-z,russian. Failed:%s '$2' \n" >&2
					exit 1;;
			esac
			;;
		--exercise|-e)
			echo "Needs to be run as third argument after --book"
			exit 1;;
		--out-dir|-O)
			echo "Can be run but not necesarry after --exercise as fifth arg"
			exit 1;;
		--version|-V)
			printf "kzgdz-parsh version v0.6-beta\nMade by USERMAN7\nDate 0.9.29.2025\nLicense GPLv2\n"
			exit 0;;

	esac
	case $3 in 
		--exercise|-e)
			if [[ -n $4 ]]; then
				ex=$(printf %s "$4")
				ex="${ex//./-}" # converting "." to "-"
			else
				echo "Pass exercise number" >&2
				exit 1
			fi;;
	esac
	case $5 in
		--out-dir|-O)
			if [ -d "$6" ]; then
				output_dir="$6"
			else
				printf "Not valid path:%s\n" "$6" >&2
				exit 1
				fi;;
	esac
		if [[ "$verbose" == 1 ]]; then
		download verbose
		exit 0;
		else	
		download
		exit 0
		fi
fi
    echo "BETA only supported 8 grade. algebra,geometry,chemistry,russian,kazakh_literature"
printf "Input the name of book:"
read -r book
book="$(echo "$book"|tr '[:upper:]' '[:lower:]')" # converting upper case to lower case
if [ -n "$book" ]; then
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
			printf "Do you have zadacha?:"
			read -r zadacha
			case $zadacha in
				Y|y|yes|Yes)
				chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/z34-zadacha-"
				book="$chemistry"
				bookn="Chemistry-zadacha";;
				*)
				book="$chemistry"
				bookn="Chemistry";;
			esac
			printf "Enter paragraph number then exercise:"
			read -r ex;;
		russian)
			book="$russian"
			bookn="Russian"
			printf "Enter exercise number:"
			read -r ex;;
		imangali)
			book="$imangali"
			bookn="Imangali"
			printf "Enter exercise number:"
			read -r ex;;
		*)
			echo "Input any valid name" >&2
			exit 1;;

		esac
else
	printf "input book name next time\n" >&2
	exit 1
fi
if [ -z "$ex" ]; then
	printf "You need to type something!\n" >&2
	exit 1
fi
download
exit 0
