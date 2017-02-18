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


## Quick Start

The execution of this image can be modified using environment variables. All this configuration can be divided into two groups:
- scheduling-related configuration by specifying values to the environment variables `TIME_ZONE` and `TIME_SPEC`, and
- dump-related operation by providing values to the environment variables `MONGODUMP_OPTIONS` and `OUTPUT_COMMAND`

There is also the `DATABASE_NAME` which is a mandatory variable that specifies the name of the database to backup.

The following command leaves a dump of the `foobar` database located in a server running in `localhost`:
```sh
docker run --rm --tty --interactive --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

The previous command will not work unless yout database is running in `localhost`, and it is not... The following sections will provide an insight of how to specify where the MySQL server is running and some other options.

## Setting parameters of the dump command

The image *is not* provided to work as is. The underlying `mongodump` command should be configured in order to succesfully perform a dump of the database. This task is done using the `MONGODUMP_OPTIONS` environment variable. The value this variable is configured as a string containing the options used for the `mongodump` command.

The following command performs a dump of the `foobar` database that is located in a MongoDB server that is running on the host `gungus` and is listening on the port `65535`:
```sh
docker run --rm --tty --interactive --env "MONGODUMP_OPTIONS=--host gungus:65535" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

## Changing the default management of the generated dump

The dump resulting from an execution of the dump command is stored, by default in a local directory of the container using the name of the database and a minute-resolution timestamp as a name for the resulting dump file. This behaviour can be modified by specifying the command to execute over the resulting dump output. This command may be changed using the `OUTPUT_COMMAND` environment variable. The default configured command is: `cat - > $DATABASE_NAME-$(date ++%Y%m%d%H%M).dump`.

The following command copies the resulting dump to a server located at the host `gungus` and listenting on the port `66535` using the `netcat` command:
```sh
docker run --rm --tty --interactive --env "OUPTUT_COMMAND=nc gungus 65535" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

**NOTE**: There are some considerations about the previous command such as security issues. This image *does not* provides solutions to those kind of problems.

The default behaviour of the image is to store the dump files in the `/dump` local directory. To access this backups from the host machine, this directory should be used as mount point for a volume.

The following command mounts the local `/srv/fisfis/backups` directory in the `/dump` directory of the container:
```sh
docker run --rm --tty --interactive --volume "/srv/fisfis/backups:/dump" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

## Specifying the dump scheduling format

The image is configured, by default, to execute the dump command once a day. This behaviour can be modified via the `TIME_SPEC` environment variable. Its value should be the same value as the specified for the Cron server. A detailed description of of this format can be found on the `crontab(5)` manual page on Unix systems.

The following command schedules a dump of the `foobar` database once a week:
```sh
$ docker run --rm --tty --interactive --env "TIME_SPEC=0 0 * * 0" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

Note that the previous command can be simplified by executing:
```sh
docker run --rm --tty --interactive --env "TIME_SPEC=@weekly" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

### Adjusting the timezone of the local clock

By default the container will schedule the dump command using the UTC time zone. This value can be changed by specifying the desired time zone as a value of the environment variable `TIME_ZONE`.

The following command uses Iran's timezone to configure the local time zone of automatic dumps of the `foobar` database:
```sh
docker run --rm --tty --interactive --env "TIME_ZONE=Iran" --env "DATABASE_NAME=foobar" bigtruedata/mongodump
```

### Ciphering the resulting dumps

The image supports ciphering the generated dumps using a symetric ciphering algorithm provided by OpenSSL. This feature is activated and specified using the `CIPHER_ALGORITHM` environment variable. If this variable is used, a password must be provide via the `CIPHER_PASSWORD` environment variable. To get more information on this mechanism you can check the documentation of the source image [`bigtruedata/dump`](https://hub.docker.com/r/bigtruedata/dump/).

The following command uses the `aes256`algorithm with the password `12345` to generate a encoded dump of the `foobar` database:
```sh
docker run --rm --tty --interactive --env "DATABASE_NAME=foobar" --env "CIPHER_ALGORITHM=aes256" --env "CIPHER_PASSWORD=12345" bigtruedata/mongodump
```
