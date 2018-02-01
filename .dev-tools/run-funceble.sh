#!/bin/bash
# ********************
# Run Funceble Testing
# ********************

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

# *******************************
# Set Funceble Scripts Executable
# *******************************

sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/tool.py
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/PyFunceble.py

# ****************************
# Switch to funceble directory
# ****************************

cd $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/

# *************************
# Run PyFunceble
# *************************


YEAR=$(date +%Y)
MONTH=$(date +%m)

export TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR}
export GH_TOKEN=${GH_TOKEN}
export TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}
export GIT_EMAIL=${GIT_EMAIL}
export GIT_NAME=${GIT_NAME}
sudo python3 $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/tool.py --dev -u && \
sudo python3 $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/tool.py  --autosave-minutes 10 --commit-autosave-message "V1.${YEAR}.${MONTH}.${TRAVIS_BUILD_NUMBER} [funceble]" --commit-results-message "V1.${YEAR}.${MONTH}.${TRAVIS_BUILD_NUMBER}" -i && \
sudo python3 $TRAVIS_BUILD_DIR/.dev-tools/PyFunceble/PyFunceble.py --cmd-before-end "bash $TRAVIS_BUILD_DIR/.dev-tools/final-commit.sh" --travis --travis-branch 'dev' -a -ex --plain --split -f $_input
