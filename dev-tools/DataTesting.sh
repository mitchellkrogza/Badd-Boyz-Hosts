#!/bin/bash
# **********************
# Run PyFunceble Testing
# **********************
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza

# ****************************************************************
# This uses the awesome PyFunceble script created by Nissar Chababy
# Find funceble at: https://github.com/funilrys/PyFunceble
# ****************************************************************

set -e

# **********************
# Setting date variables
# **********************

yeartag=$(date +%Y)
monthtag=$(date +%m)


if [[ -z ${TRAVIS_BUILD_DIR+x} ]]
then
    baseDir=.
else
    baseDir=${TRAVIS_BUILD_DIR}
fi

export PYFUNCEBLE_OUTPUT_LOCATION="${baseDir}/dev-tools"
export PYFUNCEBLE_CONFIG_LOCATION="${PYFUNCEBLE_OUTPUT_LOCATION}"
export PYFUNCEBLE_AUTO_CONFIGURATION="true"

# ******************
# Set our Input File
# ******************
input=${baseDir}/domains
# **********************
# Run PyFunceble Testing
# **********************************************************
# Find PyFunceble at: https://github.com/funilrys/PyFunceble
# **********************************************************

RunFunceble () {
    
    yeartag=$(date +%Y)
    monthtag=$(date +%m)
    
    hash PyFunceble
    
    PyFunceble -v
    python -VV
    PyFunceble --ci-end-command "bash ${baseDir}/dev-tools/FinalCommit.sh" --ci-commit-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --ci-end-commit-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}" -f ${input} --logging-level critical 
    
}

RunFunceble

##
exit ${?}
