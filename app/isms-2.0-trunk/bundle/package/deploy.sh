#!/bin/bash
#
# Script to deploy the package to remote repository server.
#
# Usage: deploy.sh <version> <iphone-firmware-version>
if [ $# -ne 2 ]; then
	echo "Usage: deploy.sh <version> <iphone-firmware-version>"
	exit
fi

REPOSITORY_IP=iphone.nonsoft.com
REPOSITORY_USER=foo
REPOSITORY_PATH=/home/acdc/site

echo TODO - deploy the package to repository server
