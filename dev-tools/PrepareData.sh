#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# MIT License


# We stop after the first error.
#set -e

# **********************************
# Setup input bots and referer lists
# **********************************

whitelistFile=${TRAVIS_BUILD_DIR}/whitelists/me
antiWhitelistFile=${TRAVIS_BUILD_DIR}/whitelists/anti
input1=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/add-domain
input2=${TRAVIS_BUILD_DIR}/domains
input3=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/remove-domain
inputtmp=${TRAVIS_BUILD_DIR}/domains.tmp
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

# ***********
# Add Domains
# ***********

add-domain () {
if [ -s ${input1} ]
then
    echo "Domain Addition Requested"
    grep -v -e '^[[:space:]]*$' ${input1}
    cat ${input2} > ${inputtmp}
    cat ${input1} >> ${inputtmp}
    sort -u ${inputtmp} -o ${inputtmp}
    mv ${inputtmp} ${input2}
    dos2unix ${inputtmp}
    truncate -s 0 ${input1}
    else
    :
fi
}
add-domain

#check file output
cat ${input2}

# **************
# Remove Domains
# **************

remove-domain () {
if [ -s ${input3} ]
then
    echo "Domain Removal Requested"
    sort -u ${input2} -o ${input2}
    sort -u ${input3} -o ${input3}
    grep -v -e '^[[:space:]]*$' ${input3}
    comm -23 ${input2} ${input3} > tmp
    mv tmp ${input2}
    truncate -s 0 ${input3}
    else
    :
fi
}
remove-domain



# ***********************************
# Deletion of all whitelisted domains
# ***********************************

WhiteListing () {
    hash uhb_whitelist
    uhb_whitelist -f "${input2}" -o "${input2}" -w "${whitelistFile}" -a "${antiWhitelistFile}"
}
#WhiteListing


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
