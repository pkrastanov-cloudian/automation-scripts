#!/bin/bash
# Adding formatting stuff
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
nc='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# Creating an Array of all services in the stop order
services=(cloudian-cmc cloudian-agent cloudian-redismon cloudian-s3 cloudian-iam cloudian-sqs cloudian-hyperstore cloudian-redis-qos cloudian-redis-credentials cloudian-cassandra)

# Creating a function to stop all the services
service_stop () {
    printf "${green}${bold}Stopping Services:${normal}\n\n"
    for serviceop in "${services[@]}"
        do
            printf "${bold}Stopping service ${yellow}$serviceop:${normal}\n"
            systemctl stop $serviceop
            printf "\n"
        done
    
    # Stopping DNSMasq seperately
    printf "${bold}Stopping service ${yellow}cloudian-dnsmasq:${normal}\n"
    systemctl stop cloudian-dnsmasq
    printf "\n"
}

# Creating a function to start all the services
service_start () {
    printf "${green}${bold}Starting Services:${normal}\n\n"
    # Using this for statement to reverse the array selection for correct startup of services
    for (( serviceart=${#services[@]}-1 ; serviceart>=0 ; serviceart-- )) ;
        do
            printf "${bold}Starting service ${yellow}${services[serviceart]}:${normal}\n"
            systemctl start ${services[serviceart]}
            printf "\n"
        done
    
    # Stopping DNSMasq seperately
    printf "${bold}Starting service ${yellow}cloudian-dnsmasq:${normal}\n"
    systemctl start cloudian-dnsmasq
    printf "\n"
}

service_status () {
    printf "${green}${bold}Service statuses:${normal}\n\n"
    for servicestat in "${services[@]}"
        do
            printf "${yellow}$serviceop:${normal}\n"
            systemctl status $serviceop
            printf "\n"
        done
}

# Starting loop to make script interactive
while true
do

    clear
    # Selection screen
    printf "${bold}====================================================================\n"
    printf "Would you like to stop, start or restart all services on this node?\n"
    printf "====================================================================\n"
    printf "1) Stop\n2) Start\n3) Restart\n4) Check service status\n5) Exit${normal}\n\n"
    
    # Actual selection
    printf "${yellow}Your choice: ${normal}"
        read choice

    # If/Else to execute choice
    
    if [[ $choice = 1 ]]
        then service_stop
        printf "Successfully stopped all services! Press any key to continue...\n"
        read null

    elif [[ $choice = 2 ]] 
        then service_start
        printf "Successfully started all services! Press any key to continue...\n"
        read null

    elif [[ $choice = 3 ]] 
        then service_stop && service_start
        printf "Successfully restarted services! Press any key to continue...\n"
        read null
    
    elif [[ $choice = 4 ]] 
        then service_status
        printf "Press any key to continue...\n"
        read null
    
    elif [[ $choice = 5 ]] 
        then break
    
    else
        printf "${red}Invalid input!${normal} Press any key to return...\n"  
        read null
    
    fi

done