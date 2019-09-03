<img src="https://webassets.mongodb.com/_com_assets/cms/mongodb-logo-rgb-j6w271g1xn.jpg" width="256"> <img src="https://brew.sh/assets/img/homebrew-256x256.png" height="72">

# The MongoDB Homebrew Tap

This is a custom [Homebrew](https://brew.sh) tap for official MongoDB software.

## Setup

You can add the custom tap in a MacOS terminal session using:

```
$ brew tap mongodb/brew
```

## Installing Formulae

Once the tap has been added locally, you can install individual software packages with:

```
$ brew install <formula>
```

For example:

 * Install the latest available production release of MongoDB Community Server ([including all command line tools](https://docs.mongodb.com/manual/reference/program/)). This will currently install MongoDB 4.2.x:
   ```
   $ brew install mongodb-community
   ```

 * Install the latest 4.2.x production release of MongoDB Community Server and command line tools:
   ```
   $ brew install mongodb-community@4.2
   ```

 * Install the latest 4.0.x production release of MongoDB Community Server and command line tools:
   ```
   $ brew install mongodb-community@4.0
   ```

 * Install the latest 3.6.x production release of MongoDB Community Server and command line tools:
   ```
   $ brew install mongodb-community@3.6
   ```

 * Only install the latest [`mongo` shell](https://docs.mongodb.com/manual/mongo/) for connecting to remote MongoDB instances:
   ```
   $ brew install mongodb-community-shell
   ```

## Default Paths for the mongodb-community Formula

In addition to installing the MongoDB server and tool binaries, the `mongodb-community` formula creates:

 * a configuration file: `/usr/local/etc/mongod.conf`
 * a log directory path: `/usr/local/var/log/mongodb`
 * a data directory path: `/usr/local/var/mongodb`

## Starting the mongodb-community Server

### Run `mongod` as a service

To have `launchd` start `mongod` immediately and also restart at login, use:

```
$ brew services start mongodb-community
```
If you manage `mongod` as a service it will use the default paths listed above. To stop the server instance use:

```
$ brew services stop mongodb-community
```

### Start `mongod` manually

If you don't want or need a background MongoDB service you can run:

```
$ mongod --config /usr/local/etc/mongod.conf
```
Note: if you do not include the `--config` option with a path to a configuration file, the MongoDB server does not have a default configuration file or log directory path and will use a data directory path of `/data/db`.

To shutdown `mongod` started manually, use the `admin` database and run `db.shutdownServer()`:

```
$ mongo admin --eval "db.shutdownServer()"
```

## Additional Information

This tap was created using the Homebrew documentation on [How to Create and Maintain a tap](https://github.com/Homebrew/brew/blob/master/docs/How-to-Create-and-Maintain-a-Tap.md).

You can find additional information in the [Homebrew project README](https://github.com/Homebrew/brew#homebrew).
