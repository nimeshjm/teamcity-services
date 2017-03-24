#! /bin/bash
#
# This script waits for a message in a log file.
#
# IMPORTANT: this script only works with Bash 
# 

scriptpath=$(readlink -e "$0")
basedir=$(dirname "$scriptpath")
source $basedir/settings.conf

usage()
{
cat << EOF
usage: $0 <pattern> <logfile>

This script waits for a message in the given logfile file. The pattern should be a grep pattern.

pattern: the pattern to find in the file. It is a grep pattern.
logfile: the file to look for the message in. 

EOF
}

pattern=$1
if [ -z "$pattern" ]; then
  usage
  exit 1
fi

logfile=$2
if [ -z "$logfile" ]; then
  usage
  exit 1
fi

grep -m 1 "$pattern" <(tail -f $logfile) > /dev/null 2>&1
