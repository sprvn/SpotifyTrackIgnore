#!/bin/bash

while :
do
	result=`dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'`;

	song=`printf "$result\n" | tr '[:upper:]' '[:lower:]' | grep -A2 -E "string \"xesam:title\"" | tail -n +2 | sed 's/            variant                string //g' | grep -E -o "\".*\"" | sed 's/\"//g'`;
	artist=`printf "$result\n" | tr '[:upper:]' '[:lower:]' | grep -A2 -E "string \"xesam:artist\"" | tail -n +3 | sed 's/            variant                string //g' | grep -E -o "\".*\"" | sed 's/\"//g' | sed 's/                  string //g'`;

	both=`echo "$song - $artist" | sed 's/ //g'`;

        blacklistRes=`cat blacklist.dat | sed 's/ //g' | grep -oiE "$both"`

	if [ -n "$blacklistRes" ]; then
                echo $blacklistRes;
		dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

                resultTemp="1";
                while [ -n "$resultTemp" ]; do 
                    resultTemp=`dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'`;
                    resultTemp=`echo $resultTemp | grep -oiE "$song"`;
                done 
	fi
	sleep 0.25;
done
