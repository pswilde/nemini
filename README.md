# Nemini 
### '/nɛmɪnaɪ/' _Nem-in-eye_

Web : https://paulwilde.uk/dev/nemini  
Gemini : gemini://paulwilde.uk/dev/nemini  
A simple (to configure) Gemini server capable of serving static files with virtual host support.  
Nemini also has a basic header/footer implementation - you can create a header and footer .gemini file in your root which will be applied to each page!  
Leveraging the good work done by @benob for the [Nim Gemini Library](https://github.com/benob/gemini)

## Features
* Will currently only serve static files
* Has a sort of virtual host capability (with multiple aliases)
* Is basically just a small test project of mine while I'm exploring the Gemini protocol but this is a functional server

## How to run
* Copy the ./config/nemini.sample.toml file to /etc/nemini/nemini.toml and edit your liking.
* Fixed in 0.2.0 ~~Copy and edit the `config/example_site.toml` file to your needs (multiple sites can be run by having multiple config files - currently different vhosts require different ports. This is WIP)~~
* Certificates are **REQUIRED**, so make sure you have those set in your config. (Automatically created if they don't exist)
* Host your files in the desired `root_dir` directory
* Run the `nemini` binary

### Parameters
Passing `--config` parameter with a config file location will allow the use of a custom config file saved wherever you wish.

## Certificates
The Nim Gemini Library requires certificates, so Nemini does too. 
If certificates don't exist they will be created via openssl when first run.

## Static files
Nemini is able to serve static gemtext files from your root directory or subdirectories.  
Your static files must use the extension `.gemini`, `.gmi` or `.gmni`. Currently, other file extensions are not supported, but easily fixed if there's need for it. 

## Contact me
Say "Hi"!  
I'm on the Fediverse at [@paul@notnull.click](https://notnull.click/paul)  
Or raise an issue here (Codeberg) for anything related to issues with Nemini
