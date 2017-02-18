# The [`bigtruedata/mongodump`](https://hub.docker.com/r/bigtruedata/mongodump/) Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/bigtruedata/mongodump.svg)](https://hub.docker.com/r/bigtruedata/mongodump/)
[![Docker Stars](https://img.shields.io/docker/stars/bigtruedata/mongodump.svg)](https://hub.docker.com/r/bigtruedata/mongodump/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Table of Contents
- [Overview](#overview)


## Overview

This images provides a way of performing backups of a specific MongoDB database using the `mongodump` utility. Major features of this image include
- time zone adjustment,
- `mongodump` option specification,
- automatic scheduled backups, and
- command excution for generated backups and,
- symetric ciphering of resulting dumps.

The image can be used as a baseimage for other more specific images or can be run as a sidecar providing an automated backup to the MongoDB container is attached to.

The image is based in the [`bigtruedata/dump`](https://hub.docker.com/r/bigtruedata/dump/) image to provide automatic dump generation and ciphering capabilities.
