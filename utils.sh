#!/bin/bash

log() {
   case "$1" in
      warn)
         LEVEL=WARN
      ;;
      error)
         LEVEL=ERROR
      ;;
      *)
         LEVEL=INFO
      ;;
   esac

   printf "%30s %5s - %s\n" "`date`" "$LEVEL" "$2"
}

value() {
   for val in "$@"; do 
     if [ ! -z "$val" ]; then
       echo $val
       return
     fi
   done
}

checkerror() {
  if [ "$1" -ne "$2" ]; then
    log error "$3 ($1 expected $2)"
    cleanup
    exit 1
  fi
}

assertexists() {
  if [ ! -e "$1" ]; then
    log error "$2"
    cleanup
    exit 1
  else
    log info "$1 exists"
  fi
}

assertset() {
     if [ -n "${!1:-}" ] ; then
        log info "$1=${!1}"
    else
        log error "$1 is NOT set"
        VALID=false
     fi
}


assertexistsandwritable() {
  if [ -w "$1" ]; then
    log info "$1 is writable"
  else
    log info "$1 does not exist"
  fi
}


createtmpdir() {
  dir=$1
  if [ ! -d "$dir" ]; then
    log info "Temp directory $dir does not exist. Creating..."
    mkdir -p $dir
    assertexists $dir "Temp dir $dir does not exist and cannot be created"
    tmpfiles="$tmpfiles $dir"
  fi
}

cleanup() {
  log info "Cleaning up.."
  for file in $tmpfiles; do
    log info "Deleting $file"
    rm -rf $file
  done
}

banner()
{
cat << EOF
 ________  ________  ________  ___  __    ________  ________  ________  _______
|\\   __  \\|\\   __  \\|\\   ____\\|\\  \\|\\  \\ |\\   __  \\|\\   __  \\|\\   ____\\|\\  ___ \\
\\ \\  \\|\\ /\\ \\  \\|\\  \\ \\  \\___|\\ \\  \\/  /|\\ \\  \\|\\ /\\ \\  \\|\\  \\ \\  \\___|\\ \\   __/|
 \\ \\   __  \\ \\   __  \\ \\  \\    \\ \\   ___  \\ \\   __  \\ \\   __  \\ \\_____  \\ \\  \\_|/__
  \\ \\  \\|\\  \\ \\  \\ \\  \\ \\  \\____\\ \\  \\\\ \\  \\ \\  \\|\\  \\ \\  \\ \\  \\|____|\\  \\ \\  \\_|\\ \\
   \\ \\_______\\ \\__\\ \\__\\ \\_______\\ \\__\\\\ \\__\\ \\_______\\ \\__\\ \\__\\____\\_\\  \\ \\_______\\
    \\|_______|\\|__|\\|__|\\|_______|\\|__| \\|__|\\|_______|\\|__|\\|__|\\_________\\|_______|
                                                                \\|_________|


EOF
}


#--------------
# CS Functions
#--------------
#--
# Get content ID by path
#
# Params:
#   - server: the portal server server url
#   - repoid: the id of the CS repo
#   - path: the content path
#   - tmpfile: the temporary file to use
#--
getContentIdByPath() {
  local server=$1
  local repoid=$2
  local path=$3
  local tmpfile=$4
  local res=`curl \
      --user $user:$password \
      --write-out %{http_code} \
      --silent \
      --output $tmpfile \
      $server/content/atom/$repoid/path?path=$path`
  local resCode=$?
  if [ $resCode -ne 0 ]; then
     return $resCode
  fi
  if [ $res -ne 200 ]; then
    if [ $res -eq 404 ]; then
      echo "NOT FOUND"
      return 0
    fi
    return $res
  fi

  local ids=`xmllint --shell $tmpfile <<EOF 
cat //*[local-name()='propertyId'][@displayName="Object Id"]/*[local-name()='value']/text() 
EOF`
  resCode=$?
  if [ $resCode -ne 0 ]; then
     return $resCode
  fi
  local id
  for id in $ids; do
    [[ "$id" =~ [a-zA-Z0-9]+.* ]] && echo $id && return 0
  done
  echo "NOT FOUND"
  return 0
}
#--

#--
# Get descendants of the given content id
#
# Params:
#   - server: the portal server server url
#   - repoid: the id of the CS repo
#   - parentid: the content id 
#   - tmpfile: the temporary file to use
#--
getContentDescendantsIds() {
  local server=$1
  local repoid=$2
  local parentid=$3
  local tmpfile=$4
  res=`curl \
      --user $user:$password \
      --write-out %{http_code} \
      --silent \
      --output $tmpfile \
      "$server/content/atom/$repoid/descendants?id=$parentid&depth=1"`
  local resCode=$?
  if [ $resCode -ne 0 ]; then
     return $resCode
  fi
  if [ $res -ne 200 ]; then
     return $res
  fi
  
  ids=`xmllint --shell $tmpfile <<EOF 
cat //*[local-name()='propertyId'][@displayName="Object Id"]/*[local-name()='value']/text() 
EOF`
  local resCode=$?
  if [ $resCode -ne 0 ]; then
     return $resCode
  fi
  
  local allIds=()
  for id in $ids; do
    [[ "$id" =~ [a-zA-Z0-9]+.* ]] && allIds+=($id)
  done
  echo ${allIds[@]}
  return 0
}
#--

#--
# Deletes a content by ID
#
# Params:
#   - server: the portal server server url
#   - repoid: the id of the CS repo
#   - id: the ID od the content to delete
#   - tmpfile: the temporary file to use
#--
deleteContent() {
  local server=$1
  local repoId=$2
  local id=$3
  local tmpfile=$4
  res=`curl \
      --user $user:$password \
      --write-out %{http_code} \
      --silent \
      --output $tmpfile \
      -X "DELETE" \
      "$server/content/atom/$repoId/descendants?id=$id&allVersions=true&unfileObjects=delete&continueOnFailure=true"`
  local cmdres=$?
  echo $res
  return $cmdres
}
#--------
