# Package

version       = "0.1.0"
author        = "Paul Wilde"
description   = "A basic Gemini server"
license       = "AGPL-3.0-or-later"
srcDir        = "src"
bin           = @["nemini"]


# Dependencies

requires "nim >= 1.6.10"
requires "gemini >= 0.2.0"
requires "parsetoml"
