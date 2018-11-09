#!/bin/bash

# check for the OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  #Linux
  HOSTFILE="/etc/hosts"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  HOSTFILE="/private/etc/hosts"
else
  echo "Sorry not supported!"
  sleep 1
  exit
fi

HEADER="# Start Spotify AdBlock"
FOOTER="# End Spotify AdBlock"

# check for root privilage
if [ "$EUID" -ne 0 ]
then
  printf "requires root privileges!\nPlease run as root."
  sleep 1
  exit
fi

# check if there is old one so we remove it first
line_start=$(grep -n "$HEADER" "$HOSTFILE" | grep -Eo '^[^:]+')
if [ "$line_start" ]
then
  echo "[-] removing old script..."
  line_end=$(grep -n "$FOOTER" "$HOSTFILE" | grep -Eo '^[^:]+')
  sed -i.bak -e "${line_start},${line_end}d" "$HOSTFILE"
  sleep 1
  echo "[+] adding new script..."
fi

# printing blocker in hostfile
while IFS= read -r LINE || [[ -n "$LINE" ]]
do
  echo $LINE >> $HOSTFILE
done < ./block.txt

echo "Done, Enjoy!"
exit