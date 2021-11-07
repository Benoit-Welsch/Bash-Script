# Auto-dl-playlist

A simple script to download video from a playlist.

# How it works

The script reads a file that contains a list of playlists and downloads all the videos from them. <br>
Then, the script saves the id of all the downloaded videos in a file to avoid re-downloading the videos several times.

# Dependency

- [youtube-dl](https://github.com/ytdl-org/youtube-dl/)
- [ffmpeg](https://github.com/FFmpeg/FFmpeg)
- [column](https://command-not-found.com/column) (not installed by default on alpine 🤷‍♂️)

# Info

- Download file in the highest quality possible (.mp4)
- Don't support empty line in the playlist file. (So be sure to remove any empty line or the script will fail)
- All log are written in a log folder inside the output folder.
- Use crontab to automate the download

# How to use

```
$ chmod +x ./auto-dl-playlist.sh
$ ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/

$ ./auto-dl-playlist.sh --help
    Usage:      ./auto-dl-playlist.sh  [options] ...

    Exemple:    ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/

    Option              Meaning
    --playlist    -p    Define the location of the playlist text file
    --output      -o    Define the output folder
    --help        -h    Show this help
```

# To-Do

- Args to specify log output
