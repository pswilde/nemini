# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 

### Fixed
- Lowered required Nim version to 1.6.0
- Removed ability to open any file extension if given in the url (concerns about security). Can now only serve .gemini, .gmi or .gmni files  

## [0.1.0]

### Added
- First release
- Will serve static files only
- Certificates generated on start up unless they already exist