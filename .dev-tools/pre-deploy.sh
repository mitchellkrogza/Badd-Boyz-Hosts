#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# MIT License

# ***************************************
# Make sure we are in the Build Directory
# ***************************************

cd ${TRAVIS_BUILD_DIR}

# *******************************
# Remove Remote Added by TravisCI
# *******************************

git remote rm origin

# **************************
# Add Remote with Secure Key
# **************************

git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git

# *********************
# Set Our Git Variables
# *********************

git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git config --global push.default simple

# *******************************************
# Make sure we have checked out master branch
# *******************************************

git checkout master

# **************************
# Make Sure Temp Files Exist
# **************************

sudo touch ${TRAVIS_BUILD_DIR}/.dev-tools/temp_combined-list.txt

# **********************************
# Setup input bots and referer lists
# **********************************

input1=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt

# ***********************************
# Make Sure Travis Owns All New Files
# ***********************************

sudo chown -R travis:travis ${TRAVIS_BUILD_DIR}

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

sort -u ${input1} -o ${input1}

# *****************
# Activate Dos2Unix
# *****************

dos2unix ${input1}

# **************************************
# Downloading of the whitelisting script
# **************************************

wget https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/dev-center/whitelisting/whitelisting.py -O "${TRAVIS_BUILD_DIR}/.dev-tools/whitelisting.py"
sudo chown -R travis:travis ${TRAVIS_BUILD_DIR}

# ***********************************
# Deletion of all whitelisted domains
# ***********************************

${TRAVIS_BUILD_DIR}/.dev-tools/whitelisting.py -f "${input1}" -o "${input1}"

# ************************************
# Make sure all scripts are executable
# ************************************

sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/whitelisting.py
sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/run-PyFunceble.sh
sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/modify-readme.sh
sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/generate-hosts.sh

# ***************************************************
# Run funceble to check for dead domains
# ***************************************************

bash -x ${TRAVIS_BUILD_DIR}/.dev-tools/run-PyFunceble.sh


exit ${?}

# MIT License

# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
