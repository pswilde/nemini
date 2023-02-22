# Nemini 
### '/nɛmɪnaɪ/' _Nem-in-eye_  
  
[![Build Status](https://nimble.directory/ci/badges/nemini/nimdevel/status.svg)](https://nimble.directory/ci/badges/nemini/nimdevel/output.html)
[![Build Status](https://nimble.directory/ci/badges/nemini/nimdevel/docstatus.svg)](https://nimble.directory/ci/badges/nemini/nimdevel/doc_build_output.html)

Web : https://paulwilde.uk/dev/nemini  
Gemini : gemini://paulwilde.uk/dev/nemini  
A simple (to configure) Gemini server capable of serving static files with virtual host support.  
Nemini also has a basic header/footer implementation - you can create a header and footer .gemini file in your root which will be applied to each page!  
Leveraging the good work done by @benob for the [Nim Gemini Library](https://github.com/benob/gemini)

## Features
* Serves static files
* Has virtual host capability with aliases
* Header and Footer can be applied to each page

## Installation
Nemini can be installed in a variety of ways. The processes below set Nemini up in such a way that it should almost 'just work'™ (i.e. copy folders system-wide, create nemini user, create systemd service, etc.)

### Arch Linux
Nemini is available in the AUR and can be installed via yay or your desired AUR package manager  
```sh
yay -S nemini-git
```
or  
```sh
git clone https://aur.archlinux.org/nemini-git.git
cd nemini-git
makepkg -si
```

### From Source
Nemini can be easily compiled from source within a few minutes.  
```sh
git clone https://codeberg.org/pswilde/nemini.git
cd nemini
make              # Will build the binary, effectively just runs `nimble build`
sudo make install # This will copy files and folders to system-wide locations
```

## How to run
* Edit the `/etc/nemini/nemini.toml` file as you need.
* Certificates are **REQUIRED**, so make sure you have those set in your config. (Automatically created if they don't exist)
* Host your gemini files in the desired `root_dir` directory
  
If Nemini has been installed via the above Installation methods, then `systemctl enable --now nemini` should start the service and get your server running. Otherwise you can run the binary directly if you have permission on the folders in your config file.

### Parameters
Passing `--config` parameter with a config file location will allow the use of a custom config file saved wherever you wish.

## Certificates
With Gemini, Certificates are mandatory. 
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
