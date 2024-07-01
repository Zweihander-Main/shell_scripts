# Shell scripts

> Linux shell scripts that merit their own space.

## Usage

If `.env.example` file is present, create a copy called `.env` and change to suit your needs.

## Scripts

### Download Nextcloud

I use a specific Nextcloud News (RSS reader) account purely for videos. This script talks to my local instance, downloads all the unread items using `youtube-dl`, and marks them as read.

**Requires:** ~jq~, ~youtube-dl~, ~curl~

### Log dunst

For use with `script` in `dunstrc`.

### Memo to Inbox

I have a memo email folder which I send memos to using [Blitzmail](https://f-droid.org/packages/de.grobox.blitzmail/). The memos are pulled in using `isync` and then each of their body text's are written to an inbox file in emacs (as TODOs).

To ensure the inbox file isn't clobbered, you can set the following which the script uses to save all buffers before writing to the inbox file:

```emacs-lisp
(defun sigusr1-handler()
  "Handle SIGUSR1 signal by saving all buffers."
  (interactive)
  (evil-write-all nil))

(define-key special-event-map [sigusr1] 'sigusr1-handler)
```

**Requires:** ~jq~, ~notmuch~, ~isync~, ~awk~, ~xdotool~

### Open Video

I have a folder full of videos and want to open the oldest one, moving it to a 'watched' folder in the process. This allows me to take any cognitive effort needed in terms of choosing a video out of the equation.

**Requires:** ~fd~, ~xdg-open~

### OpenBB

Script to run Docker image of [OpenBB Terminal](https://github.com/OpenBB-finance/OpenBBTerminal/) with X support. Config will be located at `XDG_CONFIG_HOME/openbb/openbb.env`. Make sure to set `OPENBB_BACKEND=Qt5Agg` in config.

**Requires:** ~docker~

### Start DWM

Start DWM, allow for restarts, log errors to file

**Requires:** ~dwm~

### Start GPG

Start GPG, connecting to right TTY

**Requires:** ~gpg-connect-agent~

### Start i3lock

Setup i3lock, sync to monitor turn off

**Requires:** ~i3lock~

### Start KeepassXC

Workaround allows YubiKey challenge-response for CLI unlock of KeepassXC file.
Stick `wait-for-keepassxc-require.sh` in `ExecStartPre` in a service file. When
requirements are met (Yubikey plugged in, files accessible), KeepassXC can be
started using `start_keepassxc.sh`

**Requires:** ~ykchalresp~, ~ykinfo~, ~keepassxc~, ~xdotool~

### Toggle sink

Switch between two pulse sinks.

**Requires:** ~pactl~, ~dunstify~

## See also

- [Miscellaneous Windows Scripts](https://github.com/Zweihander-Main/miscWinScripts)
- [zweidotfiles](https://github.com/Zweihander-Main/zweidotfiles)

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[AGPLv3](./LICENSE)

    Zweihander-Main/shell_scripts
    Copyright (C) 2021 Zweihänder

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
