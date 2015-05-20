[![Quadion Logo](https://quadion.github.io/shared-assets/images/quadion.svg)](http://www.quadiontech.com)

# What is this? #

This is a set of scripts (currently only one) written in Ruby to be used in continuos integration (for example using [Jenkins](http://jenkins-ci.org)) to compile iOS projects.

# validateProvisioningProfile.rb #

This scripts helps validate that a given provisioning profile was signed with a given developer certificate, exported as a p12 file.

## Why is this useful? ##
We compile our applications using [Jenkins](http://jenkins-ci.org) and distribute them OTA using [TestFlight](http://testflightapp.com). It turns out that when running xcodebuild to generate the build, you can sign it with a certificate that doesn't match the provisioning profile you are using. Even worse, the binary will be accepted in TestFlight, and fail when you try to install it.

## Usage ##

The script accepts the following parameters:

    --certificate (-c): path to a p12 certificate.
    --profile (-p): path to a mobileprovision provisioning profile.
    --password (-P): optional password for the p12 certificate.

## Explanation ##

Provisioning profiles are PKCS7 signed messages. The message itself is an XML plist. The script extracts the plist, and within it looks for the certificate information.
The public key in the provisioning profile is then compared to the public key in the certificate file.
