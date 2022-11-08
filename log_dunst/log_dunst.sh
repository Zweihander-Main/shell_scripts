#!/usr/bin/env sh

# For use with `script` in `dunstrc`.

printf '%s\n' "$(date):$*" >> "${XDG_DATA_HOME}/dunst/dunst.log"
