#!/bin/bash

set -e
set -u
name=karaf
version=4.0.7
package_version="-3"
description="Apache Karaf is a modern and polymorphic container."
url="https://karaf.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
bin_package="apache-karaf-${version}.tar.gz"
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


cp ${origdir}/files/config/default/karaf.default build/etc/default/karaf
sed 's/^#\(JAVA_HOME=\)/\1\/usr\/lib\/jvm\/java-8-openjdk-amd64/' <${origdir}/files/config/init/karaf.init.d >build/etc/init.d/karaf

# Updated to use the Binary package

tar zxf ${origdir}/${bin_package}
cd apache-karaf-${version}

# Config files
mv etc/* ../build/etc/karaf
cp ${origdir}/files/config/etc/karaf-wrapper.conf ../build/etc/karaf
cp ${origdir}/files/config/etc/org.ops4j.pax.logging.cfg ../build/etc/karaf
cp ${origdir}/files/config/etc/org.ops4j.pax.url.mvn.cfg ../build/etc/karaf
cp ${origdir}/files/config/etc/shell.init.script ../build/etc/karaf
mv * ../build/usr/local/karaf/
rmdir ../build/usr/local/karaf/etc

#copy wrapper binaries files
mkdir -p ../build/usr/local/karaf/lib/wrapper
cp ${origdir}/files/wrapper/karaf-wrapper ../build/usr/local/karaf/bin/
cp ${origdir}/files/wrapper/karaf.service ../build/usr/local/karaf/bin/
cp ${origdir}/files/wrapper/libwrapper.so ../build/usr/local/karaf/lib/wrapper/
cp ${origdir}/files/wrapper/karaf-wrapper.jar ../build/usr/local/karaf/lib/wrapper/
cp ${origdir}/files/wrapper/karaf-wrapper-main.jar ../build/usr/local/karaf/lib/wrapper/

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
    -d openjdk-8-jdk \
    --after-install ${origdir}/files/build/postinst \
    --after-remove ${origdir}/files/build/postrm \
    -s dir \
    -- .
mv karaf*.deb ${origdir}
popd
