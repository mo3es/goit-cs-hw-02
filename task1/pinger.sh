#!/bin/bash

default_list=('https://www.google.com' 'https://www.facebook.com' 'https://www.twitter.com')
echo "List of sites, that will be checked by default - ${default_list[@]}"
list_of_sites=()
exit_char='e'
default_char='d'
logfile="./pinger.log"

read -p "Input name of site, that you want to ping (or enter 'e'/ENTER for exit, 'd' for pinging default sites list): " user_input

if [[ ( "$user_input" == "$exit_char" ) || ( "$user_input" == "" ) ]]; then
    echo "Program finished correctly."
    exit 0
elif [[ "$user_input" == "$default_char" ]]; then
    echo "Default sites list chosen."
    list_of_sites=("${default_list[@]}")

else
    if [[ "$user_input" =~ ^https?://www\..* ]]; then
        full_url="$user_input"
    elif [[ "$user_input" =~ ^https?://.* ]]; then
        full_url="$user_input"
    else
        full_url="https://www.$user_input"
    fi
    list_of_sites+=("$full_url")
    while true;
    do
        read -p "Input another site (or 'e'/ENTER to finish input): " user_input
        if [[ ( "$user_input" == "$exit_char" ) || ( "$user_input" == "" ) ]]; then
            break
        fi
        if [[ "$user_input" =~ ^https?://www\..* ]]; then
            full_url="$user_input"
        elif [[ "$user_input" =~ ^https?://.* ]]; then
            full_url="$user_input"
        else
            full_url="https://www.$user_input"
        fi
        list_of_sites+=("$full_url")
    done
fi
echo ""
echo "Preparing to check sites: ${list_of_sites[@]}"
echo "Starting site checks"

for item in "${list_of_sites[@]}"; do
    current_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    ping_result=$(curl -A "Mozilla/5.0 (compatible; MyPinger/1.0;)" -o /dev/null -s -L -w "%{http_code}\\n" $item)
    if [[ "$ping_result" == "200" ]]; then
        final_result="<$item> is UP"
    else
        final_result="<$item> is DOWN"
    fi
    echo "Checking $item ....... - Result: $ping_result"
    echo "$current_timestamp.   $final_result (return code $ping_result)">> $logfile
done
echo "Pinging of $list_of_sites finished, results saved in $logfile"