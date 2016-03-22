#!/bin/bash

result=`dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'`;

song=`printf "$result\n" | grep -A2 -E "string \"xesam:title\"" | tail -n +2 | sed 's/            variant                string //g' | grep -E -o "\".*\"" | sed 's/\"//g'`;
artist=`printf "$result\n" | grep -A2 -E "string \"xesam:artist\"" | tail -n +3 | sed 's/            variant                string //g' | grep -E -o "\".*\"" | sed 's/\"//g' | sed 's/                  string //g'`;

echo "$song - $artist";


