#!/bin/bash
SVC=$1
LOCAL_PORT=$2
REMOTE_PORT=$3
while true; do
  kubectl port-forward svc/$SVC $LOCAL_PORT:$REMOTE_PORT
  echo "port-forward for $SVC died, restarting in 3s..."
  sleep 3
done
