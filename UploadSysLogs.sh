#!/bin/bash
#===============================================================================
#
#          FILE: UploadSysLogs.sh
# 
#         USAGE: ./postinstall.sh 
# 
#   DESCRIPTION: Upload System Logs to Jamf Pro Computer Inventory
# 
#       OPTIONS: 
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Kavan (K1) Joshi, kavan.joshi@jamf.com
#  ORGANIZATION: Jamf
#       CREATED: 12/20/2021 15:53
#      REVISION: (1) 09/28/2022 12:30 
#===============================================================================


apiUsername="apiUser"
apiPassword="apiPassword"
apiURL="https://instance.jamfcloud.com"

# Replace the apiUser, apiPassword and instance name with your respective information 

# Recommended : Use encrypted password for apiPassword Field. 
# Refer end of the script to know how to encrypt apiPassword.

serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')
jssComputerID=$(/usr/bin/curl -H "Accept: text/xml" -sfku ${apiUsername}:${apiPassword} ${apiURL}/JSSResource/computers/match/${serialNumber} | xmllint --format - | grep "<id>" | cut -f2 -d">" | cut -f1 -d"<")


fileName="system_log_$(date).log"

#  Copy the system log to temp (As System Log cannot be renamed)
cp /private/var/log/system.log /tmp/

#  Rename log file
mv /tmp/system.log "/tmp/$fileName"

#  Upload log file

/usr/bin/curl -sfku $apiUsername:$apiPassword ${apiURL}/JSSResource/fileuploads/computers/id/${jssComputerID} -F name=@"/tmp/$fileName" -X POST 

