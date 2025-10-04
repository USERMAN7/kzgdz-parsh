#!/usr/bin/env bash
geometry="https://kzgdz.com/8-class/geometry-shinibekob-8-2018/u23-"
chemistry="https://kzgdz.com/8-class/himiya-ospanova-8-2018/v34-"
algebra="https://kzgdz.com/8-class/algebra-shinibekov-8-2018/u29-"
english="https://kzgdz.com/8-class/anglijskij-jazyk-excel-for-kazakhstan-grade-8-students-book-virdzhiniija-jevans-8-klass-2019/u173-ex-"
russian="https://kzgdz.com/8-class/russkij-jazyk-sabitova-8-klass-2018/u239-"
imangali="https://kzgdz.com/8-class/algebra-abylkasimova-8-2018/u7-"
physics="https://kzgdz.com/8-class/fizika-krongart-b-8-klass-2018/u169-"
output_dir="./"
cycle=0
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"
spinner() {
    local pid=$1
    local delay=0.08
    local sp='|/-\'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        local index=$((i % ${#sp}))
        printf "\r${GREEN}[%c] Downloading...${RESET}" "${sp:$index:1}"
        i=$((i+1))
        sleep "$delay"
    done

       }
download() {
	case $1 in
	loop)
		while [ "$result" -lt "$result2" ]; do
       		 	printf "\r${YELLOW}Downloading ${GREEN}${int_start}.$result${RESET}\n"
			wget -O "$result-tmp" "$book-${int_start}-$result" -q & pid=$!
			spinner "$pid"
			wait "$pid"
			status=$?
			if [[ $status != 0 ]]; then
				printf "\r${RED}Failed to download..${RESET}\n"
				rm "./$result-tmp" &>/dev/null
				exit 1
			fi
			url=$(grep "imgs.kzgdz.com" "$result"-tmp|awk -F'"' '{print $6}')
			url=$(echo "$url" | tr -s '[:space:]' ' ')
			rm "./$result-tmp"
			IFS=' ' read -r -a ur <<< "$url"
			cycle=0
			for img_url in "${ur[@]}"; do
				if [[ $cycle == 0 ]]; then
					wget -O "${output_dir}${bookn}-${int_start}-${result}.jpg" "$img_url" -q & pid=$!
					spinner "$pid"
					wait "$pid"
					status=$?
					if [[ $status != 0 ]]; then
						printf "\r${RED}Failed to download..${RESET}\n"
						exit 1
					fi
					printf "\r${GREEN}${output_dir}${bookn}-${int_start}-${result}.jpg was saved${RESET}\n"
				else
					wget -O "${output_dir}${bookn}-${int_start}-${result}-${cycle}.jpg" "$img_url" -q & pid=$!
					spinner "$pid"
					wait "$pid"
					status=$?
					if [[ $status != 0 ]]; then
						printf "\r${RED}Failed to download..${RESET}\n"
						exit 1
					fi
					printf "\r${GREEN}${output_dir}${bookn}-${int_start}-${result}-${cycle}.jpg was saved${RESET}\n"
				fi
					((cycle++))
				done
        		((result++))
		done;;

		*)
		ex="${ex//./-}" # converting "." to "."
		printf "\r${GREEN}Downloading from ${YELLOW}$book$ex${RESET}\n"
		wget -O "$ex-tmp" "$book-$ex" -q & pid=$! 
		spinner "$pid"
		wait "$pid"
		status=$?
		if [[ $status != 0 ]]; then
			printf "\r${RED}No such exercise exists..${RESET}\n"
			exit 1
		fi

		url=$(grep "imgs.kzgdz.com" "$ex"-tmp|awk -F'"' '{print $6}') 
		url=$(echo "$url" | tr -s '[:space:]' ' ')
		rm "./$ex-tmp" # removing temporary file to not use much space for no reason
		# also deleting in ./ directory because sometime downloading some non existient file can cause - in name which triggers "--help" in rm
		printf "\r${GREEN}Found img ${YELLOW}$url${RESET}\n"
		IFS=' ' read -r -a ur <<< "$url"
		for img_url in "${ur[@]}"; do
	    	if [[ $cycle == 0 ]]; then
		    wget -O "${output_dir}${bookn}-${ex}.jpg" "$img_url" -q &#>/dev/null|| { echo "failed to download $img_url"; exit 1; }
		    pid=$!
		    spinner "$pid"
		    wait "$pid"
		    status=$?
		    if [[ "$status" -eq 0 ]]; then 
	    	    printf "\r${GREEN}${bookn}-${ex}.jpg was saved${RESET}\n"
	    	    else
			    printf "\r${RED} Failed..${RESET}\n"
			    exit 1
		    fi
    	   		 else
	    		wget -O "${output_dir}${bookn}-${ex}-${cycle}.jpg" "$img_url" -q & pid=$!
			spinner "$pid"
			wait "$pid"
			status=$?
		    	if [[ "$status" -eq 0 ]]; then 
	    		printf "\r${GREEN}${bookn}-${ex}-${cycle}.jpg was saved${RESET}\n"
			else
				printf "\r${RED}Failed..${RESET}\n"
				exit 1
			fi
	    	fi
	    		((cycle++))
    		done;;
