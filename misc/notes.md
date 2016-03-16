# Helpful snippets

Creating ctags so you can jump to code in vim
```
  ctags -R `bundle show rails` app/* lib/features/*
```

Check if there are any open handles to a file - returns a pid. also see `lsof`
```bash
  fuser filename
```

## Apache

Apache and passenger config links
* https://www.phusionpassenger.com/library/install/apache/install/oss/precise/
* https://www.phusionpassenger.com/library/install/apache/working_with_the_apache_config_file.htmlt
* http://stackoverflow.com/questions/853532/slow-initial-server-startup-when-using-phusion-passenger-and-rails
* http://stackoverflow.com/questions/20099475/invalid-command-passengerdefaultruby

Self signed wildcard certificate

```bash
  openssl genrsa 2048 > host.key
  openssl req -new -x509 -nodes -sha1 -days 3650 -key host.key > host.cert
  #[enter *.domain.com for the Common Name]
  openssl x509 -noout -fingerprint -text < host.cert > host.info
  cat host.cert host.key > host.pem
  chmod 400 host.key host.pem
```


## Unix

Fixing/Updating locales - this sets it to UTC NZ.
```bash
  sudo apt-get install language-pack-en-base

  sudo locale-gen en_NZ.UTF-8
  sudo dpkg-reconfigure locales

  localedef -i en_NZ -f UTF-8 en_NZ.UTF-8

  edit /etc/default/locale
  LC_CTYPE="en_NZ.UTF-8"
```

Update machine timezone
* Ubuntu: `dpkg-reconfigure tzdata`
* Redhat: `redhat-config-date`
* CentOS/Fedora: `system-config-date`
* FreeBSD/Slackware: `tzselect`
[Change Timezone in Linux](http://www.wikihow.com/Change-the-Timezone-in-Linux)

Changing a machine mac address on unix
```bash
  ifconfig eth0 down
  ifconfig eth0 hw ether 00:81:48:BA:d2:30
  ifconfig eth0 up
  ifconfig eth0 |grep HWaddr
```

Fix virtualbox display
```bash
  sudo apt-get install virtualbox-guest-dkms
```

## Rails

Eager load from rails console
```ruby
  Rails.application.eager_load!
```
