#!/bin/sh

old_openttd_dir="/home/openttd/.openttd"
new_openttd_dir="/home/openttd/.local/share/openttd"

#check if new openttd profile dir exists
if [ -d ${new_openttd_dir} ]; then
  # if exists, set the new path
  savepath="/home/openttd/.local/share/openttd/save"
else
  # if not, leave the old path
  savepath="/home/openttd/.openttd/save"
fi

savegame="${savepath}/${savename}"
LOADGAME_CHECK="${loadgame}x"
loadgame=${loadgame:-'false'}

# Loads the desired game, or prepare to load it next time server starts up!
if [ ${LOADGAME_CHECK} != "x" ]; then

        case ${loadgame} in
                'true')
                ;;
                'false')
                ;;
                'last-autosave')
			savegame=${savepath}/autosave/`ls -rt ${savepath}/autosave/ | tail -n1`
                ;;
                'exit')
			savegame="${savepath}/autosave/exit.sav"
 	        ;;
		*)
			echo "ambigous loadgame (\"${loadgame}\") statement inserted."
			exit 1
		;;
        esac
	if [ -f  ${savegame} ]; then
		echo "We are loading a save game!"
		echo "Lets load ${savegame}"
		exec "/usr/share/games/openttd/openttd -D -g ${savegame} -x -d ${DEBUG}"
 	else 
		echo "${savegame} not found..."
		echo "Creating a new game."
		exec "/usr/share/games/openttd/openttd -D -x -d ${DEBUG}"
	fi
else
	echo "\$loadgame (\"${loadgame}\") not set, starting new game"
        exec "/usr/share/games/openttd/openttd -D -x"
fi
echo "sleep 5"
sleep 5
echo "exit"
exit 0
