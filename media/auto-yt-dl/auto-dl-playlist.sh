#!/bin/bash
function error() {
    echo -e "\e[91m🚨 [ERR]: $1 \e[39m"
    exit $2
}

function warning() {
    echo -e "\e[33m🚧 [WARN]: $1 \e[39m"
}

function showHelp() {
    column -t -s "|" <<<'
    Usage: | ./auto-dl-playlist.sh  [options] ...
    Example: | ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/'

    echo ""

    column -t -s "|" <<<'
    Option |  | Meaning
    --playlist | -p | Define the location of the playlist text file
    --output | -o | Define the output folder
    --user | -u | Define the uid:gid to use
    --help | -h | Show this help
    '
    exit 0
}

if [ ! $(which docker) ]; then
    error "Please docker" 3
elif [ ! $(which column) ]; then
    error "Please install bsdmainutils (debian, ubuntu, ...) or util-linux (fedora, archlinux, alpine, ...)" 3
fi

### Args parsing

# Make an array populated with the args
args=("$@")
# Lenght of array
len=$#
# Loop over array of args
i=0
while [ $i -lt $len ]; do
    if [ "${args[$i]}" = "--help" ] || [ "${args[$i]}" = "-h" ]; then
        showHelp
    elif [ "${args[$i]}" = "--playlist" ] || [ "${args[$i]}" = "-p" ]; then
        let i++
        playlist=${args[$i]}
    elif [ "${args[$i]}" = "--output" ] || [ "${args[$i]}" = "-o" ]; then
        let i++
        output=${args[$i]}
    elif [ "${args[$i]}" = "--user" ] || [ "${args[$i]}" = "-u" ]; then
        let i++
        user=${args[$i]}
    else
        warning "${args[$i]} is not supported. It will be ignored"
    fi
    let i++
done

### Var check

# Playlist
if [ -z "$playlist" ]; then
    error "No playlist specified" 1
elif [ ! -f "$playlist" ]; then
    error "Playlist file don't exist" 1
fi

# Output
if [ -z "$output" ]; then
    error "No output specified" 1
elif [ ! -d "$output" ]; then
    error "Output dir don't exist" 1
fi

# User
userDockerArgs="-u ${user}"
if [ -z "$user" ]; then
    warning "No user specified"
    userDockerArgs=""
elif [[ ! $user =~ ^[0-9]+:[0-9]+$ ]]; then
    error "Not a valid uid:gid" 1
fi


# Loop over each url and start a docker container (ignore empty line)
for url in $(sed '/^$/d' $playlist); do
    docker run \
    --rm \
    $userDockerArgs \
    -v ${output}:/media:rw \
    lv00/yt-dlp \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" \
    -o "/media/%(playlist_title)s/%(title)s.%(ext)s" \
    --download-archive "/media/archive.txt" \
    --merge-output-format mp4 \
    --embed-thumbnail \
    --add-metadata \
    --ignore-errors \
    --no-overwrites \
    --continue \
    "$url"
done
