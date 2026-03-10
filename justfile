set shell := ["bash", "-cu"]

# src code...
import 'scripts/server.just'
import 'scripts/client.just'
# dev workflow
import 'scripts/dev.just'
import 'scripts/test.just'
import 'scripts/ci.just'
# build process
import 'scripts/deploy.just'

# Default: show available recipes grouped nicely
[default]
@_default:
    just --list
