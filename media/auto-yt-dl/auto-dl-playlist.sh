#!/bin/bash

function error() {
    echo -e "\e[91m🤬 $1 \e[39m"
}

function showHelp() {
    column -t -s "|" <<<'
    Usage: | ./auto-dl-playlist.sh  [options] ...
    Exemple: | ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/'

    echo ""

    column -t -s "|" <<<'
    Option |  | Meaning
    --playlist | -p | Define the location of the playlist text file
    --output | -o | Define the output folder
    --help | -h | Show this help
    '
    exit 0
}

if [ ! $(which docker) ]; then
    error "Please docker"
    exit 3
elif [ ! $(which column) ]; then
    error "Please install bsdmainutils (debian, ubuntu, ...) or util-linux (fedora, archlinux, alpine, ...)"
    exit 3
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
    else
        error "${args[$i]} is not supported"
        exit 3
    fi
    let i++
done

# Var check
if [ -z "$playlist" ]; then
    error "No playlist specified"
    exit 1
elif [ -z "$output" ]; then
    error "No output specified"
    exit 1
fi

for url in $(sed '/^$/d' $playlist); do
    docker run \
    --rm \
    -u 1010:1012 \
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
