#! /bin/bash

# Absolute path to this script
scriptpath=$(readlink -e "$0")
# Absolute path this script is in
basedir=$(dirname "$scriptpath")

echo "Script directory   -  ${scriptpath}"
echo "Basic directory   -  ${basedir}"

source $basedir/utils.sh
source $basedir/settings.conf
bash $basedir/validate.sh

## Condition to check predefined folder names availability
if [ \( -z "$TOMCAT_FOLDER" \) -o \( -z "$TOMCAT_WEBAPPS" \) -o \( -z "$TOMCAT_LOGS_DIR" \) -o \( -z "$BB_CONFIG_DIR" \) ]; then
    log error predefined folder names are not available
    exit 1
fi

log info "Stopping Tomcat..."
sudo sh $TOMCAT_FOLDER/bin/shutdown.sh

#log info "Destroying databases"
bash $basedir/nuke-databases.sh

## Allowing jenkins user to delete the files
sudo usermod -a -G tomcat7 jenkins
sudo usermod -a -G adm jenkins

## Cleaning folder
log info "Cleaning logs... "
sudo chmod 777 $TOMCAT_LOGS_DIR
sudo chmod -R g+s $TOMCAT_LOGS_DIR
rm -rf $TOMCAT_LOGS_DIR/*
checkerror $? 0 "Could not clean logs."
#sudo chmod 766 $TOMCAT_LOGS_DIR

log info "Cleaning web app folder ... "
sudo chmod -R g+w $TOMCAT_WEBAPPS
sudo chmod -R g+s $TOMCAT_WEBAPPS
rm -rf $TOMCAT_WEBAPPS/contentservices*
rm -rf $TOMCAT_WEBAPPS/portalserver*
rm -rf $TOMCAT_WEBAPPS/orchestrator*
rm -rf $TOMCAT_WEBAPPS/solr*

#sudo chmod -R g-w $TOMCAT_WEBAPPS

log info "Cleaning config... "
sudo chmod -R 777 $BB_CONFIG_DIR/
rm -rf $BB_CONFIG_DIR/*
mkdir $BB_CONFIG_DIR//data
mkdir $BB_CONFIG_DIR//itemRoot
checkerror $? 0 "Could not clean config"

log info "Starting Tomcat..."
sudo sh $TOMCAT_FOLDER/bin/startup.sh

bash $basedir/wait-msg.sh "Server startup in" $TOMCAT_LOG
# checkerrorindeploy $TOMCAT_LOG
log info "Tomcat Started!"

log info "Installing configuration files..."
sudo unzip -o -q $basedir/../../configuration/target/$CONFIG_ZIP -d $BB_CONFIG_DIR
checkerror $? 0 "Could not unzip $basedir/../../configuration/$CONFIG_ZIP to $BB_CONFIG_DIR"

#Copy war files
log info "Deploying web applications on Tomcat..."
sudo -u tomcat7 cp $basedir/../dist/wars/contentservices.war $TOMCAT_WEBAPPS
bash $basedir/wait-msg.sh "contentservices.war has finished" $TOMCAT_LOG
log info "Content Services Started!"

sudo -u tomcat7 cp $basedir/../dist/wars/orchestrator.war $TOMCAT_WEBAPPS
bash $basedir/wait-msg.sh "orchestrator.war has finished" $TOMCAT_LOG
log info "Orchestrator Started!"

sudo -u tomcat7 cp $basedir/../dist/wars/portalserver.war $TOMCAT_WEBAPPS
bash $basedir/wait-msg.sh "portalserver.war has finished" $TOMCAT_LOG
log info "Portal Server Started!"

#log info "Import CXP manager..."
bash $basedir/import-cxp-manager.sh

#log info "Import local statistics..."
bash $basedir/import-local-statics.sh
