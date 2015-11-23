#!/bin/bash

set -e
set -u
name=karaf
version=4.0.3
package_version="-1"
description="Apache Karaf is a modern and polymorphic container."
url="https://karaf.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
bin_package="apache-karaf-${version}.tgz"
bin_download_url="http://apache.belnet.be/karaf/${version}/${bin_package}"
origdir="$(pwd)"

#_ MAIN _#
rm -rf ${name}*.deb
if [[ ! -f "${bin_package}" ]]; then
  wget -c ${bin_download_url}
fi
mkdir -p tmp && pushd tmp
rm -rf karaf
mkdir -p karaf
cd karaf
mkdir -p build/usr/local/karaf
mkdir -p build/etc/default
mkdir -p build/etc/init
mkdir -p build/etc/init.d
mkdir -p build/etc/karaf
mkdir -p build/var/log/karaf
mkdir -p build/usr/local/karaf/lib/wrapper

cp ${origdir}/files/config/default/karaf.default build/etc/default/karaf
cp ${origdir}/files/config/init/karaf.init.d build/etc/init.d/karaf

# Updated to use the Binary package

tar zxf ${origdir}/${bin_package}
cd apache-karaf-${version}

mv etc/* ../build/etc/karaf

rm -rf bin/windows
cp ${origdir}/files/config/etc/karaf-wrapper.conf ../build/etc/karaf
mv * ../build/usr/local/karaf

#copy wrapper binaries files
cp ${origdir}/files/wrapper/karaf-wrapper ../usr/local/karaf/bin/karaf-wrapper
cp ${origdir}/files/wrapper/karaf.service ../usr/local/karaf/bin/karaf.service
cp ${origdir}/files/wrapper/libwrapper.so ../usr/local/karaf/lib/wrapper/libwrapper.so
cp ${origdir}/files/wrapper/karaf-wrapper.jar ../usr/local/karaf/lib/wrapper/karaf-wrapper.jar
cp ${origdir}/files/wrapper/karaf-wrapper-main.jar ../usr/local/karaf/lib/wrapper/karaf-wrapper-main.jar

cd ../build
pushd usr/local/karaf
popd

fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    --config-files etc/karaf \
    -m "${USER}@localhost" \
    --prefix=/ \
    -d oracle-j2sdk1.8 \
    --after-install ${origdir}/files/build/postinst \
    --after-remove ${origdir}/files/build/postrm \
    -s dir \
    -- .
mv karaf*.deb ${origdir}
popd
