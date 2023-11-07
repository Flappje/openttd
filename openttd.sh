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

PUID=${PUID:-911}
PGID=${PGID:-911}
PHOME=${PHOME:-"/home/openttd"}
USER=${USER:-"openttd"}

if [ ! "$(id -u ${USER})" -eq "$PUID" ]; then usermod -o -u "$PUID" ${USER} ; fi
if [ ! "$(id -g ${USER})" -eq "$PGID" ]; then groupmod -o -g "$PGID" ${USER} ; fi
if [ "$(grep ${USER} /etc/passwd | cut -d':' -f6)" != "${PHOME}" ]; then
        if [ ! -d ${PHOME} ]; then
                mkdir -p ${PHOME}
                chown ${USER}:${USER} -R ${PHOME}
        fi
        usermod -m -d ${PHOME} ${USER}
fi

#create save folder and set permissions
mkdir -p ${savepath}
chown ${USER}:${USER} -R ${savepath}

#fix home folder permissions
chown ${USER}:${USER} -R ${PHOME}

echo "
-----------------------------------
GID/UID
-----------------------------------
User uid:    $(id -u ${USER})
User gid:    $(id -g ${USER})
User Home:   $(grep ${USER} /etc/passwd | cut -d':' -f6)
-----------------------------------
"

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
		su -l openttd -c "/usr/share/games/openttd/openttd -D -g ${savegame} -x -d ${DEBUG}"
 	else 
		echo "${savegame} not found..."
		echo "Creating a new game."
		su -l openttd -c "/usr/share/games/openttd/openttd -D -x -d ${DEBUG}"
	fi
else
	echo "\$loadgame (\"${loadgame}\") not set, starting new game"
        su -l openttd -c "/usr/share/games/openttd/openttd -D -x"
fi

sleep 5
exit 0
