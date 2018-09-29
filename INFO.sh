# INFO.sh
[ -f /pkgscripts/include/pkg_util.sh ] && . /pkgscripts/include/pkg_util.sh
[ -f /pkgscripts-ng/include/pkg_util.sh ] && . /pkgscripts-ng/include/pkg_util.sh 

package="phpvirtualbox4dsm"
version="5.2"
displayname="phpVirtualBox"
maintainer="seba"
maintainer_url="http://github.com/seba76/"
distributor="seba"
description="A web interface to manage and access Virtualbox machines."
report_url="https://github.com/seba76/phpvirtualbox4dsm/"
support_url="https://github.com/seba76/phpvirtualbox4dsm/"
install_dep_package="WebStation:PHP7.0"
#install_dep_services="apache-web"
#start_stop_restart_services="nginx"
#instuninst_restart_services="nginx"
thirdparty="true"
#support_conf_folder="yes"
#install_reboot="yes"
changelog="Version: 5.2"
reloadui="no"
startable="no"
#dsmuidir="ui"
adminurl="/phpvirtualbox4dsm/"
arch="noarch"
firmware="$1"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
