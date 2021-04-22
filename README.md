# Konnng Labs

## docker-wordpress

Pre-configured docker image to run wordpress sites.

### Features

- data files outside Docker (database files and `/tmp` dir)
- PHP >= 7.4 w/ custom `.ini` file
- MySQL 5.7

### Requeriments

* Docker >= 17.04.0
* Port 8080 free (web server)
* Port 3306 free (mysql server)

### Structure

```
.
├── data
│   ├── database
│   └── tmp
├── www
└── php.ini
```

* `**data**` - data files, like mysql data files and `/tmp` directory.
* `**www**` - wordpress install directory. If empty, it will download a fresh copy of wordpress. You can use your own wordpress install/files.
* `**php.ini**` Custom PHP configuration file, you can update or add new values here to overwrite default PHP config.

### Setup

1. Clone repo
2. Open terminal and go to the root folder
3. Run `docker-compose build` to download images
4. Copy wordpress files to `./www`  folder (or leave empty for a fresh install)
5. Run `docker-compose up` to start
6. ???
7. PROFIT
