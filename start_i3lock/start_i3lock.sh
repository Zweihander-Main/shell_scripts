#!/usr/bin/env bash

# Scenario: Setup i3lock, sync to monitor turn off

color_black='#00000000'
color_white='#ffffff22'
color_default='#ff00ffcc'
color_text='#ee00eeee'
color_wrong='#880000bb'
color_verify='#bb00bbbb'

i3lock \
	--insidever-color=$color_white \
	--ringver-color=$color_verify \
	--insidewrong-color=$color_white \
	--ringwrong-color=$color_wrong \
	--inside-color=$color_black \
	--ring-color=$color_default \
	--line-color=$color_black \
	--separator-color=$color_default \
	--verif-color=$color_text \
	--wrong-color=$color_text \
	--time-color=$color_text \
	--date-color=$color_text \
	--layout-color=$color_text \
	--keyhl-color=$color_wrong \
	--bshl-color=$color_wrong \
	--screen 1 \
	--blur 5 \
	--clock \
	--indicator \
	--time-str="%H:%M:%S" \
	--date-str="%A, %m %Y" \
	--keylayout 1

# turn monitor off
xset dpms force off
