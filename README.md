karaf-deb-packaging
===================

Simple debian packaging for Apache Karaf

### Changelog


# Differences to the original github project

Since forking https://github.com/DemisR/karaf-deb-packaging I have made the following changes:

1. Switched from oracle JDK 8, to openjdk 8
2. Updated to karaf version 4.0.7 (the currently newest stable release)
3. Use /var/lib/karaf/data instead of /usr/local/karaf/data
4. Use package version "-1" instead of "-3" (this is the first 4.0.7 version of the package)
5. Switched from using the the service wrapper (karaf-wrapper) to plain systemd start using the scripts and config from bin/contrib in the karaf 4.0.7 distro

## What must be done when upgrading to a new karaf version

1. Download and unpack the karaf tar gz file
2. Uninstall the karaf deb package (because this procedure will overwrite /etc/karaf/karaf.conf)
3. Cd to bin/contrib inside the unpacked karf file and run the following command as root (because the command overwrites /etc/karaf/karaf.conf) :
   ```sh
   $ ./karaf-service.sh -k /usr/local/karaf -d /var/lib/karaf/data -c /etc/karaf/karaf.conf -u karaf -l /var/log/karaf/karaf.log
   ```
4. Copy the generated files to the git project and commit them into git
   ```sh
   $ cp /etc/karaf/karaf.conf $HOME/git/karaf-deb-packaging/files/config/etc
   $ cp karaf*.service $HOME/git/karaf-deb-packaging/files/files/lib/systemd/system
   ```
5. Update the karaf version in the dist_karaf.sh script
6. Run the dist_karaf.sh script to create a .deb package for the new karaf version

# Pre-requisites - Install fpm

```sh
$ sudo apt-get update
$ sudo apt-get install ruby ruby-dev build-essential
$ sudo gem install fpm
```
# Options

You can change the karaf version in dist_karaf on new versions of both.

# Usage

```sh
$ ./dist_karaf.sh
```

# Installation

```sh
$ dpkg -i karaf_4.0.3-1_all.deb
```

or if you have your own repo:

```sh
$ ~/gpg-agent-headless.sh
$ reprepro -b /var/repositories/ includedeb trusty $@
$ apt-get install karaf
```
Note: Installs and runs as user 'karaf'. Easy to change for your needs.

## Post install

```sh

$ sudo update-rc.d karaf defaults 25

 Adding system startup for /etc/init.d/karaf ...
   /etc/rc0.d/K25karaf -> ../init.d/karaf
   /etc/rc1.d/K25karaf -> ../init.d/karaf
   /etc/rc6.d/K25karaf -> ../init.d/karaf
   /etc/rc2.d/S25karaf -> ../init.d/karaf
   /etc/rc3.d/S25karaf -> ../init.d/karaf
   /etc/rc4.d/S25karaf -> ../init.d/karaf
   /etc/rc5.d/S25karaf -> ../init.d/karaf
```

### Connect to instance
```sh
ssh -p 8101 karaf@localhost
```

## Tested Platforms

* Debian Wheezy

---

## Package info
Debian pkg: `karaf_4.0.3-1_all.deb`
Version :
  - karaf 4.0.3

Init scripts:
  - /etc/init.d/karaf

Configuration:
  - /etc/karaf
  - /etc/default/karaf

Logs:
  - /usr/local/karaf/data/log/
  - /var/log/karaf/

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
