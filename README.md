karaf-deb-packaging
===================

Simple debian packaging for Apache Karaf

Forked from https://github.com/DemisR/karaf-deb-packaging and modified to use openjdk instead of Oracle Java, and modified to use the provided startup scripts instead of the proprietary karaf-wrapper.


# Tested Platforms

* Debian Jessie, amd64 (karaf 4.0.7)
* Debian Stretch, amd64 (karaf 4.0.7, karaf 4.1.1 and karaf 4.1.2)

# How to create and install the deb package

1. Install the pre-requisites (commands done as root)
   ```sh
   apt-get update
   apt-get install git maven openjdk-8-jdk postgresql ruby ruby-dev build-essential
   gem install fpm
   ```
2. How to create the .deb
   ```sh
   cd /tmp
   git clone https://github.com/steinarb/karaf-deb-packaging
   cd karaf-deb-packaging
   ./dist_karaf.sh
   mkdir -p /root/debs
   cp *.deb /root/debs
   ```
3. How to install the .deb package
   ```sh
   dpkg --install karaf_4.1.2-1_all.deb
   ```

# Differences to the original github project

Since forking https://github.com/DemisR/karaf-deb-packaging I have made the following changes:

1. Switched from oracle JDK 8, to openjdk 8
2. Updated to karaf version 4.0.7 (the currently newest stable release at the time of forking), later upgraded to karaf 4.1.1 and again upgraded to karaf 4.1.2
3. Use /var/lib/karaf/data instead of /usr/local/karaf/data
4. Use package version "-1" instead of "-3" (this is the first 4.0.7 version of the package)
5. Switched from using the the service wrapper (karaf-wrapper) to plain systemd start using the scripts and config from bin/contrib in the karaf 4.0.7 distro

## What must be done when upgrading to a new karaf version

1. Clone the project
   ```sh
   cd /tmp
   git clone https://github.com/steinarb/karaf-deb-packaging
   ```
2. Modify the karaf version in the /tmp/karaf-dep-packaging/dist_karaf.sh file:
   ```sh
   name=karaf
   version=4.1.2
   package_version="-1"
   ./dist_karaf.sh
   ```
3. Build the deb package
   ```sh
   cd /tmp/karaf-deb-packaging
   ./dist_karaf.sh
   ```
4. Uninstall the installed package and install the new package (using version 4.1.2 for the new package in the example, must be done as root):
   ```sh
   dpkg --purge karaf
   dpkg --install /root/debs/karaf_4.1.2-1_all.deb
   ```


### Connect to instance
```sh
ssh -p 8101 karaf@localhost
```

---

## Package info
Debian pkg: `karaf_4.1.2-1_all.deb`
Version :
  - karaf 4.1.2

Systemd service config:
  - /lib/systemd/system/karaf.service
  - /lib/systemd/system/karaf@.service

Configuration:
  - /etc/karaf
  - /etc/default/karaf

Logs:
  - /var/log/syslog

Binaries:
  - /usr/local/karaf/bin/

Data:
  - /usr/local/karaf/data

Network ports:
  - karaf shell: 8101

Users:
  - karaf : karaf

---

### Install jolokia: (in karaf shell)

feature:install jolokia

Default config http://hostname:8181/jolokia  karaf/karaf
