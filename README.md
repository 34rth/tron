# Tron

## Updates
- 2018-05-21: We added a small bash script for cron checking Tron github and start/restarting your Super Node. Check it out! [compare.sh](https://github.com/34rth/tron/blob/master/compare.sh)
- 2018-05-19: Update of testing _34rth private Tron Testnet_ from user [pynki](https://github.com/34rth/tron/pulls?q=is%3Apr+author%3Apynki). Thank you!

## 34rth private Tron Testnet
Our testnet nodes (2 Full Nodes, 1 Super Node) are running at the moment on the same machine, but we will expand it in the future.
The branch is **master** and we will update it daily.
Please feel free to comment and [post issues](https://github.com/34rth/tron/issues).

* p2p.version is 333
* The Super Node IP:PORT is 94.130.165.82:18889 the RPC port is 50052
* Full Node 1 IP:PORT is 94.130.165.82:18890 the RPC port is 50053
* Full Node 2 IP:PORT is 94.130.165.82:18891 the RPC port is 50054

### Connect to our private Tron Testnet
Please follow the instructions of section **Setting up your own Tron Node** for building your own Node.
Please copy the config.conf file and edit following:

* `node.discovery` `_YOUR_IP` to your IP address
* Our `node.rpc.port` is `50052`
* `node.p2p.version` to `333`
* Add our seed Node in the array `seed.node.ip.list`: `94.130.165.82:18889`
* Copy the `genesis.block` from following example
* `block.needSyncCheck` has to be `true`

```
net {
  type = testnet
}
node.discovery = {
  enable = true
  persist = true
  bind.ip = _YOUR_IP
  external.ip = _YOUR_IP
}
node {
  trustNode = "94.130.165.82:50052"
  p2p {
    version = 333
  }
}
seed.node = {
  ip.list = 
  [
    "94.130.165.82:18889"
  ]
}
genesis.block = {
 # Reserve balance
  assets = [
    {
      accountName = "Devaccount"
      accountType = "AssetIssue"
      address = "27d3byPxZXKQWfXX7sJvemJJuv5M65F3vjS"
      balance = "10000000000000000"
    },
    {
      accountName = "Zion"
      accountType = "AssetIssue"
      address = "27fXgQ46DcjEsZ444tjZPKULcxiUfDrDjqj"
      balance = "15000000000000000"
    },
    {
      accountName = "Sun"
      accountType = "AssetIssue"
      address = "27SWXcHuQgFf9uv49FknBBBYBaH3DUk4JPx"
      balance = "10000000000000000"
    },
    {
      accountName = "Blackhole"
      accountType = "AssetIssue"
      address = "27WtBq2KoSy5v8VnVZBZHHJcDuWNiSgjbE3"
      balance = "-9223372036854775808"
    }
  ]
  witnesses = [
    {
      address: 27SYSXHYY9TNomsjPaVbFt9FpcKBpkWYYUa
      url = "https://tron.34rth.com/",
      voteCount = 101
    }
  ]
}
block = {
  needSyncCheck = true # first node : false, other : true
  maintenanceTimeInterval = 5000 // 1 day: 86400000(ms), 6 hours: 21600000(ms)
}
```

Or clone this repo and copy the private-testnet-example.conf to your java-tron folder:

```
git clone https://github.com/34rth/tron
cp tron/private-testnet-example.conf YOUR_PATH/config.conf
```

Start as Full Node:
```
cd YOUR_PATH
java -Djava.net.preferIPv4Stack=true -XX:+HeapDumpOnOutOfMemoryError -Xms1024m -Xmx8024m -Dfile.encoding=UTF-8 -jar java-tron.jar -c config.conf
```
Start as Super Node:
```
cd YOUR_PATH
java -Djava.net.preferIPv4Stack=true -XX:+HeapDumpOnOutOfMemoryError -Xms1024m -Xmx8024m -Dfile.encoding=UTF-8 -jar java-tron.jar -p YOUR_PRIVATE_KEY --witness -c config.conf
```

## Setting up your own Tron Node
Setup ubuntu and then execute following comands:

```
sudo apt-get update && sudo apt-get upgrade
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer screen
```

Get the [java-tron repository](https://github.com/tronprotocol/java-tron) and build it

```
git clone https://github.com/tronprotocol/java-tron.git 
cd java-tron
git checkout -t origin/master
./gradlew build
```
### Running
#### Running a Private Testnet
Run the code and check it works
```
./gradlew run
```
Stop it and now copy the `config.conf` and start modify it
```
cp src/main/resources/config.conf .
nano config.conf
```
Update the 
* `seed.node.ip.list` array with your private testnet - the IPs are allocated by yourself, e.g. add ours `94.130.165.82` 
and run the server
```
./gradlew run
```
#### Running as Super Node
Update the `config.conf`:

* the `localwitness` in  with your received password from registering at [tronscan.org](https://tronscan.org/#/login) 
* `seed.node.ip.list` replace to yourself ip list
* the first Super Node start, `needSyncCheck` should be set `false`
* set `p2pversion` to `61`

and run the server
```
./gradlew run -Pwitness=true
```
or
```
cd build/libs
java -Djava.net.preferIPv4Stack=true -Xms1024m -Xmx8024m -jar java-tron.jar -p _YOUR_PRIVATE_KEY_ --witness -c _YOUR_CONFIG_PATH_/config.conf
```

For more configurations like _Running a local node and connecting to the public testnet_ or _Running a Super Node_ which is visible node on [tronscan.org](https://tronscan.org/#/network) visit the [java-tron GitHub Repository](https://github.com/tronprotocol/java-tron)

# Scripts

## A small bash script for cron checking Tron github and start/restarting your Super Node. Check it out! 
[compare.sh](https://github.com/34rth/tron/blob/master/compare.sh)
This script checks for git updates and especially changes in the config.conf (Before running this script, 
should have installed everything necessary and checked out https://github.com/tronprotocol/java-tron)
If there are changes, we rebuild the code, copy the new config.conf and restart the server with our witness key
Edit your crontab with crontab -e and add e.g. a check every 10 minutes:
*/5 * * * * /home/YOUR_PATH/compare.sh
Before adding to cron, test your script in the command line and for cron errors check your syslog.

# Links
#### Great video tutorial from user _isybub6_ for starting your own Tron test node:
[![How to set up the Tron Test Net node](https://img.youtube.com/vi/AN9YwX7PqgY/3.jpg)](https://www.youtube.com/watch?v=AN9YwX7PqgY&feature=youtu.be&t=118)
#### Setup helper:
- Visit the [java-tron GitHub Repository](https://github.com/tronprotocol/java-tron) for more complete installation and configuring information.
- Community help for the config.conf to run a super node [Setup Representative/Delegate Node to Process blocks on TestNet](https://github.com/tronprotocol/java-tron/issues/513)
