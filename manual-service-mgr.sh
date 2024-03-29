#!/bin/bash
# Version 1.0.2
# Written by Petar Krastanov
# Date Created: 03/02/2023
# Date Modified: 06/02/2023
#
# Changes:
# 1) Changed the if/else to switch/case for better efficency.  
# 2) removed 2 redundant functions and instead combined 3 into one.
#
# To do:
# 1) See if I can somehow merge the service start function with the service_mgr function
# 2) After adding the check for the SQS service it looks like it generates a warning/error when starting the services. 
# This doesn't break the functionality it's just a bit annoying. Should address this when possible.
#
# Adding color and formatting variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
nc='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# Creating an Array of all services in the stop order
services=(cloudian-cmc cloudian-agent cloudian-redismon cloudian-s3 cloudian-iam cloudian-sqs cloudian-hyperstore cloudian-redis-qos cloudian-redis-credentials cloudian-cassandra)

# Creating an Array for the systemctl operations
ops=(stop restart status)

# Performing check to see if SQS is currently active on the node
if [[ -z $(systemctl status cloudian-sqs | grep -i running) ]];
then unset services[5]
fi

# Creating a function to stop/restart/status all the services
service_mgr () {
        
    for serviceop in "${services[@]}"
        do
            printf "${bold}Service ${yellow}$serviceop.${normal}\n"
            systemctl $op $serviceop
            printf "\n"
        done
    
    # Managing DNSMasq seperately
    printf "${bold}Service ${yellow}cloudian-dnsmasq.${normal}\n"
    systemctl $op cloudian-dnsmasq
    printf "\n"
}

# Creating a function to start all the services. It is a seperate function due to the nature of the reverse sort of the services array.
service_start () {
    
    # Using this for statement to reverse the array selection for correct startup of services
    for (( serviceart=${#services[@]} ; serviceart>=0 ; serviceart-- )) ;
        do
            printf "${bold}Service ${yellow}${services[serviceart]}.${normal}\n"
            systemctl start ${services[serviceart]}
            printf "\n"
        done
    
    # Starting DNSMasq seperately
    printf "${bold}Service ${yellow}cloudian-dnsmasq.${normal}\n"
    systemctl start cloudian-dnsmasq
    printf "\n"
}

# Starting loop to make script interactive
while true
do

    # Selection screen
    clear
    printf "${bold}====================================================================\n"
    printf "Would you like to stop, start or restart all services on this node?\n"
    printf "====================================================================\n"
    printf "1) Stop\n2) Start\n3) Restart\n4) Check service status\n5) Exit${normal}\n\n"
    
    # Choice celection
    printf "${yellow}Your choice: ${normal}"
        read choice

    # Case to run the tool
    case $choice in
    
    1) 
        clear
        op="${ops[0]}"
        printf "${green}${bold}Stopping Services:${normal}\n\n"
        service_mgr
        printf "${bold}\nSuccessfully stopped all services! Press any key to continue...${normal}"
        read null
        ;;

    2) 
        clear
        printf "${green}${bold}Starting Services:${normal}\n\n"
        service_start
        printf "${bold}Successfully started all services! Press any key to continue...${normal}"
        read null
        ;;

    3) 
        clear
        op="${ops[1]}"
        printf "${green}${bold}Restarting Services:${normal}\n\n"
        service_mgr
        printf "${bold}Successfully restarted services! Press any key to continue...${normal}"
        read null
        ;;
    
    4) 
        clear
        op="${ops[2]}"
        printf "${green}${bold}Service Statuses:${normal}\n\n"
        service_mgr
        printf "${bold}Press any key to continue...${normal}"
        read null
        ;;
    
    5)
        break
        ;;
    
    *)
        printf "${red}Invalid input!${normal} Press any key to return..."  
        read null
        ;;
    
    esac

done
