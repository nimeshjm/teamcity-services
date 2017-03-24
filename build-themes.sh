#! /bin/bash
#
# This script deploys the wars to Tomcat.
#
#

basedir=`dirname $0`
cd $basedir/../../statics/spring-web-collection/src/springbank-theme

# creating .bbrc file in order to bb command connect to port 8080
# instead of 7777
echo '{"context":"portalserver","port":"8080","username":"admin","password":"admin"}' > $basedir/../../.bbrc

# build theme
bb theme-build
bb import-item

# build widgets
cd $basedir/../../statics/spring-web-collection/src/springbank-widget
bblp build
bb import-item

cd $basedir/../../statics/spring-web-collection/src/widget-transactions
bblp build
bb import-item