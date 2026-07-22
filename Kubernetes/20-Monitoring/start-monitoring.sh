#!/bin/bash

pkill -f "kubectl port-forward svc/prometheus-server" 2>/dev/null
pkill -f "kubectl port-forward svc/grafana" 2>/dev/null

nohup ~/pf-loop.sh prometheus-server 9090 80 >/tmp/prometheus-pf.log 2>&1 &
nohup ~/pf-loop.sh grafana 3000 80 >/tmp/grafana-pf.log 2>&1 &

echo "Started Prometheus and Grafana port-forward loops."

ps -ef | grep port-forward | grep -v grep
