#! /bin/bash
#
# Imports statics packages from a directory into portal server  
#

# Absolute path to this script
scriptpath=$(readlink -e "$0")
# Absolute path this script is in
basedir=$(dirname "$scriptpath")

echo "Script directory   -  ${scriptpath}"
echo "Basic directory   -  ${basedir}"

source $basedir/utils.sh
source $basedir/settings.conf

projectrootdir="$basedir/../../statics/collection"

log info "Importing collection..."

cd $projectrootdir

log info "Importing Dashbaord"
sudo npm run import-dashboard -- --port 8080 --verbose

checkerror $? 0 "Error importing collection"

log info "collection Imported."