# anynines Homework

This repository was created to help you to prepare for an interview or work sample.

If you do not understand a step, please contact human resources.

## BOSH Introduction

Read the [introduction to BOSH](https://bosh.io/docs#intro).

## Setup BOSH Lite

Go to [https://github.com/cloudfoundry/bosh-deployment](https://github.com/cloudfoundry/bosh-deployment) and install BOSH Lite on your local machine.

## Create nginx BOSH Release

Read the section [Using BOSH to package and distribute software](https://bosh.io/docs/create-release/).
Then create a BOSH release for nginx. It should display an empty page that is protected by basic authentication.
Please fork this repository into your GitHub workspace and push your source code to the new repository.

There should be a sample deployment file (e.g. *examples/nginx.yml*) that we can execute to test your BOSH release.
Please provide a README.md (markdown) in the top directory on how to test your BOSH release with `curl`.

