# Deploying a nginx Server with Blank Page on BOSH Director

This [BOSH](https://bosh.io/) release deploys an nginx webserver.

***Warning: You may receive HTTP 403 Status ("forbidden") or see  "permission
denied" errors in your logs when using stemcells >= 3541.x; to fix, set the
worker's UNIX group to `vcap` at the top of your `nginx_conf` property with the
following line:***

```
user nobody vcap; # group vcap can read most directories
```

### 0. Quick Start

#### 0.0 Quick Start: Pre-requisites

You must have a BOSH Director and have uploaded stemcells to it. Our examples assume the [BOSH CLI v2](https://github.com/cloudfoundry/bosh-cli).

Follow the instructions to install BOSH Lite: <https://bosh.io/docs/bosh-lite>;
upload the Cloud Config, set the routes, but no need to deploy Zookeeper.

#### 0.2 Upload Ubuntu stemcell

```bash
bosh -e vbox us --sha1 2234c87513356e2f038ab993ef508b8724893683 https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=3586.100
```

#### 0.2 Upload nginx Release on the Director

```bash
bosh -e vbox ur https://github.com/cloudfoundry-community/nginx-release/releases/download/1.21.6/nginx-release-1.21.6.tgz
```

#### 0.2 Run deployment script
- nginx.yml manifest uses os: ubuntu-trusty version latest = v3586.100
- network is configred to ::default:: inline with that configured in cloud-config
- static_ips is configured to [ 10.244.0.34 ] to be used for curl output on just one IP 

```bash
bosh -e vbox -d nginx deploy manifests/nginx.yml
```


Clone the nginx repository:

```bash
cd ~/workspace
git clone https://github.com/cloudfoundry-community/nginx-release.git
cd nginx-release
```

#### 0.1 Quick Start: Upload release to BOSH Director

```bash
bosh -e vbox ur https://github.com/cloudfoundry-community/nginx-release/releases/download/1.21.6/nginx-release-1.21.6.tgz
```

#### 0.2 Quick Start: deploy

(This assumes you're in the `~/workspace/nginx` directory cloned in a previous step):

```bash
bosh -e vbox -d nginx deploy manifests/nginx-lite.yml
```

#### 0.3 Quick Start: test

Browse to <http://10.244.0.34/>; you should see the following:

![nginx_release_welcome](https://user-images.githubusercontent.com/1020675/27837760-14599acc-609b-11e7-8e1a-eb4d305be2b7.png)



