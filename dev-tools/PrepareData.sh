#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# MIT License


# We stop after the first error.
set -e

# **********************************
# Setup input bots and referer lists
# **********************************

whitelistFile=${TRAVIS_BUILD_DIR}/whitelists/me
antiWhitelistFile=${TRAVIS_BUILD_DIR}/whitelists/anti
input1=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt
pythonversion="3.7.4"
environmentname="pyconda"

# ------------------------
# Set Terminal Font Colors
# ------------------------

bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
defaultcolor=$(tput setaf default)

PrepareTravis () {
    git remote rm origin
    git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
    git config --global user.email "${GIT_EMAIL}"
    git config --global user.name "${GIT_NAME}"
    git config --global push.default simple
    git checkout "${GIT_BRANCH}"
}
#PrepareTravis

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************
PrepareLists () {
    sort -u ${input1} -o ${input1}
    dos2unix ${input1}
}
PrepareLists

# ***********************************
# Deletion of all whitelisted domains
# ***********************************

WhiteListing () {
    hash uhb_whitelist
    uhb_whitelist -f "${input1}" -o "${input1}" -w "${whitelistFile}" -a "${antiWhitelistFile}"
}
#WhiteListing (DISABLE)

CommitData () {
    commitdate=$(date +%F)
    committime=$(date +%T)
    timezone=$(date +%Z)
    cd ${TRAVIS_BUILD_DIR}
    git remote rm origin
    git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
    git config --global user.email "${GIT_EMAIL}"
    git config --global user.name "${GIT_NAME}"
    git config --global push.default simple
    git checkout master
    git add -A
    git commit -am "V.${TRAVIS_BUILD_NUMBER} (${commitdate} ${committime} ${timezone}) [ci skip]"
    git push origin master
}
#CommitData

exit ${?}

# MIT License

# Copyright (c) 2017, 2018, 2019 Mitchell Krog - mitchellkrog@gmail.com
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
