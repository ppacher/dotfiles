#!/bin/bash

#
# If there's a primary.sh screenlayout defined
# make sure to call it now
#
if [ -e ${HOME}/.screenlayout/primary.sh ]; then
    ${HOME}/.screenlayout/primary.sh
fi

#
# Support for custom xinit hooks that are not
# checked into the dotfiles repository. 
#
if [ -d ${HOME}/.config/xinit-hooks ]; then
    run-parts ${HOME}/.config/xinit-hooks
fi

#
# Finally, execute awesomeWM :)
#
exec awesome 
