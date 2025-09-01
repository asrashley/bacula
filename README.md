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
- Bacularis API & Storage Daemon    asrashley/bacularis-api-sd:15.0.2
- Bacula File Daemon                asrashley/bacula-client:15.0.2
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

Two system accounts are needed on the Docker host. One for bacula and
one for postgres. The [first-time-setup.sh](./first-time-setup.sh) will
look for a user account `bacula` and an account called `postgres` or `mysql`.
If they don't exist, it will create them.

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
EMAIL=ubuntu
```

## Build the containers

```sh
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

The API host should now be available on `http://localhost:9097/'. The default
username is `admin` with password `admin`.

The web UI will need a user account to be created `http://localhost:9097/page,APIBasicUsers`
in the API host that is used by the web host.

After setting up the API, go to `http://localhost:9098/' to perform the setup
process for the Bacularis UI.

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

The matching `Director` entry in `bacula-fd.conf`nthat is put on the client device:

```
Director {
  Name = build-3-22-x86_64-dir
  Password = "vljflvjdfoj933encdkn9cc33r"
}

```
