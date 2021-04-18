# /bin/bash

function error() {
    echo -e "\e[91m🤬 $1 \e[39m"
    exit 1
}

function checkDependency(){
    dependency=("docker" "git" "pwgen")
    
    for d in ${dependency[@]}; do
        if [ ! $(which $d) ]; then
            error "Please install $d"
            exit 3
        fi
    done
}

function installDependency(){
    dnf -y install dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io git pwgen
    systemctl start docker
    systemctl enable docker
}

function dockerRunning(){
    systemctl is-active --quiet docker
    if [ $? -ne 0 ]; then
        error "Docker is not running"
    fi
}

function containerExist() {
    # Check if a container label
    if [ ! -z "$(sudo docker ps -a --filter "name=${1}" | awk 'FNR > 1 {print $1}')" ]; then
        error "Container ${1} already exist"
    fi
}

function createNetwork(){
    # Create new network
    if [ ! "$(sudo docker network ls | grep ${1})" ]; then
        # Check if network already exists
        
        docker network create ${1} > /dev/null
        if [ ! "$(sudo docker network ls | grep ${1})" ]; then
            # Check if network has been created
            error "Unable to create the network"
            exit 1
        else
            echo "✅ ${1} network Created"
        fi
        
    else
        echo "🤔 Network ${1} already exists."
    fi
}

function installDns(){
    # Look for config file
    if [ ! -e "./blocky.yml" ]; then
        error "Missing blocky config file (blocky.yml)"
    fi
    
    # Check if docker is running
    dockerRunning
    
    # Check if container already exist
    containerExist "blocky"
    
    # Create folder to hold the dns config
    mkdir -p ~/.config/blocky/
    
    # Copy config in folder
    cp blocky.yml ~/.config/blocky/config.yml
    
    # Create new network
    createNetwork dns
    
    # Deploy dns
    docker run -d \
    --name blocky \
    --network dns \
    --restart unless-stopped \
    --user nobody \
    -v ~/.config/blocky/config.yml:/app/config.yml \
    -p $localIp:53:53/udp \
    spx01/blocky > /dev/null
    
    # Show message if good deployment
    if [ ! -z "$(sudo docker ps -a --filter "name=blocky" | awk 'FNR > 1 {print $1}')" ]; then
        echo "✅ Blocky container deployed"
    fi
}

function installShare(){
    # Check if docker is running
    dockerRunning
    
    # Check if container already exist
    containerExist "samba"
    
    # Share foler
    lv0Share="/media/2To/lv0/"
    mediaShare="/media/2To/media/"
    backupShare="/media/2To/backup/"
    
    # Create share folder
    mkdir -p $lv0Share $mediaShare $backupShare
    
    # Generate password
    lv0Passwd=$(pwgen -Bsn 32 1)
    mediaPasswd=$(pwgen -Bsn 32 1)
    backupPasswd=$(pwgen -Bsn 32 1)
    
    # Create new network
    createNetwork samba
    
    # Deploy samba container
    docker run -it -p $localIp:445:445 -p $localIp:139:139 -m 1024m \
    --name samba \
    --restart unless-stopped \
    --network samba \
    -v $lv0Share:$lv0Share \
    -v $mediaShare:$mediaShare \
    -v $backupShare:$backupShare \
    -d dperson/samba \
    -u "lv0;${lv0Passwd}" \
    -u "media;${mediaPasswd}" \
    -u "backup;${backupPasswd}" \
    -s "lv0;$lv0Share;yes;no;no;lv0;" \
    -s "media;$mediaShare;yes;no;no;media;" \
    -s "backup;$backupShare;yes;no;no;backup;" \
    -p > /dev/null
    
    # Show message if good deployment
    if [ ! -z "$(sudo docker ps -a --filter "name=samba" | awk 'FNR > 1 {print $1}')" ]; then
        echo "✅ Samba container deployed"
        
        # Show password of share
        echo "📛 Credential"
        echo ""
        echo "  - lv0    : "${lv0Passwd}
        echo "  - media  : "${mediaPasswd}
        echo "  - backup : "${backupPasswd}
        echo ""
    fi
}

function installJellyFin(){
    # Check if docker is running
    dockerRunning
    
    # Check if container already exist
    containerExist "jellyfin"
    
    # Create new network
    createNetwork jellyfin
    
    docker run -d \
    --name jellyfin \
    --network jellyfin \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Europe/Brussels \
    -e JELLYFIN_PublishedServerUrl=$localIp \
    -p $localIp:8096:8096 \
    -p $localIp:8920:8920 `#optional` \
    -p $localIp:7359:7359/udp `#optional` \
    -p $localIp:1900:1900/udp `#optional` \
    -v ${mediaShare}/jellyfin:/config \
    -v ${mediaShare}:/data \
    --device /dev/dri:/dev/dri `#optional` \
    --restart unless-stopped \
    linuxserver/jellyfin > /dev/null
    
    # Show message if good deployment
    if [ ! -z "$(sudo docker ps -a --filter "name=blocky" | awk 'FNR > 1 {print $1}')" ]; then
        echo "✅ Jellyfin container deployed"
    fi
}

localIp=$(hostname -I | awk '{print $1}')

# installDependency
# checkDependency
# installDns
# installShare
# installJellyFin