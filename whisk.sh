#!/usr/bin/env bash
echo "Whisk requires root privilages"
sudo echo "."
gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "Welcome to $(gum style --foreground 130 'Whisk v0.1'), where we $(gum style --foreground 130 'Whisk') the malware away!"
echo "Welcome to whisk, where we whisk the malware away!"

run_all_software(){
    ## remove previous logs
    rm logs/clam.log logs/rkhunter.log logs/chkrootkit.log

    ## based on the choice made, do
    if [[ $choice2 == "Run and output to a log file" ]]; then
        ## Run scanners, output all to logs
        for x in clam rkhunter chkrootkit; do
            fancy_text 1 >> $x.log
        done
        sudo clamscan -r | tee -a logs/clam.log
        sudo sudo rkhunter --checkall | tee -a logs/rkhunter.log
        sudo chkrootkit | tee -a logs/chkrootkit.log
        for x in clam rkhunter chkrootkit; do
            fancy_text 0 >> $x.log
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
        ## Run scanners in the background, and write their outputs to respective logs
        for x in clam rkhunter chkrootkit; do
            fancy_text 1 >> $x.log
        done
        sudo clamscan -r >> logs/clam.log &
        sudo sudo rkhunter --checkall >> logs/rkhunter.log &
        sudo chkrootkit >> logs/chkrootkit.log &
        for x in clam rkhunter chkrootkit; do
            fancy_text 0 >> $x.log
        done
        exit
    fi
    
}

run_clamav(){
    if [[ $choice2 == "Run and output to a log file" ]]; then
        sudo clamscan -r | tee clam.log
    elif [[ $choice2 == "Just run" ]]; then
        sudo clamscan -r
    elif [[ $choice2 == "Run in background" ]]; then
        sudo clamscan -r &
    elif [[ $choice2 == "Run in background and output to file" ]]; then
        sudo clamscan -r >> clam.log &
    fi
}

fancy_text(){
    if [[ $1 == 1 ]]; then
        echo "$(gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "$(gum style --foreground 130 'BEGIN')")"
    elif [[ $1 == 0 ]]; then
        echo "$(gum style --border normal --margin "1" --padding "1 2" --border-foreground 130 "$(gum style --foreground 130 'END')")"
    fi
}

echo "Choose which software you would like to run"
choice=$(gum choose "Run scanners"  "Exit")

if [[ $choice == "Exit" ]]; then
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