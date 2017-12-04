#!/bin/bash
#----------------------------------------------------------------------------------------
# Dev: Peter Ton
# Created: 22 Feb 2017
# Description: This script is used to download and install the TeamViewer12 host module
# and assign it to the Company account. It also enables easy access.
#----------------------------------------------------------------------------------------

#Download the TeamViewer and Assignment Tool
curl -L -o "/tmp/Install TeamViewerHost-idcXXXXXXX.pkg" "https://www.dropbox.com/s/rwxlv2omrbce27q/Install%20TeamViewerHost-idcXXXXXXX.pkg"
curl -L -o /tmp/TeamViewer_Assignment "https://www.dropbox.com/s/e62pn07e9f7ijw2/TeamViewer_Assignment"

#Run installer and assignment
sudo installer -pkg "/tmp/Install TeamViewerHost-idc8nbwr9c.pkg" -target /
chmod +x /tmp/TeamViewer_Assignment
/tmp/TeamViewer_Assignment -apitoken "YYYYYYY-zzzzzzzzzzzzzzzzzzzz" -datafile /Library/Application\ Support/TeamViewer\ Host/Custom\ Configurations/XXXXXXX/AssignmentData.json

#Clean up
rm "/tmp/Install TeamViewerHost-idcXXXXXXX.pkg"
rm /tmp/TeamViewer_Assignment

#exit 0
