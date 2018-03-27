#!/bin/sh

function help_text() {
	echo 
	echo "---------------------------------------------------"
	echo "Availabe Commands:"
	echo "---------------------------------------------------"
	echo "setup: Run this command before you use the program."
	echo "alias: Run this command in a directory to set an alias for that directory to be used with goto."
	echo "list: Run this command to view all recorded aliases."
	echo "goto: Run this command to access a directory through its alias from anywhere."
	echo "back: Run this command to return to the last directory accessed through dmover."
	echo "run-from: Run this command to execute an arbitrary shell command in a directory of your choosing."
	echo
}

case "$1" in
	# Setup: Create a
	# Cause .bash_profile to load .dmoverrc list of aliases
	# Create an alias in .bash_profile that reloads .bash_profile after opening it
	"setup")
		if [ ! -f ~/.dmoverrc ]; then
			echo '#!/bin/sh' >> ~/.dmoverrc
			chmod +x ~/.dmoverrc
			echo "~/.dmoverrc" >> ~/.bash_profile
			echo "Setup is complete."
			echo "Type 'source .bash_profile' in the command line and you're good to go!"
		else
			echo "You are already set up and good to go!"
		fi
		;;
	"alias")
		if [ -z "$2" ]; then
			echo "You must state the name of the alias."
			echo "Example Usage: dmover alias ALIAS_NAME"
			exit 1
		fi
		echo "$2:$(pwd)" >> .dmoverrc
		echo "Alias for $(pwd) set to $2."
		;;
	"list")
		if [ ! -f ".dmoverrc" ]; then
			echo "There aren't any aliases set. Please use the alias command first."
			exit 1
		fi
		echo
		echo "---------------------------------------------------"
		echo "Recorded Aliases"
		echo "---------------------------------------------------"
		while read -r line; do
			echo "$line"
		done < ".dmoverrc"
		echo
		;;
	"goto")
		if [ -z "$2" ]; then
			echo "You must state the alias name or path to traverse to."
			echo "Example Usage 1: dmover goto ALIAS_NAME"
			echo "Example Usage 2: dmover goto /home/dev/code/project1"
			exit 1
		fi
		if [ -d "$2" ]; then
			pushd "$2"
			exit 0
		fi
		if [ ! -f ".dmoverrc" ]; then
			echo "There aren't any aliases set. Please use the alias command first."
			exit 1
		fi
		while read -r line; do
			ALIAS_NAME="$(echo \"$line\" | cut -d ':' -f1)"
			ADDRESS="$(echo \"$line\" | cut -d ':' -f2)"
			if [ "$2" = "$ALIAS_NAME" ]; then
				pushd "$ADDRESS" 1>/dev/null 2>/dev/null
				exit 0
			fi
		done < ".dmoverrc"
		echo "No alias or valid directory path has been found."
		exit 1
		;;
	"back")
		echo "Returning to the directory: $(popd 2>/dev/null)"
		popd 1>/dev/null 2>/dev/null
		;;
	"run-from")

		;;
	*)
		help_text
		;;
esac