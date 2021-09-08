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

if [ ! $(which youtube-dl) ]; then
    error "Please install youtube-dl"
    exit 3
elif [ ! $(which ffmpeg) ]; then
    error "Please install ffmpeg"
    exit 3
elif [ ! $(which column) ]; then
    error "Please install column"
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
    case "${args[$i]}" in
    "--help")
        showHelp
        ;;
    "-h")
        showHelp
        ;;
    "--playlist")
        let i++
        playlist=${args[$i]}
        ;;
    "-p")
        let i++
        playlist=${args[$i]}
        ;;
    "--output")
        let i++
        output=${args[$i]}
        ;;
    "-o")
        let i++
        output=${args[$i]}
        ;;
    *)
        error "${args[$i]} is an invalid argument"
        exit 1
        ;;
    esac
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

mkdir -p "${output}/log"

while read url; do
    youtube-dl \
        -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" \
        -o "${output}/%(playlist_title)s/%(title)s.%(ext)s" \
        --download-archive "${output}/archive.txt" \
        --merge-output-format mp4 \
        --ignore-errors \
        --no-overwrites \
        --continue \
        "$url" >>"${output}/log/$(date +"%d-%m-%y_%H:%M:%S").txt" 2>&1
done <$playlist
