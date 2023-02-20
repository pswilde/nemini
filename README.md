# Nemini [![Build Status](https://nimble.directory/ci/badges/jester/nimdevel/status.svg)](https://nimble.directory/ci/badges/jester/nimdevel/output.html)
A very basic Gemini server capable of serving static files with virtual host support.  
Leveraging the good work done by @benob for the [Nim Gemini Library](https://github.com/benob/gemini)

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
The Nim Gemini Library requires certificates, so Nemini does too. 
If certificates don't exist they will be created via openssl when first run.

## Static files
Nemini is able to serve static gemtext files from your root directory or subdirectories.  
Your static files must use the extension `.gemini`, `.gmi` or `.gmni`. Currently, other file extensions are not supported, but easily fixed if there's need for it. 

