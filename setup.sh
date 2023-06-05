#!/bin/bash
# installs the antimalware software
# this sudo is here so that you only need to enter your password on startup
sudo echo "Welcome to whisk, where we whisk the malware away!"

install_all_software(){
    # installs and updates clam
    # https://help.ubuntu.com/community/ClamAV 
    sudo apt install clamav clamav-daemon -y
    sudo systemctl stop clamav-freshclam
    sudo freshclam
    sudo systemctl start clamav-freshclean
    sudo systemctl enable clamav-freshclean

    # installs and updates RKhunter
    sudo apt install rkhunter -y
    sudo rkhunter --propupd

    # installs CHKRootkit
    sudo apt install chkrootkit -y
}

install_chkrootkit(){
    # installs CHKRootkit
    sudo apt install chkrootkit -y
}

install_RKhunter(){    
    # installs and updates RKhunter
    sudo apt install rkhunter
    sudo rkhunter --propupd
}

install_clamav(){
    # installs and updates clam
    # https://help.ubuntu.com/community/ClamAV 
    sudo apt install clamav clamav-daemon
    sudo systemctl stop clamav-freshclam
    sudo freshclam
    sudo systemctl start clamav-freshclean
    sudo systemctl enable clamav-freshclean
}

choice=$(gum choose "Install all software" "Install chkrootkit" "Install clamav" "Install RKHunter" "Exit")

if [[ $choice == "Install all software" ]]; then
    install_all_software
elif [[ $choice == "Install chkrootkit" ]]; then
    install_chkrootkit
elif [[ $choice == "Install clamav" ]]; then
    install_clamav
elif [[ $choice == "Install RKHunter" ]]; then
    install_RKhunter
elif [[ $choice == "Exit" ]]; then
    exit
fi
