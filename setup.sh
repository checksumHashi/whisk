#!/bin/bash

# installs the antimalware software


# installs and updates clam
# https://help.ubuntu.com/community/ClamAV 
sudo apt install clamav clamav-daemon
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclean
sudo systemctl enable clamav-freshclean

# installs and updates RKhunter
sudo apt install rkhunter
sudo rkhunter --propupd

# installs CHKRootkit
sudo apt install chkrootkit