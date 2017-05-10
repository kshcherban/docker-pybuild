#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <packagename=version>"
    exit 0
fi

PACKAGE_ORIG="$(echo $1 | cut -d'=' -f1)"
# Some python packages have upper case letters, that is not good for deb
PACKAGE="$(echo $PACKAGE_ORIG | tr '[:upper:]' '[:lower:]')"
VERSION="$(echo $1 | cut -d'=' -f2)"
BUILDROOT="/opt/buildroot"
MAINTAINER="John Doe <jdoe@example.com>"
CHDATE="$(date '+%a, %d %b %Y %H:%M:%S %z')"

mkdir -vp $BUILDROOT
cd $BUILDROOT
pip download --no-binary :all: ${PACKAGE}==${VERSION}
SRC=$(ls *.tar.* | grep -i ${PACKAGE})
EXT=$(echo $SRC | awk -F'.' '{print $(NF-1)"."$NF}')
mv -v $SRC python-${PACKAGE}_${VERSION}.orig.${EXT}
tar -xf python-${PACKAGE}_${VERSION}.orig.${EXT}
UNTARED="$(tar -tf python-${PACKAGE}_${VERSION}.orig.${EXT} | head -1)"
mkdir ${UNTARED}/debian

cat << EOF > ${UNTARED}/debian/control
Source: python-$PACKAGE
Section: python
Priority: optional
Maintainer: $MAINTAINER
Build-Depends:
 debhelper (>= 9),
 dh-python,
 python-all-dev,
 python-all-dbg,
 python3-all-dev (>= 3.3.2-5~),
 python3-all-dbg,
 python-setuptools,
 python3-setuptools
X-Python-Version: >= 2.1
X-Python3-Version: >= 3.0
Standards-Version: 3.9.5
Homepage: https://pypi.python.org/pypi/$PACKAGE

Package: python-$PACKAGE
Architecture: any
Depends: \${python:Depends}, \${shlibs:Depends}, \${misc:Depends}
Provides: \${python:Provides}
Description: $PACKAGE

Package: python3-$PACKAGE
Architecture: any
Depends: \${python3:Depends}, \${shlibs:Depends}, \${misc:Depends}
Provides: \${python3:Provides}
Description: $PACKAGE
EOF

touch ${UNTARED}/debian/copyright

mkdir ${UNTARED}/debian/source
echo '3.0 (quilt)' > ${UNTARED}/debian/source/format

cat << EOF > ${UNTARED}/debian/changelog
python-$PACKAGE (${VERSION}-1build1) UNRELEASED; urgency=medium

  * Initial release.

 -- $MAINTAINER  $CHDATE

EOF

cat << EOF > ${UNTARED}/debian/rules
#!/usr/bin/make -f

export PYBUILD_NAME=$PACKAGE
export PYBUILD_DISABLE=test

%:
	dh \$@ --with=python2,python3 --buildsystem=pybuild

EOF

echo 9 > ${UNTARED}/debian/compat

cd ${UNTARED}
dpkg-buildpackage -uc -F

pwd
ls -lah $BUILDROOT
