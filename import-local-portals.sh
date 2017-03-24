#! /bin/bash
#
# This script sets up the local environment. After running this script, everything should be in place.
#

# Absolute path to this script
scriptpath=$(readlink -e "$0")
# Absolute path this script is in
basedir=$(dirname "$scriptpath")

source $basedir/utils.sh
if [ -e $basedir/settings.conf ]; then
  source $basedir/settings.conf
fi

projectrootdir="$basedir/../.."

bash $basedir/import-portals.sh ${projectrootdir}/cxp-exports
checkerror $? 0 "Error importing portals"

