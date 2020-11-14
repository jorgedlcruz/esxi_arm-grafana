#!/bin/sh
##      .SYNOPSIS
##      Bash Shell Script that uses thepimon (https://github.com/thebel1/thpimon) to extract data and save it to InfluxDB
## 
##      .DESCRIPTION
##      Bash Shell Script that uses thepimon (https://github.com/thebel1/thpimon) to extract data and save it to InfluxDB, and then visualized with Grafana 
##      The Script, and the whole thepimon it is provided as it is, and bear in mind you can not open support Tickets regarding this project. It is a Community Project
##	
##      .Notes
##      NAME:  esxi-arm-rpi_grafana.sh
##      ORIGINAL NAME: esxi-arm-rpi_grafana.sh
##      LASTEDIT: 13/11/2020
##      VERSION: 1.0
##      KEYWORDS: VMware, ESXi, ARM
   
##      .Link
##      https://jorgedelacruz.es/
##      https://jorgedelacruz.uk/

# Configurations
##
# Endpoint URL for InfluxDB
InfluxDBURL="http://YOURINFLUXSERVERIP" #Your InfluxDB Server, http://FQDN or https://FQDN if using SSL
InfluxDBPort="8086" #Default Port
InfluxDB="telegraf" #Default Database
InfluxDBUser="USER" #User for Database
InfluxDBPassword='PASSWORD' #Password for Database
thepimonPath="/thpimon-main/pyUtil/pimon_util.py"
jumBoxUser="YOURUSER"
jumpBoxIP="YOURIP"

##
# Variables from Python thepimon to InfluxDB
##
thepimon_output=$(python /thpimon-main/pyUtil/pimon_util.py)
arm_rpi_firmware=$(echo $thepimon_output | awk -F':' '{print $2}' | awk '{print $1}')
arm_rpi_boardmodel=$(echo $thepimon_output | awk -F':' '{print $2}' | awk '{print $1}')
arm_rpi_boardrevision=$(echo $thepimon_output | awk -F':' '{print $2}' | awk '{print $1}')
arm_rpi_boardserial=$(echo $thepimon_output | awk -F':' '{print $2}' | awk '{print $1}')
arm_rpi_boardtemp=$(echo $thepimon_output | awk -F'Temp:' '{print $2}'  | awk '{print $1}')
arm_rpi_hostname=$(echo $HOSTNAME)

echo "Writing vsphere_esxi_arm to InfluxDB"
ssh $jumBoxUser@$jumpBoxIP "curl -i -XPOST '$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB' -u '$InfluxDBUser:$InfluxDBPassword' --data-binary 'vsphere_esxi_arm,arm_rpi_hostname=$arm_rpi_hostname,arm_rpi_firmware=$arm_rpi_firmware,arm_rpi_boardmodel=$arm_rpi_boardmodel,arm_rpi_boardrevision=$arm_rpi_boardrevision,arm_rpi_boardserial=$arm_rpi_boardserial arm_rpi_boardtemp=$arm_rpi_boardtemp'"
