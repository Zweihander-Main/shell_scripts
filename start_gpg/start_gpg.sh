#!/usr/bin/env bash

# Scenario: start GPG, connecting to right TTY

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
