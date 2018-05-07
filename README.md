# Tron

## Setting up your own Tron node
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
* `genesis.block.witnesses` replace to yourself address - Register on [tronscan.org](https://tronscan.org/#/login) to get the yourself address
* `seed.node` `ip.list` replace to yourself ip list
and run the server
```
./gradlew run
```
#### Running as Super Node
Update the `localwitness` in the `config.conf` with your received password from registering at [tronscan.org](https://tronscan.org/#/login) and run the server
```
./gradlew run -Pwitness=true
```

For more configurations like _Running a local node and connecting to the public testnet_ or _Running a Super Node_ which is visible node on [tronscan.org](https://tronscan.org/#/network) visit the [java-tron GitHub Repository](https://github.com/tronprotocol/java-tron)

# Links
#### Great video tutorial from user _isybub6_ for starting your own Tron test node:
[![How to set up the Tron Test Net node](https://img.youtube.com/vi/AN9YwX7PqgY/3.jpg)](https://www.youtube.com/watch?v=AN9YwX7PqgY&feature=youtu.be&t=118)
#### Setup helper:
- Visit the [java-tron GitHub Repository](https://github.com/tronprotocol/java-tron) for more complete installation and configuring information.
- Community help for the config.conf to run a super node [Setup Representative/Delegate Node to Process blocks on TestNet](https://github.com/tronprotocol/java-tron/issues/513)
