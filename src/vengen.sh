#!/bin/bash

# ========================================
# Author: Alexis Rodriguez
# Date: 18 April 2020
# Vengen is a wrapper for msfvenom. It's 
# purpose is to make generating payloads
# with msfvenom easier and quicker.
# ========================================

prompt_main() {
	read -p $'\e[31m [1] Reverse (2) Bind |3| Exit :\e[0m ' CHOSE
	# Checking if input is integer
	# If its not an integer, send the error to /dev/null
	# and recall the current function
	if ! [ $CHOSE -eq $CHOSE ] 2>/dev/null
	then
		echo -e "\e[34mInvalid option\e[0m -:> $CHOSE"
		prompt_main
	else
		if [ $CHOSE -eq 1 ]; then
			reverse_payload
		elif [ $CHOSE -eq 2 ]; then
			bind_payload
		elif [ $CHOSE -eq 3 ]; then
			echo "Exit Success"
			exit 0
		else
			echo -e "\e[34mInvalid option\e[0m -:> $CHOSE"
			prompt_main
		fi
	fi
}

# Generate reverse shell payload
reverse_payload() {
	read -p $'\e[31mLHOST:\e[0m ' LOCALIP
	read -p $'\e[31mLPORT:\e[0m ' LOCALPORT
	read -p $'\e[31mPAYLOAD:\e[0m ' PAYLOAD
	read -p $'\e[31mFORMAT:\e[0m ' FORMAT
	echo -ne $'Add more options? \e[31mY/n\e[0m '
	read MOREOPTS

	MOREOPTS=$(echo $MOREOPTS |tr '[:upper:]' '[:lower:]')
	if [ $MOREOPTS = "y" ]; then
		more_options LHOST=$LOCALIP LPORT=$LOCALPORT $PAYLOAD $FORMAT
	fi

	read -p $'Save output to file? \e[31mY/n\e[0m' TOFILE
	TOFILE=$(echo $TOFILE |tr '[:upper:]' '[:lower:]')
	if [ $TOFILE = "y" ]; then
		to_file $LOCALIP $LOCALPORT $PAYLOAD $FORMAT
	else
		execute -p $PAYLOAD LHOST=$LOCALIP LPORT=$LOCALPORT -f $FORMAT
	fi
}

# Generate bind shell payload
bind_payload() {
	read -p $'\e[31mRHOST:\e[0m ' REMOTEIP
	read -p $'\e[31mRPORT:\e[0m ' REMOTEPORT
	read -p $'\e[31mPAYLOAD:\e[0m ' PAYLOAD
	read -p $'\e[31mFORMAT:\e[0m ' FORMAT
	echo -ne $'Add more options? \e[31mY/n\e[0m '
	read MOREOPTS

	MOREOPTS=$(echo $MOREOPTS | tr '[:upper:]' '[:lower:]')
	if [ $MOREOPTS = "y" ]; then
		more_options RHOST=$REMOTEIP RPORT=$REMOTEPORT $PAYLOAD $FORMAT
	fi

	read -p $'Save output to file? \e[31mY/n\e[0m' TOFILE
	TOFILE=$(echo $TOFILE |tr '[:upper:]' '[:lower:]')
	if [ $TOFILE = "y" ]; then
		to_file $LOCALIP $LOCALPORT $PAYLOAD $FORMAT
	else
		execute -p $PAYLOAD LHOST=$REMOTEIP LPORT=$REMOTEPORT -f $FORMAT
	fi
}

# Gets file name to write and executes msfvenom 
# command with file output option
to_file() {
	read -p $'\e[34mEnter File Name:\e[0m ' FILENAME
	if [ -e FILENAME ]; then
		echo "File already exits!"
		read -p $'Overwrite file? \e[31mY/n\e[0m' OVERWRITE
		OVERWRITE=$(echo $OVERWRITE |tr '[:upper:]' '[:lower:]')
		if [ $OVERWRITE = "y"]; then
			execute -p $3 LHOST=$1 LPORT=$2 -f $4 -o ${FILENAME}
		else
			exit 0
		fi
	else
		execute -p $3 LHOST=$1 LPORT=$2 -f $4 -o ${FILENAME}
	fi
}

# Shows other options to enter for msfvenom
more_options() {
	array=()
	echo -e "\nOptions:
	[e] Encoder
	[a] Architecture
	[p] Platform
	[b] Bad Characters
	"
	echo -ne "\e[31mEnter your options seperated by spaces:\e[0m "
	read -a options
	for letter in ${options[@]}; do
		if [ $letter = "e" ]; then
			read -p $'ENCODER: ' ENCODER
			array+=("-e" "$ENCODER")
		elif [ $letter = "a" ]; then
			read -p $'ARCHITECTURE: ' ARCHITECTURE
			array+=("-e" "$ARCHITECTURE")
		elif [ $letter = "p" ]; then
			read -p $'PLATFORM: ' PLATFORM
			array+=("-e" "$PLATFORM")
		elif [ $letter = "b" ]; then
			read -p $'BAD CHARACTERS' BADCHARS
			array+=("-e" "$BADCHARS")
		else
			echo -e "\e[34mInvalid Option!\e[0m\n"
			more_options $1 $2 $3 $4
		fi
	done

	execute $1 $2 $3 $4 "$@"
}

# Will execute the final msfvenom command
execute() {
	msfvenom "$@"
	exit 0
}

# Print program name
prog_name() {
	echo " -------------------------------"
	echo -e "|            \e[32mVengen\e[0m             |"
	echo -e "| 	 by: \e[33mBinexisHATT\e[0m        |"
	echo " -------------------------------"
}

main() {
	prog_name
	prompt_main
}

main