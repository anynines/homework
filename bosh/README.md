# BOSH-deployed nginx Server

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

Upload Ubuntu stemcell

```bash
bosh -e vbox us https://s3.amazonaws.com/bosh-core-stemcells/warden/bosh-stemcell-3468-warden-boshlite-ubuntu-trusty-go_agent.tgz
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



