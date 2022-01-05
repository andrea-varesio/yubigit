#!/bin/bash

#https://github.com/andrea-varesio/yubigit
#yubigit initial setup script -- it's used to add the required variables to "variables.sh"

echo "yubigit  Copyright (C) 2022 Andrea Varesio"
echo "This program comes with ABSOLUTELY NO WARRANTY"
echo "This is free software, and you are welcome to redistribute it under certain conditions"
echo "Full license available at https://github.com/andrea-varesio/yubigit/blob/main/LICENSE"

#Checking for dependencies
export DEPS=$(<dependencies)
echo " Checking dependencies "
for PACKAGE in $DEPS
	do
	  [[ $(which $PACKAGE 2>/dev/null) ]] || { echo -en " $PACKAGE needs to be installed. Use 'sudo apt install $PACKAGE' ";MISSINGDEP=1; }
done
[[ $MISSINGDEP -ne 1 ]] && echo " All requirements are met " || { echo -en " Install the missing dependency and try again ";exit 1; }
unset DEPS MISSINGDEP PACKAGE

#Importing existing YubiKey counter
if [ -f "variables.sh" ];
	then
		echo " variables.sh found - importing counter... "
		source variables.sh
	else
		echo " variables.sh not found - creating a new file... "
		touch variables.sh
			cat << EOF >> ./variables.sh
#!/bin/bash

#https://github.com/andrea-varesio/yubigit

export YBKCOUNTER=0 #starting counter - do not remove
EOF
fi

#Generating variables
let "YBKCOUNTER++"
echo " Registering YubiKey #$YBKCOUNTER "
read -p " Plug in your YubiKey if you haven't done so already ! Then, press ENTER to continue "
export SERIALNO="$(ykman info | grep 'Serial number: ' | sed 's/^.* //')"
if [ -z "$SERIALNO" ]
	then
  	echo " YubiKey NOT found ! "
		echo " Make sure that ykman can detect your YubiKey, then try again "
		echo " Exiting ..."
		exit
	else
		echo " Discovered YubiKey with serial number $SERIALNO "
fi
export SERIALNOCHECK="$(grep $SERIALNO variables.sh)"
if [[ ! -z "$SERIALNOCHECK" ]];
	then
		export OLDYBKCOUNTER="$(grep $SERIALNO variables.sh | grep -o -P '(?<=SERIALNO)[0-9]{1}')"
		echo " This YubiKey is already registered as YubiKey #$OLDYBKCOUNTER  "
		read -p " Do you want to delete the old information and re-register this YubiKey ? (a backup file will be created) y/n : " UPDATE
		if [ $UPDATE == "y" ];
			then
				sed -i.$(date +%Y%m%d%H%M).bak "/SERIALNO${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/YBKCOUNTER=${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/#YubiKey #${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/YBK${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/GITUSER${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/EMAIL${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/PGPKEYID${OLDYBKCOUNTER}/d" variables.sh
				sed -i "/REPOPATH${OLDYBKCOUNTER}/d" variables.sh
				source variables.sh
				let "YBKCOUNTER++"
				echo " Registering YubiKey #$YBKCOUNTER "
			else
				echo " Okay, leaving existing configuration intact. Exiting... "
				exit
		fi
fi
read -p " Enter a friendly name for your YubiKey (ie: 5C NFC) : " YBK
read -p " Enter your GitHub username : " GITUSER
read -p " Enter the email associated with your GitHub account : " EMAIL
export PGPKEYID="$(gpg --card-status --keyid-format long | grep sec | grep -o -P '(?<=/)[A-Z0-9]{16}')"
if [[ ! -z "$PGPKEYID" ]];
	then
		echo " Found PGP key 0x$PGPKEYID associated with this YubiKey "
		read -p " Do you want to use this key to sign git commits ? y/n : " SIGN
			if [ $SIGN == "n" ];
				then
					export PGPKEYID="nosign"
			fi
	else
		echo " No PGP key associated to this YubiKey was found "
		read -p " Do you want to specify the key that you will use to sign git commits ? y/n : " ADDPGP
			if [ $ADDPGP == "y" ];
				then
					read -p " Please enter the long id (16 consecutive characters) WITHOUT \"0x\" : " PGPKEYID
				else
					export PGPKEYID="nosign"
			fi
fi
echo " The default path for new repositories will be : "
echo " $HOME/github/$GITUSER "
read -p " Do you want to change the default path ? y/n : " NEWPATH
if [ $NEWPATH == "n" ];
	then
		export REPOPATH=$HOME/github/$GITUSER
	else
		read -p " Enter the desired path : " REPOPATH
fi

#Writing new variables
cat << EOF >> variables.sh
#YubiKey #$YBKCOUNTER
export YBKCOUNTER=$YBKCOUNTER
export SERIALNO${YBKCOUNTER}="$SERIALNO"
export YBK${YBKCOUNTER}="$YBK"
export GITUSER${YBKCOUNTER}="$GITUSER"
export EMAIL${YBKCOUNTER}="$EMAIL"
export PGPKEYID${YBKCOUNTER}="0x$PGPKEYID"
export REPOPATH${YBKCOUNTER}="$REPOPATH"
EOF

echo " Setup complete "
unset YBKCOUNTER SERIALNO YBK GITUSER EMAIL PGPKEYID SIGN ADDPGP NEWPATH REPOPATH
exit
