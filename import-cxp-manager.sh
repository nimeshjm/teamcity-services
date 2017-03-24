#! /bin/bash
#
# Import CXP Manager and portal items
#

# Absolute path to this script
scriptpath=$(readlink -e "$0")
# Absolute path this script is in
basedir=$(dirname "$scriptpath")

echo "Script directory   -  ${scriptpath}"
echo "Basic directory   -  ${basedir}"

source $basedir/utils.sh
source $basedir/settings.conf

usage()
{
cat << EOF
usage: $0 [options]

This script imports CXP Manager.

OPTIONS:
   -h            Show this message
   -u <user>     Portal user name (default 'admin')
   -p <password> Portal user password  (default 'admin')
   -s <url>      Portal Server URL (default 'http://localhost:7777/portalserver')
   -i            Import the catalog items only, without CXP Manager
   -f            Force the import, even when CXP Manager is already imported
EOF
}


while getopts "u:p:s:ifh" OPTION
do
     case $OPTION in
         u)
             user=$OPTARG
             ;;
         p)
             password=$OPTARG
             ;;
         s)
             server=$OPTARG
             ;;
         i)
             itemsOnly=true
             ;;
         f)
             forceImport=true
             ;;
         h)
             usage
             exit
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

shift $((OPTIND-1))

user="admin"
password="admin"
server="$PORTAL_BASE_URL"
itemsOnly="false"`
forceImport="false"`

# 5.6.2
data='importGroupsFlag=true&_importGroupsFlag=on&importUsersFlag=true&_importUsersFlag=on&serverItems%5Bbackbase.com.2014.zenith%2Fcontent-repository.xml%5D%5BcontentRepository%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fcontent-repository.xml%5D%5BcontentRepository%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-containers.xml%5D%5BRootContainer%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-containers.xml%5D%5BRootContainer%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-containers.xml%5D%5BRowWithSlide_container%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-containers.xml%5D%5BRowWithSlide_container%5D=on&serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-widgets.xml%5D%5BStandard_Widget%5D=true&_serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-widgets.xml%5D%5BStandard_Widget%5D=on&serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-widgets.xml%5D%5BW3C_Widget%5D=true&_serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-widgets.xml%5D%5BW3C_Widget%5D=on&serverItems%5Bbackbase.com.2013.aurora%2Fcatalog-containers-adminDesignerOnly.xml%5D%5BManageable_Area_Closure%5D=true&_serverItems%5Bbackbase.com.2013.aurora%2Fcatalog-containers-adminDesignerOnly.xml%5D%5BManageable_Area_Closure%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BAppTitle_widget%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BAppTitle_widget%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BSideNav_widget%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BSideNav_widget%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BRootWidget%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BRootWidget%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BPortalNavigation_widget%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BPortalNavigation_widget%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BAjaxButton_widget%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-widgets.xml%5D%5BAjaxButton_widget%5D=on&serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-containers.xml%5D%5BColumn_table%5D=true&_serverItems%5Bbackbase.com.2012.aurora%2Ftemplate-containers.xml%5D%5BColumn_table%5D=on&serverItems%5Bbackbase.com.2013.aurora%2Ftemplate-pages.xml%5D%5BBlankPageTemplate%5D=true&_serverItems%5Bbackbase.com.2013.aurora%2Ftemplate-pages.xml%5D%5BBlankPageTemplate%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-pages.xml%5D%5Bcxp-manager-page%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-pages.xml%5D%5Bcxp-manager-page%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-pages.xml%5D%5BRootPage%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Fenterprise-catalog-pages.xml%5D%5BRootPage%5D=on&serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bportal-default%5D=true&_serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bportal-default%5D=on&serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bpage-default%5D=true&_serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bpage-default%5D=on&serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bwidget-default%5D=true&_serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bwidget-default%5D=on&serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bcontainer-default%5D=true&_serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Bcontainer-default%5D=on&serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Blink-default%5D=true&_serverItems%5B..%2FdefaultImportData%2Ftemplates.xml%5D%5Blink-default%5D=on&serverItems%5Bbackbase.com.2012.darts%2Fcatalog-containers.xml%5D%5BTargetingContainer%5D=true&_serverItems%5Bbackbase.com.2012.darts%2Fcatalog-containers.xml%5D%5BTargetingContainer%5D=on&serverItems%5Bbackbase.com.2012.darts%2Fcatalog-containers.xml%5D%5BTargetingContainerChild%5D=true&_serverItems%5Bbackbase.com.2012.darts%2Fcatalog-containers.xml%5D%5BTargetingContainerChild%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-pages.xml%5D%5BBB_Dashboard%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-pages.xml%5D%5BBB_Dashboard%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-pages.xml%5D%5BBB_Dashboard_Migration%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-pages.xml%5D%5BBB_Dashboard_Migration%5D=on&serverItems%5Bbackbase.com.2012.darts%2Ftemplate-containers.xml%5D%5BTCont%5D=true&_serverItems%5Bbackbase.com.2012.darts%2Ftemplate-containers.xml%5D%5BTCont%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BRowWithSlide%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BRowWithSlide%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BSimpleTabBox%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BSimpleTabBox%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BResponsiveGrid%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BResponsiveGrid%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BStaticLeftFlexRight%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BStaticLeftFlexRight%5D=on&serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BResizeableTwoColumn%5D=true&_serverItems%5Bbackbase.com.2014.zenith%2Ftemplate-containers.xml%5D%5BResizeableTwoColumn%5D=on&serverItems%5Bbackbase.com.2013.aurora%2Ftemplate-containers.xml%5D%5BManageableArea%5D=true&_serverItems%5Bbackbase.com.2013.aurora%2Ftemplate-containers.xml%5D%5BManageableArea%5D=on'
if [ "$itemsOnly" == "false" ]; then
   log info "Importing with CXP Manager"
   data='portals%5Bdashboard%5D.importIt=true&_portals%5Bdashboard%5D.importIt=on&_portals%5Bdashboard%5D.deleteIt=on&'$data

   if [ "$forceImport" == "false" ]; then
      res=`curl -i \
           --user $user:$password \
           --write-out %{http_code} \
           --silent \
           --output /dev/null \
           $server/portals/dashboard.xml`
      checkerror $? 0 "Ops, we could not import the portal $portalname. Error: $res"

      if [ "$res" -eq 200 ]; then
         # Not importing in this case
         log info "CXP Manager already imported"
         exit 0
      fi
   fi
else
   log info "Importing without CXP Manager"
fi

# Note that this only happens if it is itemsOnly or dashboard is not imported yet 
log info "Importing CXP Manager to $server"
res=`curl -i \
      --user $user:$password \
      --data $data \
      --write-out %{http_code} \
      --silent \
      --output /dev/null \
      $server/import`
checkerror $? 0 "CXP not imported successfully. curl failed: $res"
checkerror $res 302 "CXP not imported successfully: $res"
log info "CXP Manager successfully imported!"
