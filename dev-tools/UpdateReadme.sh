#!/bin/bash
# Write Build / Version Number into README.md
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# MIT License

# ******************
# Set Some Variables
# ******************

yeartag=$(date +%Y)
monthtag=$(date +%m)
my_git_tag=V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}
total_sites=$(wc -l < ${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt)
active_sites=$(cat ${TRAVIS_BUILD_DIR}/dev-tools/output/logs/percentage/percentage.txt)

# **********************************
# Temporary database files we create
# **********************************

inputdbA=/tmp/lastupdated.db
tmpfileA=tmpfileA

# ***************************************************************
# Start and End Strings to Search for to do inserts into template
# ***************************************************************

startmarker="_______________"
endmarker="____________________"

# ****************************************
# PRINT VERSION INFORMATION INTO README.md
# ****************************************

printf '%s\n%s%s%s\n%s%s\n```\n%s\n```\n%s' "${startmarker}" "[![VERSION](https://img.shields.io/badge/VERSION%20-%20" "${my_git_tag}" "-blue.svg)](https://github.com/mitchellkrogza/Badd-Boyz-Hosts/commits/master)" "#### Bad Host Count: " "${total_sites}" "${active_sites}" "${endmarker}" >> "${tmpfileA}"
mv ${tmpfileA} ${inputdbA}
ed -s ${inputdbA}<<\IN
1,/_______________/d
/____________________/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/README.md
/_______________/x
.t.
.,/____________________/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/README.md
q
IN
rm ${inputdbA}

makelogo () {
    # First disable the new ImageMagick-6 Policy file which pretty much breaks all operations of ImageMagick even for SUDO ??? Stupidest thing ever !!!
    sudo mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xmlout
    sudo convert ${TRAVIS_BUILD_DIR}/.assets/badd-boyz-logo-original.jpg -font DejaVu-Sans-Bold -pointsize 20 -fill red -gravity southeast -annotate +10+10 "${my_git_tag}" ${TRAVIS_BUILD_DIR}/.assets/badd-boyz-hosts-logo.jpg
}
makelogo


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
