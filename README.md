# Bacula 15.0.2 using Docker containers

Deploys the bacula community edition using Docker Containers.

This repository can be used to create and run the Docker containers
for a Bacula server, storage daemon and the web UI [bacularis](https://bacularis.app/)

If you want to use this repo, the [docker-compose.yml](./docker/docker-compose.yml)
will need to be modified, as it makes some assumptions about my home network.

In my setup there is an internal private domain `home.lan`. The host running the
Docker containers has a CNAME alias `bacula.home.lan`. The mail server has the DNS
name `mail.home.lan`.

## Images

- Base image                        asrashley/bacula-base:15.0.2
- Bacula Catalog                    asrashley/bacula-catalog:15.0.2
- Bacula Director                   asrashley/bacula-director:15.0.2
- Bacula Storage Daemon             asrashley/bacularis-sd:15.0.2
- Bacula File Daemon                asrashley/bacula-client:15.0.2
- Bacularis API                     asrashley/bacularis-api-sd:15.0.2
- Bacularis Web Gui                 asrashley/bacularis-web:5.4.0-alpine

## Install Docker

See https://docs.docker.com/engine/install/debian/#install-using-the-repository
for information about adding the Docker repository.

```sh
sudo apt update
sudo apt install docker-ce docker-buildx-plugin docker-compose-plugin
```

## First Time Setup

You need a package key to access the Debian repositories of Bacula
community edition. Go to https://www.bacula.org/bacula-binary-package-download/
to register for a key.

Three system accounts are needed on the Docker host. One for bacula,
one for postgres and one for web daemons. The [first-time-setup.sh](./first-time-setup.sh)
script will look for a user account `bacula`, an account called `postgres` or `mysql`
and an account called `www-data` or `nginx`. If they don't exist, it will create them.

```sh
cd docker
./first-time-setup.sh mykey
```

... where `mykey` is the Bacula access key

The script will create a `.env` file that looks a bit like this:

```
BACULA_KEY=123456789abcd
BACULA_VERSION=15.0.2
BACULA_GID=126
BACULA_UID=116
PG_GID=124
PG_UID=124
WWW_GID=33
WWW_UID=33
EMAIL=ubuntu
```

## Build the containers

```sh
docker compose build base
docker compose build
```

If the repository key is valid, it should successfully build all of the
conteiners.

## Running the containers

```sh
docker compose up -d
```

If all goes well, all of the services will start and a new database will have
been created in the `bacula-db` container.

The API host should now be available on http://localhost:9097/. The default
username is `admin` with password `admin`.

The web UI will need a user account to be created in the API host that is used by the web host
using http://localhost:9097/page,APIBasicUsers

After setting up the API, go to http://localhost:9098/ to perform the setup
process for the Bacularis UI. Use the hostname `bacula-api` for the connection to the
Bacularis API service.

## Creating backup clients

To create configurations for clients, you can either use the Bacularis UI,
or create new files in the [etc/clientdefs](./docker/etc/clientdefs/) directory.
Each file must end with the `.conf` extension.

An example client configuration `etc/clientdefs/client2.conf`:

```
Client {
  Name = client2-fd
  Address = 192.168.2.3
  FDPort = 9102
  Catalog = MyCatalog
  Password = "vljflvjdfoj933encdkn9cc33r"
  File Retention = 1 month
  Job Retention = 3 months
  AutoPrune = yes
}

Job {
  Name = "Client2"
  JobDefs = "DefaultJob"
  FileSet = "Full Set"
  Client = client2-fd
  Priority = 10
}

```

The matching `Director` entry in `bacula-fd.conf` that is put on the client device:

```
Director {
  Name = build-3-22-x86_64-dir
  Password = "vljflvjdfoj933encdkn9cc33r"
}

```

## Backup summary reports

To enable a summary email once all jobs for the day have completed, create a
file `etc/scripts/baculabackupreport.ini`. An example `baculabackupreport.ini` file:

```
[DEFAULT]
time = 24
server = Bacula Server
email = snoopy@doghouse.local
smtpserver = my.smtp.server

[baculabackupreport]
dbtype = pgsql
dbhost = bacula-db
dbuser = bacula
dbpass = bacula
time = 48
server = Bacula-15 docker container
always_fail_jobs_threshold = 4
webgui = baculum
webguisvc = http
webguihost = 192.168.169.170
webguiport = 80
urlifyalljobs = True
verified_job_name_col = both
copied_migrated_job_name_col = both
```

The `email` setting should be set to the email account you want to show as the sender
of the summary reports.

The `smtpserver` setting is the hostname or IP address of an smtp server that can deliver
the email.

The `webguihost` setting should be set to the hostname or IP address of the bacula
web container, as seen from the host or devices on the local network. It is used by the
report generator to create HTTP links to the bacula-web container.
