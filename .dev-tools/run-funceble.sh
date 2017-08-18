#!/bin/bash
# Fetch funceble script files and run a test
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites

# ****************************************************************
# This uses the awesome funceble script created by Nissar Chababy
# Find funceble at: https://github.com/funilrys/funceble
# ****************************************************************

# ******************
# Set our Input File
# ******************
_input=$TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# ******************************************
# Make Sure Travis Own all files and Folders
# ******************************************

sudo chown -R travis:travis $TRAVIS_BUILD_DIR/

# *****************************************
# Get latest versions of funceble from repo
# *****************************************
#sudo wget https://raw.githubusercontent.com/funilrys/funceble/master/funceble -O $TRAVIS_BUILD_DIR/.dev-tools/_funceble/funceble
#sudo wget https://raw.githubusercontent.com/funilrys/funceble/master/tool -O $TRAVIS_BUILD_DIR/.dev-tools/_funceble/tool
#sudo wget https://raw.githubusercontent.com/funilrys/funceble/master/iana-domains-db -O $TRAVIS_BUILD_DIR/.dev-tools/_funceble/iana-domains-db

# *******************************
# Set Funceble Scripts Executable
# *******************************

sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/funceble/tool
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/funceble/funceble

# ****************************
# Switch to funceble directory
# ****************************

cd $TRAVIS_BUILD_DIR/.dev-tools/funceble/

# *************************
# Run Funceble Install Tool
# *************************

sudo bash $TRAVIS_BUILD_DIR/.dev-tools/funceble/tool -i

# ***************************************************************
# Clean up old result and output files as we only want the latest
# and don't want the repo to keep filling up with files
# ***************************************************************

sudo bash $TRAVIS_BUILD_DIR/.dev-tools/funceble/tool -c

# ************************************
#  Run Funceble and Check Domains List
# ************************************

sudo bash $TRAVIS_BUILD_DIR/.dev-tools/funceble/funceble -a -t 1 -h -f $_input

exit 0
