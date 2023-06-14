#!/usr/bin/env bash
echo "Whisk requires root privilages"
sudo echo "."
gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "Welcome to $(gum style --foreground 130 'Whisk v0.1'), where we $(gum style --foreground 130 'Whisk') the malware away!"
echo "Welcome to whisk, where we whisk the malware away!"

run_commands(){

}

install_all_software(){\
    sudo apt update

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

    echo "ALL SOFTWARE INSTALLED, PLEASE RUN WHISK AGAIN TO SCAN"
    exit
}

function run_antivirus_scans {
    # Run ClamAV scan with default options
    clamscan -r / >> whisk.log

    # Run Chkrootkit scan with default options
    chkrootkit >> whisk.log

    # Run Rkhunter scan with default options
    rkhunter --checkall --skip-keypress >> whisk.log

    # Run AIDE scan with default options
    aide.wrapper --check >> whisk.log
    
  	#Run LMD (Linux Malware Detect) Scan 
 	lmd -u -q  && lmd_report="$(lmd report)" && echo "${lmd_report}" | tee -a whisk.log 

  	#Run OSSEC HIDS Scanning 
	ossec-control start && ossec-logtest > /dev/null && ossec-analysisd	
}

run(){
    ## remove previous logs
    rm logs/clam.log logs/rkhunter.log logs/chkrootkit.log

    ## based on the choice made, do
    if [[ $choice2 == "Run and output to a log file" ]]; then
        sudo clamscan -r | tee -a logs/clam.log
        sudo sudo rkhunter --checkall | tee -a logs/rkhunter.log
        sudo chkrootkit | tee -a logs/chkrootkit.log
        for x in clam rkhunter chkrootkit; do
            fancy_text 0 >> whisk.log
        done
        exit

    elif [[ $choice2 == "Just run" ]]; then
        ## Run scanners in current env
        sudo clamscan -r
        sudo sudo rkhunter --checkall
        sudo chkrootkit
        exit

    elif [[ $choice2 == "Run in background" ]]; then
        #Run scanners in the background
        sudo clamscan -r &
        sudo sudo rkhunter --checkall &
        sudo chkrootkit &
        exit

    elif [[ $choice2 == "Run in background and output to file" ]]; then
        sudo clamscan -r >> whisk.log &
        sudo sudo rkhunter --checkall >> whisk.log &
        sudo chkrootkit >> whisk.log &
        exit
    fi
    
}

fancy_text(){
    if [[ $1 == 1 ]]; then
        echo "$(gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "$(gum style --foreground 130 'BEGIN')")"
    elif [[ $1 == 0 ]]; then
        echo "$(gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "$(gum style --foreground 130 'END')")"
    fi
}

echo "Main menu"
choice=$(gum choose "Run scanners" "Install software" "Exit")

if [[ $choice == "Install software" ]]then
    install_all_software
elif [[ $choice == "Exit" ]]; then
    exit
fi

echo "Choose whether you would like to scan from root or a custom location?"
pos=$(gum choose "Root ( / )" "Custom Location")

echo "How would you like the scan to run?"
echo "quick tip, when reading the log file, use cat log | grep -i warning"
choice2=$(gum choose "Run and output to a log file" "Just run" "Run in background" "Run in background and output to file")

if [[ $choice == "Run scanners" ]]; then
    run_all_software "$pos" 
fi