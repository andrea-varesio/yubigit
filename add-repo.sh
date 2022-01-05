#!/bin/bash

#https://github.com/andrea-varesio/yubigit
#automate the creation of a GitHub repository

source variable-builder.sh

echo " Hello $GITUSER "
echo " The default path for this repo is : "
echo " $REPOPATH "
read -p " Do you want to change path? y/n : " NEWPATH
if [ $NEWPATH == "y" ]; then
	read -p " Enter the desired path : " REPOPATH
fi
read -p " Insert repository name : " REPO
mkdir -pv $REPOPATH/$REPO
cd $REPOPATH/$REPO
git init
echo " Repository $REPO initialized"
read -p " Move files to upload into $REPOPATH/$REPO, then press ENTER "
git add *
echo " Added files"

if [ "$PGPKEYID" == "nosign" ];
  then
    git commit -m "first commit"
    echo " Files committed "
  else
    echo " You may have to touch the YubiKey to sign the files "
    git commit -S -m "first commit"
    echo " Files signed and committed "
fi
git branch -M main
echo " Created branch main "
git remote add origin git@github.com:$GITUSER/$REPO.git
echo " Added origin git@github.com:$GITUSER/$REPO.git "
read -p " Press ENTER to confirm push "
git push -u origin main
echo " Pushed files "

unset YBKCOUNTER SERIALNO YBK GITUSER EMAIL PGPKEYID REPOPATH NEWPATH REPO

echo " Goodbye $GITUSER "
unset GITUSER
echo " Finished "
exit
