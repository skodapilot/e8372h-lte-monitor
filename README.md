# e8372h-lte-monitor
This bash script can be run as service to monitor LTE signal (SINR, RSRP and RSRQ) of USB modem Huawei E8372H-153 and push metrics at Prometheus service. Script can be extended to monitor any other parameter available by API URL /api/device/signal

## Installation
This instruction was designed for Raspberry Pi installation 
 1. Copy script file: **e8372h_service.sh** to */home/pi*
 2. Make file executable: **chmod +x e8372h_service.sh**
 3. Copy service file: **e8372h_monitor.service** to */etc/systemd/system*
 4. Reload daemon: **sudo systemctl daemon-reload**
 5. Run service: **sudo systemctl enable e8372h_monitor**

## Metric access Prometheus
 1. SINR metric *e8372h_sinr{}*
 2. RSRQ metric *e8372h_rsrq{}*
 3. RSRP metric *e8372h_rsrp{}*
