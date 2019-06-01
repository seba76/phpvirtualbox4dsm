#!/bin/sh
PhpVirtualBoxUrl=https://github.com/phpvirtualbox/phpvirtualbox/archive/develop.zip
PhpVirtualBoxVersion=6.0

# If files don't exist they need to be downloaded
PhpVirtualBoxFile=phpVirtualBox.zip
PackageRoot=./package/www
Destination=${PackageRoot}/phpvirtualbox4dsm

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

  echo "Generating .config"
  echo "PhpVirtualBoxFile=${PhpVirtualBoxFile}" >> .config
}

function update_info
{
  echo "Update version in INFO.sh"
  sed -i -e "s|^version=.*|version=\"${PhpVirtualBoxVersion}\"|g" INFO.sh
}

case $1 in
  prep)
    download_phpvbox
    generate_config
    update_info
  ;;
  clean)
    rm $PhpVirtualBoxFile
    rm -rf $Destination
    rm .config
  ;;
  *)
    echo "Usage: ./config.sh prep|clean";
  ;;
esac
