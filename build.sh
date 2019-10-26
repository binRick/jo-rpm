#!/bin/bash
DIR_BASE=$(cd ${BASH_SOURCE[0]%/*} && pwd)
SPEC_FILE=jo.spec
RELEASE_VERSION=$1

_REQUIRED_YUM_PACKAGES="rpm-build wget zlib-devel libpcap-devel libtool pkgconfig mariadb-server"


if [ "$RELEASE_VERSION" == "" ]; then
	  echo "First argument must be release version to compile"; exit 1
  fi

set -e


if [ -f ".${SPEC_FILE}" ]; then
	  unlink .${SPEC_FILE}
fi

cp ${SPEC_FILE}.template .${SPEC_FILE}
sed -i "s/__RELEASE_VERSION__/${RELEASE_VERSION}/g" .${SPEC_FILE}

sudo yum -y install $_REQUIRED_YUM_PACKAGES

mkdir -p ~/rpmbuild/SOURCES
wget https://github.com/jpmens/jo/releases/download/$RELEASE_VERSION/jo-$RELEASE_VERSION.tar.gz \
    -O ~/rpmbuild/SOURCES/jo-${RELEASE_VERSION}.tar.gz

rpmbuild -bb .${SPEC_FILE}
