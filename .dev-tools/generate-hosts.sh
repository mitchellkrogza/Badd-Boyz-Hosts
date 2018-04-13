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

YEAR=$(date +%Y)
MONTH=$(date +%m)
MY_GIT_TAG=V1.$YEAR.$MONTH.$TRAVIS_BUILD_NUMBER
BAD_REFERRERS=$(wc -l < $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt)

# **********************************
# Temporary database files we create
# **********************************

_inputdbA=/tmp/lastupdated.db
_inputdb1=/tmp/hosts.db

# ***********************************
# Declare template and temp variables
# ***********************************

_hosts=$TRAVIS_BUILD_DIR/.dev-tools/hosts.template
_tmphostsA=tmphostsA
_tmphostsB=tmphostsB

# **********************************
# Setup input bots and referer lists
# **********************************

_input1=$TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt
_input2=$TRAVIS_BUILD_DIR/.dev-tools/domains_tmp.txt

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

sort -u $_input1 -o $_input1

# *****************
# Activate Dos2Unix
# *****************

dos2unix $_input1

# ******************************************
# Trim Empty Line at Beginning of Input File
# ******************************************

grep '[^[:blank:]]' < $_input1 > $_input2
sudo mv $_input2 $_input1

# ********************************************************
# Clean the list of any lines not containing a . character
# ********************************************************

cat $_input1 | sed '/\./!d' > $_input2 && mv $_input2 $_input1

# **************************************************************************************
# Strip out our Dead Domains / Whitelisted Domains and False Positives from CENTRAL REPO
# **************************************************************************************


# *********************************************************************************************************************************************************
# First Run our Cleaner to remove all Dead Domains from https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# *********************************************************************************************************************************************************

#printf '\n%s\n%s\n%s\n\n' "##########################" "Stripping out Dead Domains" "##########################"

#sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/DOMAINS-dead.txt -O $TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/dead-domains.txt

#_deaddomains=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/dead-domains.txt
#_deadtemp=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/temp_dead_domains.txt

#sort -u $_deaddomains -o $_deaddomains
#sort -u $_input1 -o $_input1

#awk 'NR==FNR{a[$0];next} !($0 in a)' $_deaddomains $_input1 > $_deadtemp && mv $_deadtemp $_input1

#sort -u $_input1 -o $_input1

#printf '\n%s\n%s\n%s\n\n' "###############################" "END: Stripping out Dead Domains" "###############################"

# *******************************************************************************************************************************************************************
# Run our Cleaner to remove all Whitelisted Domains from https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# *******************************************************************************************************************************************************************

#printf '\n%s\n%s\n%s\n\n' "#################################" "Stripping out Whitelisted Domains" "#################################"

#sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/DOMAINS-whitelist.txt -O $TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/whitelist-domains.txt

#_whitelist=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/whitelist-domains.txt
#_whitelisttemp=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/temp_whitelisted.txt

#sort -u $_whitelist -o $_whitelist

#awk 'NR==FNR{a[$0];next} !($0 in a)' $_whitelist $_input1 > $_whitelisttemp && mv $_whitelisttemp $_input1

#sort -u $_input1 -o $_input1

#printf '\n%s\n%s\n%s\n\n' "######################################" "END: Stripping out Whitelisted Domains" "######################################"

# ************************************************
# Activate Dos2Unix One Last Time and Re-Sort List
# ************************************************

dos2unix $_input1

# ***************************************************************
# Start and End Strings to Search for to do inserts into template
# ***************************************************************

_start1="# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###"
_end1="# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###"
_startmarker="##### Version Information #"
_endmarker="##### Version Information ##"

# **********************************
# PRINT DATE AND TIME OF LAST UPDATE
# **********************************

now="$(date)"
echo $_startmarker >> $_tmphostsA
printf "###################################################\n### Version: "$MY_GIT_TAG"\n### Updated: "$now"\n### Bad Host Count: "$BAD_REFERRERS"\n###################################################\n" >> $_tmphostsA
echo $_endmarker  >> $_tmphostsA
mv $_tmphostsA $_inputdbA
ed -s $_inputdbA<<\IN
1,/##### Version Information #/d
/##### Version Information ##/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/.dev-tools/hosts.template
/##### Version Information #/x
.t.
.,/##### Version Information ##/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/.dev-tools/hosts.template
q
IN
rm $_inputdbA

# ****************************
# Insert hosts into hosts file
# ****************************

echo $_start1 >> $_tmphostsB
for line in $(cat $_input1); do
printf "0.0.0.0 ${line}\n" >> $_tmphostsB
done
echo $_end1  >> $_tmphostsB
mv $_tmphostsB $_inputdb1
ed -s $_inputdb1<<\IN
1,/# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/d
/# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/.dev-tools/hosts.template
/# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/x
.t.
.,/# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/.dev-tools/hosts.template
q
IN
rm $_inputdb1

# ************************************
# Copy Files into place before testing
# ************************************

sudo cp $_hosts $TRAVIS_BUILD_DIR/hosts

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