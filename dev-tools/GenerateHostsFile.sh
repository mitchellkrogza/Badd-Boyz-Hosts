#!/bin/bash
# Hosts file generator for Badd Boyz Hosts
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
bad_referrers=$(wc -l < ${TRAVIS_BUILD_DIR}/domains)
hosts=${TRAVIS_BUILD_DIR}/dev-tools/hosts.template
dnsmasq=${TRAVIS_BUILD_DIR}/dev-tools/ddwrt-dnsmasq.template
tmphostsA=tmphostsA
tmphostsB=tmphostsB
tmphostsC=tmphostsC

# **********************************
# Temporary database files we create
# **********************************

inputdbA=/tmp/lastupdated.db
inputdb1=/tmp/hosts.db

# **********************************
# Setup input bots and referer lists
# **********************************

input1=${TRAVIS_BUILD_DIR}/domains
input2=${TRAVIS_BUILD_DIR}/dev-tools/domains_tmp.txt

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

sort -u ${input1} -o ${input1}

# *****************
# Activate Dos2Unix
# *****************

dos2unix ${input1}

# ******************************************
# Trim Empty Line at Beginning of Input File
# ******************************************

grep '[^[:blank:]]' < ${input1} > ${input2}
sudo mv ${input2} ${input1}

# ********************************************************
# Clean the list of any lines not containing a . character
# ********************************************************

cat ${input1} | sed '/\./!d' > ${input2} && mv ${input2} ${input1}

# **************************************************************************************
# Strip out our Dead Domains / Whitelisted Domains and False Positives from CENTRAL REPO
# **************************************************************************************


# *******************************
# Activate Dos2Unix One Last Time
# *******************************

dos2unix ${input1}

# ***************************************************************
# Start and End Strings to Search for to do inserts into template
# ***************************************************************

start1="# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###"
end1="# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###"
start2="# START DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###"
end2="# END DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###"
startmarker="##### Version Information #"
endmarker="##### Version Information ##"

# ******************************************************
# PRINT DATE AND TIME OF LAST UPDATE INTO HOSTS TEMPLATE
# ******************************************************

now="$(date)"
echo ${startmarker} >> ${tmphostsA}
printf "###################################################\n### Version: "${my_git_tag}"\n### Updated: "$now"\n### Bad Host Count: "${bad_referrers}"\n###################################################\n" >> ${tmphostsA}
echo ${endmarker}  >> ${tmphostsA}
mv ${tmphostsA} ${inputdbA}
ed -s ${inputdbA}<<\IN
1,/##### Version Information #/d
/##### Version Information ##/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/hosts.template
/##### Version Information #/x
.t.
.,/##### Version Information ##/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/hosts.template
q
IN
rm ${inputdbA}

# ********************************************************
# PRINT DATE AND TIME OF LAST UPDATE INTO DNSMASQ TEMPLATE
# ********************************************************

now="$(date)"
echo ${startmarker} >> ${tmphostsA}
printf "###################################################\n### Version: "${my_git_tag}"\n### Updated: "$now"\n### Bad Host Count: "${bad_referrers}"\n###################################################\n" >> ${tmphostsA}
echo ${endmarker}  >> ${tmphostsA}
mv ${tmphostsA} ${inputdbA}
ed -s ${inputdbA}<<\IN
1,/##### Version Information #/d
/##### Version Information ##/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/ddwrt-dnsmasq.template
/##### Version Information #/x
.t.
.,/##### Version Information ##/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/ddwrt-dnsmasq.template
q
IN
rm ${inputdbA}

# ********************************
# Insert hosts into hosts template
# ********************************

echo ${start1} >> ${tmphostsB}
for line in $(cat ${input1}); do
printf "0.0.0.0 ${line}\n" >> ${tmphostsB}
done
echo ${end1}  >> ${tmphostsB}
mv ${tmphostsB} ${inputdb1}
ed -s ${inputdb1}<<\IN
1,/# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/d
/# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/hosts.template
/# START HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/x
.t.
.,/# END HOSTS LIST ### DO NOT EDIT THIS LINE AT ALL ###/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/hosts.template
q
IN
rm ${inputdb1}

# **********************************
# Insert hosts into DNSMASQ template
# **********************************

echo ${start2} >> ${tmphostsB}
for line in $(cat ${input1}); do
printf '%s%s%s\n' "address=/" "${line}" "/" >> ${tmphostsB}
done
echo ${end2}  >> ${tmphostsB}
mv ${tmphostsB} ${inputdb1}
ed -s ${inputdb1}<<\IN
1,/# START DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###/d
/# END DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###/,$d
,d
.r /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/ddwrt-dnsmasq.template
/# START DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###/x
.t.
.,/# END DNSMASQ LIST ### DO NOT EDIT THIS LINE AT ALL ###/-d
w /home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/dev-tools/ddwrt-dnsmasq.template
q
IN
rm ${inputdb1}

# ************************************
# Copy Files into place before testing
# ************************************

sudo cp ${hosts} ${TRAVIS_BUILD_DIR}/hosts
sudo cp ${dnsmasq} ${TRAVIS_BUILD_DIR}/dnsmasq

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
