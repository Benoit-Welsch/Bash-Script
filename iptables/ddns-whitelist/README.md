# Ddns-whitelist

A simple script to whitelist ip resolved from a domain.

# Info
- Change the iptables rules inside the script (By default, it add rules for port 53 on tcp/udp).
- The file is used to save the previous ip.

# How to use
```
chmod +x ./ddns-whitelist.sh
sudo ./ddns-whitelist.sh --domain google.com --file previous_ip
```

# To-Do
- Multi domain support (--domain domain.xyz,domain2.xyz,domain3.xyz,...)
- Port and protocol built-in support (--port 53 --protocol tcp/udp)
