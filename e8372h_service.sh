#!/bin/bash

# IP address of modem (default, "192.168.8.1")
MODEM_IP="192.168.8.1"

# Polling period of modem
POLLING_PERIOD=5

# IP address of Prometheus
PROMETHEUS_IP="192.168.1.3"

# Prometheus job name (default, "pushgateway")
PROMETHEUS_JOB="pushgateway"

# Prometheus instance name
PROMETHEUS_INSTANCE="e8372h"

#########################
###  bash script body ###
#########################
while true; do

ses_tok=$(curl -s -X GET "$MODEM_IP/api/webserver/SesTokInfo")
COOKIE=$(echo "$ses_tok" | grep -oPm1 "(?<=<SesInfo>)[^<]+")
TOKEN=$(echo "$ses_tok"  | grep -oPm1 "(?<=<TokInfo>)[^<]+")

modem_status=$(curl -s -X GET "http://$MODEM_IP/api/device/signal" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

rssi=$(echo "$modem_status" | grep -oPm1 "(?<=<rssi>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
sinr=$(echo "$modem_status" | grep -oPm1 "(?<=<sinr>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
rsrp=$(echo "$modem_status" | grep -oPm1 "(?<=<rsrp>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
rsrq=$(echo "$modem_status" | grep -oPm1 "(?<=<rsrq>)[^<]+" | grep -Eo '[-\+0-9]{1,}')

cat <<EOF | curl --data-binary @- http://$PROMETHEUS_IP:9091/metrics/job/$PROMETHEUS_JOB/instance/$PROMETHEUS_INSTANCE
e8372h_rssi{label="RSSI",name="E8372H"} $rssi
e8372h_sinr{label="SINR",name="E8372H"} $sinr
e8372h_rsrp{label="RSRP",name="E8372H"} $rsrp
e8372h_rsrq{label="RSRQ",name="E8372H"} $rsrq
EOF

sleep $POLLING_PERIOD;
done
