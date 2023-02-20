# Nemini 
### '/nɛmɪnaɪ/' _Nem-in-eye_

Web : https://paulwilde.uk/dev/nemini  
Gemini : gemini://paulwilde.uk/dev/nemini  
A simple (to configure) Gemini server capable of serving static files with virtual host support.  
Nemini also has a basic header/footer implementation - you can create a header and footer .gemini file in your root which will be applied to each page!  
Leveraging the good work done by @benob for the [Nim Gemini Library](https://github.com/benob/gemini)

## Features
* Serves static files
* Has virtual host capability with aliases
* Header and Footer can be applied to each page

## How to run
* Copy the ./config/nemini.sample.toml file to /etc/nemini/nemini.toml and edit your liking.
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

## Headers and Footers
In your sites `root_dir`, add the files `header.gemini` and `footer.gemini` and they will be prepended and appended to your site content

## Contact me
Say "Hi"!  
I'm on the Fediverse at [@paul@notnull.click](https://notnull.click/paul)  
Or raise an issue here (Codeberg) for anything related to issues with Nemini
