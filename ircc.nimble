# Package

version       = "0.1.0"
author        = "Cameron Derwin"
description   = "Simple terminal-based irc client"
license       = "MIT"

binDir        = "bin"
srcDir        = "src"
bin           = @["ircc"]
skipExt       = @["nim"]

# Dependencies

requires "nim >= 0.17.0"

