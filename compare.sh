#!/bin/bash
# This script checks for git updates and especially changes in the config.conf (Before running this script, 
# should have installed everything necessary and checked out https://github.com/tronprotocol/java-tron)
# If there are changes, we rebuild the code, copy the new config.conf and restart the server with our witness key
# Edit your crontab with crontab -e and add e.g. a check every 10 minutes:
# */5 * * * * /home/YOUR_PATH/compare.sh
# Before adding to cron, test your script in the command line and for cron errors check your syslog.

# Edit TRON_PATH and TRON_KEY to your needs
TRON_PATH=_YOUR_FULL_PATH_
TRON_KEY=_YOUR_KEY_

# Other config values
TRON_CONFIG="config.conf"
TRON_SCREEN="tron"
TRON_PULL=$(git pull)
TRON_PULL_GOOD="Already up-to-date."
TRON_TIME=$(date +"%Y-%m-%d %T")

# ###############################################################################
echo "$TRON_TIME: Checking Tron github"
echo "Path: $TRON_PATH"
echo "Config: $TRON_CONFIG"

cd $TRON_PATH
if [[ "$TRON_PULL" == "$TRON_PULL_GOOD" ]]; then
  echo "HAPPY: $TRON_PULL_GOOD"; 
else
  echo "1. Rebuiding";
  ./gradlew build
  
  if !(cmp -s config.conf src/main/resources/config.conf); then
    echo "2. config.conf files are different!!!";
    cp src/main/resources/config.conf $TRON_CONFIG
  else
    echo "2. config.conf files are good";
  fi
  
  echo "3. Trying to start/restart";
    if ! ( screen -ls | grep $TRON_SCREEN > /dev/null); then
    echo "4. Create new screen";
    screen -dmS $TRON_SCREEN;
  else
    echo "4. Stopping running";
    screen -X -S $TRON_SCREEN stuff "^C"
  fi
  
  cp build/libs/java-tron.jar java-tron.jar 
  
  # TEST:
  # screen -S $TRON_SCREEN -X stuff "echo $TRON_TIME\ncd $TRON_PATH && echo $TRON_KEY \n echo $TRON_CONFIG \n echo 'Started' \n"
  screen -S $TRON_SCREEN -X stuff "echo $TRON_TIME\ncd $TRON_PATH && java -Djava.net.preferIPv4Stack=true -XX:+HeapDumpOnOutOfMemoryError -Xms1024m -Xmx80024m -Dfile.encoding=UTF-8 -jar $TRON_PATH/java-tron.jar -p $TRON_KEY --witness -c $TRON_PATH/config.conf > $TRON_PATH/tron-java.log\n"
  
  echo "5. Started";
fi

#screen -X -S test-tron0 stuff "^C"
