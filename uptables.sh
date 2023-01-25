#!/bin/bash
# autor @Zaytos

# Colors
declare -r green="\e[0;32m\033[1m"
declare -r end="\033[0m\e[0m"
declare -r red="\e[0;31m\033[1m"
declare -r blue="\e[0;34m\033[1m"
declare -r yellow="\e[0;33m\033[1m"
declare -r purple="\e[0;35m\033[1m"
declare -r cyan="\e[0;36m\033[1m"
declare -r gray="\e[0;37m\033[1m"

# Globals Variables
declare arguments=($1 $2)

# Creación del banner
function banner(){
  echo -e "${yellow}+---------+---------+---------+---------+${end}"
  echo -e "${yellow}|      ${purple}__${yellow} | ${purple}___${yellow}     |  ${purple}__${yellow}     |  ${purple}___ __${yellow} |${end}"
  echo -e "${yellow}| ${purple}|  ||__)${yellow}|  ${purple}|  /\  ${yellow}| ${purple}|__)|   ${yellow}| ${purple}|__ /__'${yellow}|${end}"
  echo -e "${yellow}| ${purple}\__/|   ${yellow}| ${purple} | /~~\ ${yellow}| ${purple}|__)|__ ${yellow}| ${purple}|___.__/${yellow}|${end}"
  echo -e "${yellow}+---------+---------+---------+---------+${end}"
  echo -e "${yellow}|${blue}target   ${yellow}|${blue}prot     ${yellow}|${blue}rource   ${yellow}|${blue}destiny  ${yellow}|${end}"
  echo -e "${yellow}+---------+---------+---------+---------+${end}"
  echo -e "${yellow}|${purple}ACCEPT   ${yellow}|${purple}all      ${yellow}|${purple}anyware  ${yellow}|${purple}10.3.50.2${yellow}|${end}" 
  echo -e "${yellow}+---------+---------+---------+---------+${end}"
  echo -e "${yellow}|${purple}DROP     ${yellow}|${purple}udp      ${yellow}|${purple}anyware  ${yellow}|${purple}anyware  ${yellow}|${end}" 
  echo -e "${yellow}+---------+---------+---------+---------+${end}"
  echo -e "${yellow}|${purple}REJECT   ${yellow}|${purple}icmp     ${yellow}|${purple}10.2.40.3${yellow}|${purple}anyware  ${yellow}|${end}"
  echo -e "${yellow}+---------+---------+---------+---------+${end}"

  echo -e "${red}[!]Created by: Juan Manuel Duran Bizcocho (aka Zaytos)${end}\n"
}

function select_function(){
  case $1 in
    "clear")
      clear_ip
    ;;

    "defPolitics")
      def_politics "${arguments[1]}"
    ;;
    
    "restartCount")
      restart_count
    ;;
    
    "addSimpleRule")
      add_simple_rule
    ;;
    
    *)
      help_menu
    ;;
  esac
}

function clear_ip(){ 
  iptables -t filter -F
  iptables -t nat -F

  echo -e "${blue}[*] Tables has been emptied correctly${end}"
  exit 1
}

function restart_count(){
  iptables -Z
  iptables -t nat -Z

  echo -e "${blue}[*] Counters have been successfully reset${end}" 
  exit 1
}

function def_politics(){
  #if [ $# -ne 2 ]; then
  #  echo -e "${red}[!] To many arguments, displacing help menu"
  #  help_menu
  #fi
  
  if [ "$1" == "any" ]; then
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP

    echo -e "${blue}[*] Policies have been upgraded to mode restrictive${end}"
    exit 1

  elif [ "$1" == "all" ]; then
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT

    echo -e "${blue}[*] Policies have been upgraded to permissive${end}"
    exit 1 

  else 
    echo -e "${red}[!] This parameters are incorrect, displacing help menu . . .${end}"
    help_menu
  fi
}

function add_simple_rule(){
  echo -e "${blue}[*] Creating a simple rule . . . Please answer the next cuestions${end}"
  read -p "$(echo -e "${yellow}[?] {APPEND | INSERT}: ")" request
  typeset -l rule_position=$request 
 
  read -p "$(echo -e "${yellow}[?] Chain {INPUT | OUTPUT | FORWARD}: ")" request
  typeset -u chain=$request

  read -p "$(echo -e "${yellow}[?] Protocol: ")" request
  typeset -l protocol=$request
  
  read -p "$(echo -e "${yellow}[?] Source IP: ")" request                           
  typeset -l s_ip=$request

  read -p "$(echo -e "${yellow}[?] Destination IP: ")" request                           
  typeset -l d_ip=$request

  read -p "$(echo -e "${yellow}[?] Input Interface: ")" request                           
  typeset -l i_inter=$request

  read -p "$(echo -e "${yellow}[?] Output Interface: ")" request                           
  typeset -l o_inter=$request

  read -p "$(echo -e "${yellow}[?] Destination Port: ")" request
  typeset -l d_port=$request

  read -p "$(echo -e "${yellow}[?] Source Port: ")" request
  typeset -l $s_port=$request
  
  read -p "$(echo -e "${yellow}[?] Status {ACCEPT | DROP}: ")" request                           
  typeset -u status_packet=$request
 
  ip_command=("$chain" "-p $protocol" "-s $s_ip" "-d $d_ip" "-i $i_inter" "-o $o_inter" "--dport $d_port" "--sport $s_port" "-j $status_packet")

  if [ -z "$protocol" ]; then 
    unset ip_command[1] 
  fi
  if [ -z "$s_ip" ]; then 
    unset ip_command[2]
  fi
  if [ -z "$d_ip" ]; then
    unset ip_command[3] 
  fi
  if [ -z "$i_inter" ]; then
    unset ip_command[4]
  fi 
  if [ -z "$o_inter" ]; then
    unset ip_command[5] 
  fi
  if [ -z "$d_port" ]; then
    unset ip_command[6]
  fi
  if [ -z "$s_port" ]; then
    unset ip_command[7] 
  fi

  if [ $rule_position == "insert" ]; then
    iptables -I ${ip_command[*]} 

    echo -e "${blue}[*] The rule its upgraded${end}"
    exit 1

  elif [ $rule_position == "append" ]; then
    iptables -A ${ip_command[*]} 

    echo -e "${blue}[*] The rule its upgraded${end}"
    exit 1
  fi

  help_menu
  exit 1
}

function help_menu(){
  #text  
  exit 1
}

#MAIN
if [ "$(echo $UID)" != "0" ]; then
  echo -e "${red}[!] You need to run the program as root${end}"
  exit 1
fi

banner
select_function "$1"
