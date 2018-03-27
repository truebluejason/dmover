#!/bin/sh

if [ -f ~/.dmoverrc ]; then
	while read -r line; do
		ALIAS_NAME="$(echo $line | cut -d '=' -f1)"
		ADDRESS="$(echo $line | cut -d '=' -f2)"
		alias goto-${ALIAS_NAME}="pushd ${ADDRESS}"
	done < ~/.dmoverrc
	alias back="popd 2>/dev/null || dmover directory stack is empty."
fi

case "$1" in
	"setup")
		if [ ! -f ~/.dmoverrc ]; then
			touch ~/.dmoverrc
			#chmod +x ~/.dmoverrc
			echo "#---------------------------------------------------" >> ~/.bash_profile
			echo "# dmover.sh related config" >> ~/.bash_profile
			echo "#---------------------------------------------------" >> ~/.bash_profile
			echo "PATH=$PATH:~/"
			echo "source ~/dmover.sh" >> ~/.bash_profile
			cp dmover.sh ~/
			chmod +x ~/dmover.sh
			echo "Setup is complete."
			echo "If you haven't, type 'source ~/.bash_profile' in the command line and you're good to go!"
		else
			echo "You are already set up and good to go!"
			echo "Type 'dmover.sh help' in the command line if you need help with the program."
		fi
		;;
	"alias")
		if [ -z "$2" ]; then
			echo "You must state the name of the alias."
			echo "  - Example: dmover.sh alias ALIAS_NAME"
			exit 1
		elif [ -n "$(echo '$2' | grep ' ')" ]; then
			echo "Alias name cannot contain white spaces."
		else
	        echo "$2"="$(pwd)" >> ~/.dmoverrc
	        echo "Alias for $(pwd) set to $2."
	        echo "This alias will take effect on new command line tabs."
	    fi
		;;
	"list")
		echo
		echo "---------------------------------------------------"
		echo "Recorded Aliases"
		echo "---------------------------------------------------"
		while read -r line; do
			echo "$line"
		done < ~/.dmoverrc
		echo
		;;
	"help")
		echo 
		echo "---------------------------------------------------"
		echo "Availabe Commands:"
		echo "---------------------------------------------------"
		echo "setup: Run this command before you use the program."
		echo "  - Example: sh dmover.sh setup && source .bash_profile"
		echo "alias: Run this command in a directory to set an alias for that directory to be used with goto."
		echo "  - Example: dmover.sh alias ALIAS_NAME"
		echo "list: Run this command to view all recorded aliases."
		echo "  - Example: dmover.sh list"
		echo "goto: Run this command as a standalone to access a directory through its alias from anywhere."
		echo "  - Example: goto-ALIAS_NAME"
		echo "back: Run this command as a standalone to return to the last directory accessed through dmover."
		echo "  - Example: back"
		echo "PS: dmover will copy itself to its user's home directory. Please do not remove the copy or dmover won't work."
		echo
		;;
	*)
		echo "dmover is online. Run 'dmover.sh help' for more info."
		;;
esac