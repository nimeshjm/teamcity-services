#! /bin/bash

scriptpath=$(readlink -e "$0")
basedir=$(dirname "$scriptpath")
source $basedir/settings.conf
source $basedir/utils.sh

log info "Checking build environment"

NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
BOWER_VERSION=$(bower --version)
BB_LP_LATEST_VERSION=$(npm show bb-lp-cli version --loglevel error)
BB_LP_CURRENT_VERSION=$(bblp --version)
BB_VERSION=$(bb --version)


log info "NODE   -  ${NODE_VERSION}"
log info "NPM    -  ${NPM_VERSION}"
log info "BOWER  -  ${BOWER_VERSION}"
log info "BBLP   - current version  ${BB_LP_CURRENT_VERSION}"
log info "BBLP   - latest version  ${BB_LP_LATEST_VERSION}"
log info "BB version"



log info "Asserting environment variables. All variables must be set in order to use these scripts"
log info "You can set these in either the settings.conf file, or as environment variables"

assertset CONFIGURATION_ENV
assertset TOMCAT_WEBAPPS
assertset TOMCAT_LOGS_DIR
assertset BB_CONFIG_DIR
assertset MYSQL_USER_NAME
assertset MYSQL_PASSWORD
assertset MYSQL_HOST
assertset MYSQL_PORT

if [ "$VALID" = true ] ; then
    echo "Configuration is fine. Proceeding"
else
    echo "Missing variables. Please check the configuration and try again"
    exit 1
fi

assertexistsandwritable $TOMCAT_WEBAPPS
assertexistsandwritable $TOMCAT_LOGS_DIR
assertexistsandwritable $BB_CONFIG_DIR







