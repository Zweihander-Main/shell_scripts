#!/usr/bin/env bash

# For use with `script` in `dunstrc`.

printf '%s\n' "$(date):$*" >>"${XDG_DATA_HOME}/dunst/dunst.log"
