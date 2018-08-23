#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# MIT License

# ***********************************************************
# Remove our inactive and invalid domains from PULL_REQUESTS
# ***********************************************************

cat ${TRAVIS_BUILD_DIR}/.dev-tools/output/domains/ACTIVE/list | grep -v "^$" | grep -v "^#" > tempdomains.txt
mv tempdomains.txt ${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt

# ***************************************************************************
# Generate our host file and update README with build and version information
# ***************************************************************************

sudo chown -R travis:travis ${TRAVIS_BUILD_DIR}/

sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/modify-readme.sh
sudo chmod +x ${TRAVIS_BUILD_DIR}/.dev-tools/generate-hosts.sh

sudo ${TRAVIS_BUILD_DIR}/.dev-tools/modify-readme.sh
sudo ${TRAVIS_BUILD_DIR}/.dev-tools/generate-hosts.sh

# *************************************************************
# Travis now moves to the before_deploy: section of .travis.yml
# *************************************************************

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
