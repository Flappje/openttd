#!/bin/bash

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
FLAGS=(\
  -D \
  -x \
)

# Loads the desired game, or prepare to load it next time server starts up!
if   [ ${loadgame} = "true" ]; then
  echo "loadgame = true"
elif [ ${loadgame} = "false" ]; then
  echo "loadgame = flase"
elif [ ${loadgame} = "last-autosave" ]; then
  savegame=${savepath}/autosave/`ls -rt ${savepath}/autosave/ | tail -n1`
  echo "using savegame: ${savegame}"
  FLAGS+=( -g ${savegame} )
elif [ ${loadgame} = "exit" ]; then
  savegame="${savepath}/autosave/exit.sav"
  echo "using savegame: ${savegame}"
  FLAGS+=( -g ${savegame} )
fi

echo "Starting game"
exec /usr/share/games/openttd/openttd "${FLAGS[@]}"
echo "exit"
exit 0
