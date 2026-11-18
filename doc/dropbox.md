Install Dropbox
===============

See https://www.dropbox.com/install-linux

```sh
mkdir ~/package
curl -SL "https://www.dropbox.com/download?plat=lnx.x86_64" -o ~/package/dropbox.tgz
tar -xvf ~/package/dropbox.tgz -C ~
```

"Download this Python script to control Dropbox from the command line."

```sh
curl -sSL https://www.dropbox.com/download?dl=packages/dropbox.py -o ~/bin/alternatives/dropbox
chmod 755 ~/bin/alternatives/dropbox
```
