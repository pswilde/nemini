# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- added extra line if a footer exists to be placed before the footer (so content doesn't mush up)
- added redirect functionality - make the first page of the content 30 or 31 followed by the url to redirect to
### Fixed

## [0.2.4]

### Added
- Created better defaults for certificate. Also can be changed in config
- Can use a url with a directory name which will return an \_index.gemini/gmi/gmni file if in place

### Fixed

## [0.2.3]

### Added
- headers and footers!

### Fixed
- will now generate certs with alt names
- Error messages a little better
- Issue where pages will always show even if they don't exist due to the header and footer
### Removed

## [0.2.2]

### Added
- -v or --version flags to show current version
### Fixed
### Removed

## [0.2.0]

### Added 
- changed config file format - can now have multiple vhosts on one port
- added --config parameter to load custom config at start. If not set, nemini will check in a few places for one and if still not found will use the sample config

### Fixed
- Lowered required Nim version to 1.6.0
- Removed ability to open any file extension if given in the url (concerns about security). Can now only serve .gemini, .gmi or .gmni files  

## [0.1.0]

### Added
- First release
- Will serve static files only
- Certificates generated on start up unless they already exist
