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
_input2=$TRAVIS_BUILD_DIR/.dev-tools/dead-domains.txt

# Make Sure Travis Owns All New Files
# ***********************************

sudo chown -R travis:travis $TRAVIS_BUILD_DIR

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

sort -u $_input1 -o $_input1
sort -u $_input2 -o $_input2

# ***********************************************************
# Now Run our Cleaner to remove all Dead and Inactive Domains
# ***********************************************************

awk 'NR==FNR{a[$0];next} !($0 in a)' $TRAVIS_BUILD_DIR/.dev-tools/dead-domains.txt $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt > $TRAVIS_BUILD_DIR/.dev-tools/temp_combined-list.txt && mv $TRAVIS_BUILD_DIR/.dev-tools/temp_combined-list.txt $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# *****************
# Activate Dos2Unix
# *****************

dos2unix $TRAVIS_BUILD_DIR/PULL_REQUESTS/domains.txt

# ********************************
# Delete our dead-domains.txt file
# ********************************

sudo rm $TRAVIS_BUILD_DIR/.dev-tools/dead-domains.txt

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