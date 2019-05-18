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

# **********************
# Setting date variables
# **********************

yeartag=$(date +%Y)
monthtag=$(date +%m)

# ******************
# Set our Input File
# ******************
input=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt
pyfuncebleConfigurationFileLocation=${TRAVIS_BUILD_DIR}/.dev-tools/.PyFunceble.yaml
pyfuncebleProductionConfigurationFileLocation=${TRAVIS_BUILD_DIR}/.dev-tools/.PyFunceble_production.yaml

# **********************
# Run PyFunceble Testing
# **********************************************************
# Find PyFunceble at: https://github.com/funilrys/PyFunceble
# **********************************************************

RunFunceble () {

    yeartag=$(date +%Y)
    monthtag=$(date +%m)

    cd ${TRAVIS_BUILD_DIR}/.dev-tools

    hash PyFunceble

    if [[ -f "${pyfuncebleConfigurationFileLocation}" ]]
    then
        rm "${pyfuncebleConfigurationFileLocation}"
        rm "${pyfuncebleProductionConfigurationFileLocation}"
    fi

    PyFunceble --travis -dbr 5 --dns 1.1.1.1 1.0.0.1 --cmd-before-end "bash ${TRAVIS_BUILD_DIR}/.dev-tools/final-commit.sh" -ex --plain --autosave-minutes 4 --commit-autosave-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --commit-results-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}" -f ${input}

}

RunFunceble


exit ${?}
