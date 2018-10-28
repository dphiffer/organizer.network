# organizer.network

_Tools and strategies for social justice organizing._

## Early days

It's worth pointing out that this project is still in its early days, so proceed with a sense of adventure and patience.

## Developer setup

_This has only been tested on macOS and Ubuntu, but there's no reason to think it wouldn't work on other platforms._

Dependencies:

* node.js 8 or 10 ([macOS](https://nodejs.org/en/), [Ubuntu](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions))
* PostgreSQL 10 or 11 ([macOS](https://wiki.postgresql.org/wiki/Homebrew), [Ubuntu](https://tecadmin.net/install-postgresql-server-on-ubuntu/))

Clone the repo:

```
$ git clone https://github.com/organizer-network/organizer.network.git
$ cd organizer.network
```

Setup node.js packages:

```
$ npm install
```

Configure:

First make a copy of the example config file:

```
$ cp config.js.example config.js
```

* Edit `session_secret` in `config.js`

Open config.js and place a new key inside `session_secret`. To generate a new random key run the following command in your terminal.

```
$ openssl rand -hex 24
```

Your session_secret should look something like this:

```
session_secret: 'ad6fe27e6f551ec40f44b5f7ab46c45847e5d9s0813feb605',
```

* Edit `smtp` settings in `config.js` (optionally: set a [SendGrid](https://sendgrid.com/) API key)

Uncomment the `smtp` setting and update the keys with your personal email credentials OR uncomment the `sendgrid_api_key` and replace with an api key from your sendgrid account.

Database setup:

You will need to have [postgresql installed](https://wiki.postgresql.org/wiki/Homebrew). If you have Homebrew on a Mac you can run:

```
brew install postgres
```

Now you can create a local database.
(Ubuntu users may need to `createuser` and allow local connections before they do this, [described below](#postgresql-on-ubuntu).)

```
$ cd db/
$ make setup
```

Run the server:

```
$ npm run
```

Load it up in a browser! By default it can be reached from `https://localhost:5000/`. If you used a self-signed SSL certificate ([described below](#ssl-certificates)) you will need to click through a security warning.

## Versioning

* Current release: __[v0.0.5 "eeeeee"](https://github.com/organizer-network/organizer.network/releases/tag/v0.0.5)__
* Under development: __v0.0.6 "foom"__

Versions names are based on [Tom Gauld's *A Noisy Alphabet*](http://myjetpack.tumblr.com/post/65442529656/a-noisy-alphabet-a-new-screenprint-by-tom).

## Database tasks

Backup (it's a good idea to automate this):

```
$ cd db/
$ make backup
```

Migrate during upgrades:

```
$ cd db/
$ make migrate
```

## PostgreSQL on Ubuntu

Setup a Postgres account on Ubuntu:

```
$ sudo -u postgres createuser -d `whoami`
```

Setup Postgres to accept localhost connections on Ubuntu:

Edit `edit /etc/postgresql/10/main/pg_hba.conf` with the following line change.

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
```

## SSL certificates

The `ssl` section of `config.js` configures your SSL certificate/key. If you comment out this part of the configuration the server will use plain vanilla HTTP.

If you want to use a self-signed SSL certificate for development purposes:

```
$ cd ssl && openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem -subj "/C=US/ST=New York/L=Troy/O=organizer.network/CN=localhost"
```

## Production setup

There is a [setup guide](setup/setup.md) available that describes the process of signing up for a DigitalOcean droplet and deploying the server.
