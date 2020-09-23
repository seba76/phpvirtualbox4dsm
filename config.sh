#!/bin/sh
PhpVirtualBoxUrl=https://github.com/phpvirtualbox/phpvirtualbox/archive/develop.zip
PhpVirtualBoxGitRepoUrl=https://github.com/phpvirtualbox/phpvirtualbox.git
PhpVirtualBoxVersion=6.1
PhpVirtualBoxVersionCommitHash=0000000

# If files don't exist they need to be downloaded
PhpVirtualBoxFile=phpVirtualBox.zip
PackageRoot=./package/www
Destination=${PackageRoot}/phpvirtualbox4dsm

DSM_PLAT=bromolow 

[ -f ./build.config ] && . ./build.config

WGET=$(which wget)
UNZIP=$(which unzip)

if [ "$WGET" == "" ]; then
  WGET=./wget
fi

if [ "$UNZIP" == "" ]; then
  UNZIP="./unzip"
fi

function download_phpvbox()
{
  if [ ! -f ./${PhpVirtualBoxFile} ]; then
	echo "Downloading ${PhpVirtualBoxFile}"
	$WGET ${PhpVirtualBoxUrl} -O ${PhpVirtualBoxFile}
	rm -rf ${Destination}
	PhpVirtualBoxVersionCommitHash=$(git ls-remote ${PhpVirtualBoxGitRepoUrl} HEAD | awk '{ print substr($1,1,7) }')
  fi
}

function generate_config()
{
  if [ ! -d ${Destination} ]; then
	${UNZIP} ${PhpVirtualBoxFile} -d ${PackageRoot}/
	VB=$(ls -d ${PackageRoot}/phpvirtualbox-*)
	mv ${VB} ${Destination}
	echo "Generating config.php.synology"
	cp ${Destination}/config.php-example ${PackageRoot}/config.php.synology
	sed -i -e "s|^var \$username = 'vbox';|var \$username = '@user@';|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^var \$password = 'pass';|var \$password = '@pass@';|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^var \$location = 'http://127\.0\.0\.1:18083/';|var \$location = '@location@';|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^#var \$noAuth = true;|var \$noAuth = @noAuth@;|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^#var \$enableCustomIcons = true;|var \$enableCustomIcons = @enableCustomIcons@;|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^#var \$enableAdvancedConfig = true;|var \$enableAdvancedConfig = @enableAdvancedConfig@;|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^#var \$startStopConfig = true;|var \$startStopConfig = @startStopConfig@;|g" ${PackageRoot}/config.php.synology
    sed -i -e "s|^#var \$enableGuestAdditionsVersionDisplay = true;|var \$enableGuestAdditionsVersionDisplay = true;|g" ${PackageRoot}/config.php.synology
	sed -i "/#var \$browserRestrictFolders/a var \$browserRestrictFolders = array('/volume1');" ${PackageRoot}/config.php.synology
	# fix for not working file browser
	#echo "Patching jqueryFileTree.php"
	#sed -i -e "s|^header('Content-type', 'application/json');|header('Content-type: application/json');|g" ${Destination}/endpoints/jqueryFileTree.php
  fi

  echo "Generating build.config"
  echo "PhpVirtualBoxFile=${PhpVirtualBoxFile}" > build.config
  echo "PhpVirtualBoxVersionCommitHash=${PhpVirtualBoxVersionCommitHash}" >> build.config
}

function update_info
{
  echo "Update version in INFO.sh"
  sed -i -e "s|^version=.*|version=\"${PhpVirtualBoxVersion}-${PhpVirtualBoxVersionCommitHash}\"|g" INFO.sh
}

case $1 in
  prep)
    download_phpvbox
    generate_config
    update_info
	echo "Ready to exec:"
	echo "         'sudo ../../pkgscripts-ng/PkgCreate.py --print-log -c -I -S -p ${DSM_PLAT} -v 6.2 -x0 -c phpvirtualbox4dsm'"   ;;
  clean)
    rm $PhpVirtualBoxFile
    rm -rf $Destination
    rm build.config
  ;;
  *)
    echo "Usage: ./config.sh prep|clean";
  ;;
esac
