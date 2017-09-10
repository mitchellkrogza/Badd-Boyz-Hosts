#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts

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

# ******************
# Set Some Variables
# ******************

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
cd $TRAVIS_BUILD_DIR

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

sudo touch $TRAVIS_BUILD_DIR/.dev-tools/temp_combined-list.txt

# *********************************************************************************************************
# Pull Dead / Inactive Hosts Data from Repo > https://github.com/mitchellkrogza/Dead.Domains.Inactive.Hosts
# *********************************************************************************************************

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/dead-domains.txt -O $TRAVIS_BUILD_DIR/.dev-tools/dead-domains.txt

# **********************************
# Setup input bots and referer lists
# **********************************

_input1=$TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# ***********************************
# Make Sure Travis Owns All New Files
# ***********************************

sudo chown -R travis:travis $TRAVIS_BUILD_DIR

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

sort -u $_input1 -o $_input1

# ********************************************************
# Clean the list of any lines not containing a . character
# ********************************************************

cat $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt | sed '/\./!d' > $TRAVIS_BUILD_DIR/PULL_REQUESTS/temp_combined-list.txt && mv $TRAVIS_BUILD_DIR/PULL_REQUESTS/temp_combined-list.txt $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt
sort -u $_input1 -o $_input1

# **************************************************************************************
# Strip out our Dead Domains / Whitelisted Domains and False Positives from CENTRAL REPO
# **************************************************************************************

_combinedlist=$TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# *********************************************************************************************************************************************************
# First Run our Cleaner to remove all Dead Domains from https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# *********************************************************************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "##########################" "Stripping out Dead Domains" "##########################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/dead-domains.txt -O $TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/dead-domains.txt

_deaddomains=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/dead-domains.txt
_deadtemp=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/temp_dead_domains.txt

sort -u $_deaddomains -o $_deaddomains
sort -u $_combinedlist -o $_combinedlist

awk 'NR==FNR{a[$0];next} !($0 in a)' $_deaddomains $_combinedlist > $_deadtemp && mv $_deadtemp $_combinedlist

sort -u $_combinedlist -o $_combinedlist

printf '\n%s\n%s\n%s\n\n' "###############################" "END: Stripping out Dead Domains" "###############################"

# *******************************************************************************************************************************************************************
# Run our Cleaner to remove all False Positive Domains from https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# *******************************************************************************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "####################################" "Stripping out False Positive Domains" "####################################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/false-positives.txt -O $TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/false-positives.txt

_falsepositives=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/false-positives.txt
_falsepositivestemp=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/temp_false_positives.txt

sort -u $_falsepositives -o $_falsepositives

awk 'NR==FNR{a[$0];next} !($0 in a)' $_falsepositives $_combinedlist > $_falsepositivestemp && mv $_falsepositivestemp $_combinedlist

sort -u $_combinedlist -o $_combinedlist

printf '\n%s\n%s\n%s\n\n' "#########################################" "END: Stripping out False Positive Domains" "#########################################"

# *******************************************************************************************************************************************************************
# Run our Cleaner to remove all Whitelisted Domains from https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# *******************************************************************************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "#################################" "Stripping out Whitelisted Domains" "#################################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/whitelist-domains.txt -O $TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/whitelist-domains.txt

_whitelist=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/whitelist-domains.txt
_whitelisttemp=$TRAVIS_BUILD_DIR/.dev-tools/list-cleaning/temp_whitelisted.txt

sort -u $_whitelist -o $_whitelist

awk 'NR==FNR{a[$0];next} !($0 in a)' $_whitelist $_combinedlist > $_whitelisttemp && mv $_whitelisttemp $_combinedlist

sort -u $_combinedlist -o $_combinedlist

printf '\n%s\n%s\n%s\n\n' "######################################" "END: Stripping out Whitelisted Domains" "######################################"

# ************************************************
# Activate Dos2Unix One Last Time and Re-Sort List
# ************************************************

dos2unix $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# ********************************
# Truncate our List Cleaning Lists
# ********************************

sudo truncate -s 0 $_deaddomains
sudo truncate -s 0 $_falsepositives
sudo truncate -s 0 $_whitelist


exit 0

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