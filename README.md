<img src="https://webassets.mongodb.com/_com_assets/cms/mongodb-logo-rgb-j6w271g1xn.jpg" width="256"> <img src="https://brew.sh/assets/img/homebrew-256x256.png" height="72">

# The MongoDB Homebrew Tap

This is a custom [Homebrew](https://brew.sh) tap for official MongoDB software.

## Setup

You can add the custom tap in a MacOS terminal session using:

```
$ brew tap mongodb/brew
```

## Installing Formulae

Once the tap has been added, use the instructions below to install the software packages you need. You can choose to install either the latest version of the MongoDB Server (recommended), or a specific version if desired.

### Installing the Latest mongodb-community Server, Shell, and the Database Tools Together

 * Install the latest available production release of the [MongoDB Community Server](https://docs.mongodb.com/manual/). This includes the MongoDB Server processes `mongod` and `mongos`, the `mongo` shell, the [MongoDB Database Tools](https://docs.mongodb.com/database-tools/), and the `install_compass` script to separately install [MongoDB Compass](https://docs.mongodb.com/compass/). Currently, this will install MongoDB Server 4.4.x.
 
   ```
   $ brew install mongodb-community
   ```

### Installing only the Shell or the Database Tools

 * Install only the latest [`mongo` shell](https://docs.mongodb.com/manual/mongo/) for connecting to remote MongoDB instances. If you installed the MongoDB Server in the step above, the shell was included in that installation. Use this command only if you need to install the `mongo` shell separately.

   ```
   $ brew install mongodb-community-shell
   ```

 * Install only the latest [MongoDB Database Tools](https://docs.mongodb.com/database-tools/), a suite of command-line tools (`mongoimport`, `mongoexport`, `mongodump`, etc) for working with a MongoDB Server instance. If you installed the MongoDB Server in the step above, the Database Tools were included in that installation. Use this command only if you need to install the Database Tools separately.

   ```
   $ brew install mongodb-database-tools
   ```

### Installing a Specific Version of the mongodb-community Server

Alternatively, you can install a specific version of the MongoDB Server if desired.

 * Install the latest 4.4.x production release of MongoDB Community Server:
   ```
   $ brew install mongodb-community@4.4
   ```

* Install the latest 4.2.x production release of MongoDB Community Server:
   ```
   $ brew install mongodb-community@4.2
   ```

 * Install the latest 4.0.x production release of MongoDB Community Server:
   ```
   $ brew install mongodb-community@4.0
   ```

 * Install the latest 3.6.x production release of MongoDB Community Server:
   ```
   $ brew install mongodb-community@3.6
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

## Uninstalling the mongodb-community Server

If you need to uninstall the MongoDB Server, use:

```
$ brew uninstall mongodb-community
```

Note that this does not uninstall the bundled Database Tools. To uninstall the Database Tools, additionally run the folowing:

```
$ brew uninstall mongodb-database-tools
```

## The Documentation

For more information, please reference the following documentation:

* [The MongoDB Server Manual](https://docs.mongodb.com/manual/)

* [The MongoDB Database Tools Documentation](https://docs.mongodb.com/database-tools/)

## Additional Information and Problem Reporting

This tap was created using the Homebrew documentation on [How to Create and Maintain a tap](https://github.com/Homebrew/brew/blob/master/docs/How-to-Create-and-Maintain-a-Tap.md).

You can find additional information in the [Homebrew project README](https://github.com/Homebrew/brew#homebrew).

If you're having issues with MongoDB please check out [our community support resources](https://www.mongodb.com/community-support-resources).

If you've found a bug please [open a JIRA ticket in the SERVER project](https://jira.mongodb.org).
