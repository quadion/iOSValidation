# What is this? #

This is a set of scripts (currently only one) written in Ruby to be used in continuos integration (for example using [Jenkins](http://jenkins-ci.org)) to compile iOS projects.

# validateProvisioningProfile.rb #

This scripts helps validate that a given provisioning profile was signed with a given developer certificate, exported as a p12 file.

## Usage ##

The script accepts the following parameters:

    --certificate (-c): path to a p12 certificate.
    --profile (-p): path to a mobileprovision provisioning profile.
    --password (-P): optional password for the p12 certificate.

## Explanation ##

Provisioning profiles are PKCS7 signed messages. The message itself is an XML plist. The script extracts the plist, and within it looks for the certificate information.
The public key in the provisioning profile is then compared to the public key in the certificate file.
