Upgrading nrsysmond
===================

This is a bit annoying. Basically, old versions of SmartOS images do not verify the signatures of packages. Newer
images are configured to verify all images.

So, you need to make available
* a signed packaged
* an unsigned package

These are located at:
* http://us-east.manta.joyent.com/wanelo/public/cache/new_relic/nrsysmond/x86_64
* http://us-east.manta.joyent.com/wanelo/public/cache/new_relic/nrsysmond/x86_64/unsigned

## Grabbing a version from Joyent

Let's assume that Joyent has made a version of nrsysmond available in pkgin. They have a version 2.0.2.111 available at
http://pkgsrc.joyent.com/packages/SmartOS/2015Q2/x86_64/All/nrsysmond-2.0.2.111.tgz

You can do the following:

```
cd ~/Downloads
wget http://pkgsrc.joyent.com/packages/SmartOS/2015Q2/x86_64/All/nrsysmond-2.0.2.111.tgz
mkdir nrsysmond
cd nrsysmond
tar xzf ../nrsysmond-2.0.2.111.tgz
cd ..
mput -f nrsysmond-2.0.2.111.tgz ~~/public/cache/new_relic/nrsysmond/x86_64
mput -f nrsysmond/nrsysmond-2.0.2.111.tgz ~~/public/cache/new_relic/nrsysmond/x86_64/unsigned
```


