# Deploying a nginx Server with Blank Page on BOSH Director

This [BOSH](https://bosh.io/) release deploys an nginx webserver.

***Warning: You may receive HTTP 403 Status ("forbidden") or see  "permission
denied" errors in your logs when using stemcells >= 3541.x; to fix, set the
worker's UNIX group to `vcap` at the top of your `nginx_conf` property with the
following line:***

```
user nobody vcap; # group vcap can read most directories
```

### 1. SETUP BOSH Director : vbox 

#### 1.1 Quick Start: Deployment Directory
Create a deployment directory for our BOSH director vbox

```bash
mkdir -p ~/deployments/vbox
cd ~/deployments/vbox
```
#### 1.2 Quick Start: Spin BOSH Director

Spin a BOSH director **vbox** using the following command

```bash
~/workspace/bosh-deployment/virtualbox/create-env.sh
```

### 2. Deploy ngnix server  

#### 2.1 Upload Ubuntu stemcell
Upload the stemcell into the BOSH director

```bash
bosh -e vbox us --sha1 2234c87513356e2f038ab993ef508b8724893683 https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=3586.100
```

#### 2.2 Upload nginx Release
Upload the nginx release into the BOSH director

```bash
bosh -e vbox ur https://github.com/cloudfoundry-community/nginx-release/releases/download/1.21.6/nginx-release-1.21.6.tgz
```

#### 2.3 Run deployment manifest
- nginx.yml manifest uses os: ubuntu-trusty version latest = v3586.100
- network is configred to ::default:: inline with that configured in cloud-config
- static_ips is configured to [ 10.244.0.34 ] to be used for curl output on just one IP 

```bash
bosh -e vbox -d nginx deploy ~/workspace/bosh-deployment/virtualbox/manifests/nginx_empty.yml
```

### 3. Test the release

Browse to <http://10.244.0.34/>; you should see a blank page.
or 
```bash
curl 10.244.0.34
```