esac
}
if [ -n "$1" ]; then
	case $1 in 
		--help|-h) # help menu currently there are no some commands that are here -_-
			# be added
			printf "\r--help,-h   for this help menu\n"
			printf "\r--version,-V	to print current version\n"
			printf  "\r--out-dir,-O   to specify the output directory, \"./main-parser.sh -O /sdcard/Pictures\" for example\n"
			printf "\r--class,--grade,-c,-g	to specify in which grade you're in. Arguments needs to passed as just integers no things like \"fifth class\". \n"
			printf  "\r--book,-b   note always needs to be first argument, example of use \"./main-parser.sh --book chemistry\" then exercise needs to be passed see below\n"
			printf  "\r--exercise,-e   needs to be passed after book arg see above for explanation. can be passed like --exercise 1.4 or -e 1.4 for some books like chemistry\n	 you need to pass paragraph first then exercise use -e 3.7 \n"
			printf "\r--loop,-l	needs to passed after book similar to the exercise flag.\n	1st argument after loop needs to be starting point then an end\n"
			printf "	example you can use it by typing \" ./main-parse.sh --book algebra -e 1.5 -O /sdcard/Pictures/\"\n	example of loop \"./main-parse.sh -b Imangali -l 4.20 4.50 -O /sdcard/Pictures/\"\n"
			exit 0
			;;
		--class|--grade|-c|-g)
			case $2 in
				7)
					class="7";;
				8)
					class="8";;
				9)
					class="9";;
				*)
					printf "Only 7,8,9 grades are supported right now :(\n"
					exit 1;;
			esac;;
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
				english)
					book="$english"
					bookn="English";;
				russian)
					book="$russian"
					bookn="Russian";;
				physics)
					book="$physics"
					bookn="Physics";;
				imangali)
					book="$imangali"
					bookn="Imangali";;
				*)
					printf "You can put here algebra,geometry,chemistry,chemistry-z,russian,physics. Failed:%s '$2' \n" >&2
					exit 1;;
			esac
			;; # This section aside from --version is just a short documentation
			# Of itself
		--exercise|-e)
			echo "Needs to be run as third argument after --book"
			exit 1;;
		--out-dir|-O)
			echo "Can be run but not necesarry after --exercise as fifth arg"
			exit 1;;
		--version|-V)
			printf "kzgdz-parsh version v0.9-beta\nMade by USERMAN7\nDate 09.9.25/10.2.2025\nLicense GPLv2\n"
			exit 0;;

	esac
	case $3 in 
		--exercise|-e)
			if [[ -n $4 ]]; then
				ex=$(printf %s "$4") # putting $4 in ex var
				ex="${ex//./-}" # converting "." to "-"
				if [[ $2 == "english" ]]; then
					page_num="$4"
					task="$5"
					ex=$(grep "p_${page_num}:" $(pwd)/.books/8-english-excel/conf| cut -d: -f2 | tr ',' '\n' | grep -E "^${task}(-[0-9]+)?$")
				fi
			else
				printf "Pass exercise number\n" >&2 # If nothing was passed
				exit 1 # Exit with error code
			fi;;
		--loop|-l)
			if [[ -n $4 ]]; then # Loop is pretty much ex but just buffed
				start_ex=$(printf %s "$4") # Same thing, this is start ex
				end_ex=$(printf %s "$5") # Now this is end exercise
				int_start="${start_ex%%.*}" # Getting int var before dot, because bash cant do math with floats
				int_end="${end_ex%%.*}" # Same for end
				if [[ "$int_start" != "$int_end" ]]; then # I didn't even tried to make a logic for this.
					printf "Error first loop number MUST be same!\n" # Yeah
					exit 1;
				fi
				result="${start_ex#*.}" 
				result2="${end_ex#*.}"
				((result2++)) # Bumping result2 for 1 int because for loop looping until result is smaller that result2 so this needs to be bumped one time
			else
				printf "This is loop.\n" # No documentation :(
				exit 1
			fi;;
		esac
	case $5 in
		--out-dir|-O)
			if [ -d "$6" ]; then # Check if directory exists if so change output_dir from default "./" <-- inside project directory to custom one
				output_dir="$6"
			else
				printf "Not valid path:%s\n" "$6" >&2 # If check fails exit with error code.
				exit 1
				fi;;
	esac
	case $6 in
		--out-dir|-O)
			if [ -d "$7" ]; then # Making same thing because of new loop func
				output_dir="$7"
			else
				printf "Not valid path:%s\n" "$7" >&2
				exit 1
				fi;;
	esac

		if [[ -z $int_start ]]; then # If $int_start does not exist we know that "--loop" wasnt called or atleast failed
		download
		exit 0 
		else
		download loop # loop method
		exit 0 # Exiting to not continue code
		fi
