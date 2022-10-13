#!/bin/bash
function error() {
    echo -e "\e[91m🚨 [ERR]: $1 \e[39m"
    exit $2
}

function warning() {
    echo -e "\e[33m🚧 [WARN]: $1 \e[39m"
}

function checkDependency() {
    if [ ! $(which ${1}) ]; then
        error "Please install ${1}. ${2}" 3
    fi
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
    --help | -h | Show this help
    '
    exit 0
}

### Depenency test
checkDependency yt-dlp
checkDependency ffmpeg
checkDependency column "bsdmainutils (debian, ubuntu, ...) or util-linux (fedora, archlinux, alpine, ...)"

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
    else
        warning "${args[$i]} is not supported. It will be ignored"
    fi
    let i++
done

### Var check

# Playlist
if [ -z "$playlist" ]; then
    warning "No playlist specified. Default is /data/playlist.txt"
    playlist="/data/playlist.txt"
fi
if [ ! -f "$playlist" ]; then
    error "Playlist file doesn't exist. Default is /data/playlist.txt" 1
fi

# Output
if [ -z "$output" ]; then
    warning "No output specified"
    output="/data"
fi
if [ ! -d "$output" ]; then
    error "Output dir doesn't exist" 1
fi

# Loop over each url and start a docker container (ignore empty line)
for url in $(sed '/^$/d' $playlist); do
    yt-dlp \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" \
    -o "${output}/%(playlist_title)s/%(title)s.%(ext)s" \
    --download-archive "${output}/archive.txt" \
    --merge-output-format mp4 \
    --embed-thumbnail \
    --add-metadata \
    --ignore-errors \
    --no-overwrites \
    --continue \
    "$url"
done
