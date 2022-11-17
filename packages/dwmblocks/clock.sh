#!/bin/sh

clock=$(date '+%I')

case "$clock" in
	"00") icon="🕛" ;;
	"01") icon="🕐" ;;
	"02") icon="🕑" ;;
	"03") icon="🕒" ;;
	"04") icon="🕓" ;;
	"05") icon="🕔" ;;
	"06") icon="🕕" ;;
	"07") icon="🕖" ;;
	"08") icon="🕗" ;;
	"09") icon="🕘" ;;
	"10") icon="🕙" ;;
	"11") icon="🕚" ;;
	"12") icon="🕛" ;;
esac

case $BLOCK_BUTTON in
	1) xsetroot -name button 1 ;;
	2) xsetroot -name button 2 ;;
	3) xsetroot -name button 3 ;;
	6) xsetroot -name button 6 ;;
esac

date "+(%a) %d %b %Y $icon%H:%M%p"

