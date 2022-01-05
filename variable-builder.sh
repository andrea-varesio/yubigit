#!/bin/bash

#https://github.com/andrea-varesio/yubigit
#script used to assign the correct values to the variables

source variables.sh

#Checking if the YubiKey is discoverable and registered
export SERIALNO="$(ykman info | grep 'Serial number: ' | sed 's/^.* //')"
if [ -z "$SERIALNO" ]
	then
  	echo " YubiKey NOT found ! "
		echo " Make sure that ykman can detect your YubiKey, then try again "
		echo " Exiting ..."
		exit
	else
    export YBKCOUNTER="$(grep $SERIALNO variables.sh | grep -o -P '(?<=SERIALNO)[0-9]{1}')"
    if [ -z "$YBKCOUNTER" ]
      then
        echo " This YubiKey is not registered "
        echo " Run setup.sh then try again "
        echo " Exiting ..."
        exit
      else
        echo " Discovered YubiKey #$YBKCOUNTER with serial number $SERIALNO "
    fi
fi

#Assigning variables
export YBK="$(grep "YBK$YBKCOUNTER" variables.sh | grep -o '".*"' | sed 's/"//g')"
export GITUSER="$(grep "GITUSER$YBKCOUNTER" variables.sh | grep -o '".*"' | sed 's/"//g')"
export EMAIL="$(grep "EMAIL$YBKCOUNTER" variables.sh | grep -o '".*"' | sed 's/"//g')"
export PGPKEYID="$(grep "PGPKEYID$YBKCOUNTER" variables.sh | grep -o '".*"' | sed 's/"//g')"
export REPOPATH="$(grep "REPOPATH$YBKCOUNTER" variables.sh | grep -o '".*"' | sed 's/"//g')"

echo " Variables built "
