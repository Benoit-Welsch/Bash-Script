function error() {
  echo -e "\e[91m🤬 $1 \e[39m"
  exit 1
}

function addRules() {
  echo "add rules"
  # Add new rules
  iptables -A INPUT -s "$ip" -p tcp -i eth0 --dport 53 -j ACCEPT
  iptables -A INPUT -s "$ip" -p udp -i eth0 --dport 53 -j ACCEPT
}

function removeRules() {
  echo "remove rules"
  # Remove old rules
  iptables -D INPUT -s "$oldIp" -p tcp -i eth0 --dport 53 -j ACCEPT
  iptables -D INPUT -s "$oldIp" -p udp -i eth0 --dport 53 -j ACCEPT

}

### Args parsing
# Make an array populated with the args
args=("$@")
# Lenght of array
len=$#
# Loop over array of args
i=0
while [ $i -lt $len ]; do
  case "${args[$i]}" in
  "--domain")
    let i++
    domain=${args[$i]}
    ;;
  "--file")
    let i++
    file=${args[$i]}
    ;;
  *)
    error "${args[$i]} is an invalid argument"
    exit 1
    ;;
  esac
  let i++
done

# Var check
if [ -z "$domain" ]; then
  error "No domain specified (to resolve)"
  exit 1
elif [ -z "$file" ]; then
  error "No file specified (to save previous ip)"
  exit 1
fi

# get ip of domain name
ip=$(getent hosts "$domain" | awk '{ print $1 }')

if [ -f "$file" ]; then
  oldIp=$(head -n 1 ${file})
  if [ ! -z "$oldIp" ] && [ $ip != $oldIp ]; then
    addRules
    removeRules
  fi
else
  addRules
fi

# Save current ip
echo "$ip" >"$file"
