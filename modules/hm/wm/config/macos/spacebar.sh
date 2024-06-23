#!/usr/bin/env bash

show_date ()
{
DATE=$(date +"📆 %Y-%m-%d")
UTC=$(date -u +"🌎 %R")
MSK=$(TZ='Europe/Moscow' date +"🇷🇺 %R")
KG=$(TZ='Asia/Bishkek' date +"🇰🇬 %R")
PHT=$(TZ='Asia/Manila' date +"🇵🇭 %R")
echo -n " $UTC"
echo -n " $MSK $KG $PHT"
echo -n " $DATE"
}

vpn_status ()
{
UTUN=$(ifconfig | grep -E 'utun[0-9]+:' | grep -v utun0 | cut -f1 -d':')
IPSEC=$(ifconfig | grep -E 'ipsec[0-9]+:' | cut -f1 -d':')

if [[ $UTUN != "" ]]; then
	for utun in $UTUN; do
		IP=$(ifconfig $utun 2> /dev/null | grep -w inet | cut -d' ' -f2)
		if [[ "$IP" != "" ]]; then
			echo -n " 🟢 "
			return
		fi
	done
fi

if [[ $IPSEC != "" ]]; then
	for ipsec in $IPSEC; do
		IP=$(ifconfig $utun 2> /dev/null | grep -w inet | cut -d' ' -f2)
		if [[ "$IP" != "" ]]; then
			echo -n " 🟢 "
			return
		fi
	done
fi

echo -n " 🔴 "
}

show_battery ()
{
echo -n " 🔋 " ; pmset -g batt | grep 'remain' | sed ' s/.*\t\([0-9]*\%\);.* \([0-9]*:[0-9]*\) remaining.*/\1 \2/g'
}

vpn_status
show_date
show_battery

