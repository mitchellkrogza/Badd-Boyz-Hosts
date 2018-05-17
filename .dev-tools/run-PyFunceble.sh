#!/bin/bash
# **********************
# Run PyFunceble Testing
# **********************
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza

# ****************************************************************
# This uses the awesome PyFunceble script created by Nissar Chababy
# Find funceble at: https://github.com/funilrys/PyFunceble
# ****************************************************************

# **********************
# Setting date variables
# **********************

yeartag=$(date +%Y)
monthtag=$(date +%m)

# ******************
# Set our Input File
# ******************
input=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt

# ******************************************
# Make Sure Travis Own all files and Folders
# ******************************************

sudo chown -R travis:travis ${TRAVIS_BUILD_DIR}/

# *******************************
# Set Funceble Scripts Executable
# *******************************

chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/PyFunceble/PyFunceble.py

# ****************************
# Switch to funceble directory
# ****************************

cd ${TRAVIS_BUILD_DIR}/.dev-tools/

# *****************************************************
# Exporting all variable that are needed by PyFunceble
# *****************************************************

export TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR}
export GH_TOKEN=${GH_TOKEN}
export TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}
export GIT_EMAIL=${GIT_EMAIL}
export GIT_NAME=${GIT_NAME}

# ******************************************************************************
# Updating PyFunceble && Run PyFunceble
# Note: We use the same statement so that if something is broken everything else
#   is not run.
# ******************************************************************************

PyFunceble --travis -dbr 5 --cmd-before-end "bash ${TRAVIS_BUILD_DIR}/.dev-tools/final-commit.sh" -a -ex --plain --split --share-logs --autosave-minutes 10 --commit-autosave-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --commit-results-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}" -f ${input}

exit ${?}