fi
printf "\r${YELLOW}BETA only supported 8 grade. algebra,geometry,chemistry,russian,kazakh_literature,physics${RESET}\n"
printf "\r${YELLOW}Input the name of book:${RESET}"
read -r book
book="$(echo "$book"|tr '[:upper:]' '[:lower:]')" # converting upper case to lower case
if [ -n "$book" ]; then
	case $book in # All of logic is the same aside from chemistry
		algebra)
			book="$algebra"
			bookn="Algebra"
			printf "\r${YELLOW}Enter exercise:${RESET}"
			read -r ex;;
		geometry)
			book="$geometry"
			bookn="Geometry"
			printf "\r${YELLOW}Enter exercise:${RESET}"
			read -r ex;;
		chemistry)
			printf "\r${YELLOW}Do you have zadacha?:${RESET}"
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
			printf "\r${YELLOW}Enter paragraph number then exercise:${RESET}"
			read -r ex;;
		russian)
			book="$russian"
			bookn="Russian"
			printf "\r${YELLOW}Enter exercise number:${RESET}"
			read -r ex;;
		english)	
			book="$english"
			bookn="English"
			read -p  "Input page number: " page_num
			read -p  "Input exercise number: " task
			ex=$(grep "p_${page_num}:" $(pwd)/.books/8-english-excel/conf| cut -d: -f2 | tr ',' '\n' | grep -E "^${task}(-[0-9]+)?$");;
		physics)
			book="$physics"
			bookn="Physics"
			printf "\r${YELLOW}Enter exercise number:${RESET}"
			read -r ex;;
		imangali)
			book="$imangali"
			bookn="Imangali"
			printf "\r${YELLOW}Enter exercise number:${RESET}"
			read -r ex;;
		*)
			printf "\r${RED}Input any valid name${RESET}\n" >&2
			exit 1;;

		esac
else
	printf "\r${RED}Input book name next time${RESET}\n" >&2 # Better luck next time
	exit 1
fi
if [ -z "$ex" ]; then
	printf "\r${RED}You need to type something!${RESET}\n" >&2
	exit 1
fi
download
exit 0 # If you reached this that means my utility served it's purpose
