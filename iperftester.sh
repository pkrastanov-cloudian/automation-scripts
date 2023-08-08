#!/bin/bash
# Version 0.0.1
# Written by Petar Krastanov
# Date Created: 08/07/2023
# Date Modified: 08/07/2023
#
# Adding color and formatting variables

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
nc='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# Creating array containing all hostnames

host_all=( $(grep hostname /etc/cloudian/dynstore/cloudianservicemap.json | grep -v installscript | awk {'print $2'} | sed 's/[",]//g') )

# Running iperf3 on all nodes

speed_test () {

  for ()

}

# iperf3 commands
iperf3 -c $host -p 5201 -t 60

iperf3 -s -p 5201


# Starting loop to make script interactive
while true
do

    # Selection screen
    clear
    printf "${bold}====================================================================\n"
    printf "Please select operation:\n"
    printf "====================================================================\n"
    printf "1) Install iperf3 on all nodes\n2) Run iperf3 test on all nodes\n3) Check previous results\n5) Exit${normal}\n\n"
    
    # Choice celection
    printf "${yellow}Your choice: ${normal}"
        read choice

    # Case to run the tool
    case $choice in
    
    1) 
        clear
        printf "${green}${bold}Installing iperf3 on all nodes:${normal}\n\n"
        # Install iperf3 on all nodes:
        for Node in `awk '{print $3}' $(hsctl config get common.stagingDirectory)/hosts.cloudian | sort -V`; do echo -e "$Node:\t"; 
          ssh -i $(hsctl config get common.stagingDirectory)/cloudian-installation-key -n ${Node} 'yum -y install iperf3' ; 
          done
        printf "${bold}\nSuccessfully installed iperf3! Press any key to continue...${normal}"
        read null
        ;;

    2) 
        clear
        printf "${green}${bold}Running tests:${normal}\n\n"
        speed_test
        printf "${bold}Finished running test! Results can be found in file . Press any key to continue...${normal}"
        read null
        ;;

    3) 
        clear
        
        printf "${bold}Press any key to continue...${normal}"
        read null
        ;;
  
    4)
        break
        ;;
    
    *)
        printf "${red}Invalid input!${normal} Press any key to return..."  
        read null
        ;;
    
    esac

done
