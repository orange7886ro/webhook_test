#!/usr/bin/env bash

# Simple move this file into your Rails `script` folder. Also make sure you `chmod +x puma.sh`.
# Please modify the CONSTANT variables to fit your configurations.

# The script will start with config set by $PUMA_CONFIG_FILE by default
#./puma.sh start development
#./puma.sh start production
ENV=$2

#cat $PUMA_PID_FILE
if [ -z "$ENV" ]; then
ENV="development"
fi

PUMA_CONFIG_FILE=config/puma/$ENV.rb
PUMA_PID_FILE=tmp/pids/puma-$ENV.pid
PUMA_SOCKET=tmp/sockets/$ENV.sock
mkdir -p tmp/pids
mkdir -p tmp/sockets

echo $PUMA_CONFIG_FILE

# check if puma process is running
puma_is_running() {
  if [ -S $PUMA_SOCKET ] ; then
    if [ -e $PUMA_PID_FILE ] ; then
      if ps -p `cat $PUMA_PID_FILE` > /dev/null; then
        return 0
      else
      	echo "outputing pid file cat"
      	cat  $PUMA_PID_FILE
        echo "No puma process found $PUMA_PID_FILE"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi

  return 1
}

case "$1" in
  start)
    echo "Starting puma..."
      if [ -e $PUMA_SOCKET  ] ; then # if socket exists
        rm -f $PUMA_SOCKET
        echo "removed $PUMA_SOCKET"
      fi
      RAILS_ENV=$ENV bundle exec puma --config $PUMA_CONFIG_FILE 
 
    echo "done"
    ;;
 
  stop)
      if [ -e $PUMA_PID_FILE ] ; then # if pid file exists
        echo "Stopping puma..."
        /bin/bash --login -c " kill -s SIGTERM `cat $PUMA_PID_FILE` "
        echo "Killed puma PID `cat $PUMA_PID_FILE`"
        rm -f $PUMA_PID_FILE
        echo "removed $PUMA_PID_FILE"
      fi
      if [ -e $PUMA_SOCKET ] ; then # if socket exists
        rm -f $PUMA_SOCKET
        echo "removed  $PUMA_SOCKET"
      fi
    echo "done"
    ;;
 
  restart)
   if puma_is_running ; then
      echo "Hot-restarting puma..."
      if [ -e $PUMA_PID_FILE ] ; then
        /bin/bash --login -c " kill -s SIGUSR2 `cat $PUMA_PID_FILE` "
        echo "Killed puma PID `cat $PUMA_PID_FILE`"
      fi
      echo "Doublechecking the process restart..."
      sleep 5
      if puma_is_running ; then
        echo "done"
        exit 0
      else
        echo "Puma restart failed :/"
        exit 1 # return error
      fi
    fi
 
    echo "Trying cold reboot"
    $0 start
 
    ;;
 	status)
    if puma_is_running ; then
      echo "puma is running"
      exit 0
    else
      echo "puma is not running"
      exit 1 # return error
    fi
 
    ;;
  
  *)
    echo "Usage: script/puma.sh {start|stop|restart|status}" >&2
    ;;
esac
