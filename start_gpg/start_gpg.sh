#!/usr/bin/env bash

# Scenario: start GPG, connecting to right TTY

if [ ! -d "$GNUPGHOME" ]; then
    mkdir -p "$GNUPGHOME"
fi

GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null
