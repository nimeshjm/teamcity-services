#! /bin/bash
#
# This script drops and recreates the databases
#

basedir=`dirname $0`
source $basedir/utils.sh
if [ -e $basedir/settings.conf ]; then
  source $basedir/settings.conf
fi

# Databases:
# archive
# audit
# content
# orchestr
# portal

SCRIPT_DIR=$basedir/../../configuration/src/main/resources/db-scripts

# Archive
log info "Nuking (orchestrator) archive."
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT archive -e "SOURCE $SCRIPT_DIR/orchestrator/scripts/mysql/drop_archiving_database.sql"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT archive -e "SOURCE $SCRIPT_DIR/orchestrator/scripts/mysql/create_archiving_database.sql"

# Orchestrator
log info "Recreating orchestrator database."
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT orchestr -e "SOURCE $SCRIPT_DIR/orchestrator/scripts/mysql/drop_database.sql"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT orchestr -e "SOURCE $SCRIPT_DIR/orchestrator/scripts/mysql/create_database.sql"

# Audit
log info "Recreating audit database."
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT audit -e "SOURCE $SCRIPT_DIR/portalserver/scripts/mysql/audit_drop_schema.sql"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT audit -e "SOURCE $SCRIPT_DIR/portalserver/scripts/mysql/audit_schema.ddl"

# content
log info "Recreating content database."
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT content -e "SOURCE $SCRIPT_DIR/contentservices/mysql/drop-schema-bbcs.sql"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT content -e "SOURCE $SCRIPT_DIR/contentservices/mysql/create-schema-bbcs.sql"

# portal
log info "Recreating portal database."
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT portal -e "SOURCE $SCRIPT_DIR/portalserver/scripts/mysql/drop_schema.sql"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT portal -e "SOURCE $SCRIPT_DIR/portalserver/scripts/mysql/schema.ddl"
mysql -u$MYSQL_USER_NAME -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT portal -e "SOURCE $SCRIPT_DIR/portalserver/scripts/mysql/default-foundation-data-blank.sql"
