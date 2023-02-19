# Nemini [![Build Status](https://nimble.directory/ci/badges/jester/nimdevel/status.svg)](https://nimble.directory/ci/badges/jester/nimdevel/output.html)
A VERY basic Gemini server.  
Leveraging the good work done by @benob for the [Nim Gemini Library](https://github.com/benob/gemini/blob/master/src/gemini.nim)

## Features
* Will currently only serve static files
* Has a sort of virtual host capability (with multiple aliases)
* Is basically just a small test project of mine while I'm exploring the Gemini protocol but this is a functional server

## How to run
* Copy and edit the `config/example_site.toml` file to your needs (multiple sites can be run by having multiple config files - currently different vhosts require different ports. This is WIP)
* Certificates are **REQUIRED**, so put make sure you have those set in your config
* Host your files in the desired `root_dir` directory
* Run the `nemini` binary

## Certificates
The Nim Gemini Library requires certificates, so Nemini does too. These can be generated as follows:
```sh
openssl req -new -x509 -keyout <dir/priv.key> -out <dir/server.cert>
```
or use other types of certificate, i.e. LetsEncrypt/Certbot etc.


