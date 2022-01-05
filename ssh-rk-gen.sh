#!/bin/bash

#https://github.com/andrea-varesio/yubigit
#automate the creation or import of resident SSH keys

source variable-builder.sh

read -p " Would you like to (i) import a resident key or (g) generate a new key pair? i/g " SSHKEY
if [ "$SSHKEY" == "i" ]
	then
		ssh-keygen -K
		mv -v id_ecdsa_sk_rk $HOME/.ssh/id_ecdsa_sk_${YBK}
		mv -v id_ecdsa_sk_rk.pub $HOME/.ssh/id_ecdsa_sk_${YBK}.pub
		echo " Imported SSH keys from YubiKey $YBK"
	else
	if [ "$SSHKEY" == "g" ]
		then
			ssh-keygen -t ecdsa-sk -O resident -C $YBK -f $HOME/.ssh/id_ecdsa_sk_$YBK
			echo " The key pair has been generated "
			echo " Now add the public key to your GitHub account "
		else
			echo " The option you selected is invalid "
			echo " Exiting... "
fi

unset YBKCOUNTER SERIALNO YBK GITUSER EMAIL PGPKEYID REPOPATH NEWPATH SSHKEY
exit
