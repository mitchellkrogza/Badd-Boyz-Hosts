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

# ---------------------------------------------------
# Check Mini(Conda) is Installed Otherwise Install It
# ---------------------------------------------------
checkforconda () {
    if conda 2>&1 | grep -i 'command not found'; then
        echo "${bold}${red}CONDA NOT FOUND - ${bold}${green}Installing Mini(Conda)"
        export PATH="${TRAVIS_BUILD_DIR}/miniconda/bin:${PATH}"
        CONDA_ENVS_PATH="${TRAVIS_BUILD_DIR}/opt/anaconda/envs"
        CONDA_PKGS_DIRS="${TRAVIS_BUILD_DIR}/opt/anaconda/pkgs"
        sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
        sudo bash miniconda.sh -b -p ${TRAVIS_BUILD_DIR}/miniconda
        hash -r
        conda config --set always_yes yes --set changeps1 no
        conda update -q conda
        sudo rm miniconda.sh
        echo "${bold}${green}CONDA INSTALLED - Continuing"
    else
        echo "${bold}${green}CONDA FOUND - Continuing"
    fi
}
#checkforconda

# -------------------------------
# Set Conda Path and Update Conda
# -------------------------------

#printf '\n\n%s\n\n' "${bold}${magenta}Updating Conda"
#conda update -q conda

# -------------------------------------------------
# Make sure we always run the latest Python version
# -------------------------------------------------

#conda update python

# -----------------------------------------------------------
# Check for Existing Environment otherwise Create Environment
# -----------------------------------------------------------

#DIR="${HOME}/miniconda/envs/${environmentname}"
#if [ -d "${DIR}" ]; then
#	printf '\n%s\n%s\n\n' "${bold}${cyan}Environment ${DIR} Found" "Continuing with Renewals"
#else
#	printf '\n%s\n%s\n\n' "${bold}${red}Environment ${DIR} Not Found" "${bold}${yellow}Creating Environment"
#    conda create -q -n ${environmentname} python="${pythonversion}"
#fi

# --------------------
# Activate Environment
# --------------------

#printf '\n%s\n\n' "${bold}${magenta}Activating Environment"
#source activate ${environmentname}

# ---------------------
# Upgrade / Install Pip
# ---------------------

#printf '\n%s\n\n' "${bold}${magenta}Upgrading PIP"
#pip install --upgrade pip

# ------------------------------------
# Show Python and Certbot Version Info
# ------------------------------------

#python -VV

# *********************************************
# Get Travis CI Prepared for Committing to Repo
# *********************************************

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
    if [[ "$(git log -1 | tail -1 | xargs)" =~ "ci skip" ]]
    then
        hash uhb_whitelist
        uhb_whitelist -f "${input1}" -o "${input1}" -w "${whitelistFile}" -a "${antiWhitelistFile}"
    fi
}
WhiteListing

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
