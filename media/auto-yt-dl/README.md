# Auto-dl-playlist 🤖

A simple script to download video from a playlist.

# 🎓 How it works 

The script reads your url(s) playlists from a file and downloads all the videos from them. <br>
Then, the script saves the id of all the downloaded videos to avoid re-downloading the videos several times.

# 🔧 Dependency 

- [docker](https://docs.docker.com/get-docker/)
- [column](https://command-not-found.com/column) (only used to show the help 😗)

# 🛈 Info 

- Download file in the highest quality possible and merge it to a mp4.
- Use crontab to automate the download

# 👷 How to use

```
$ chmod +x ./auto-dl-playlist.sh
$ ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/

$ ./auto-dl-playlist.sh --help
    Usage:      ./auto-dl-playlist.sh  [options] ...
    Example:    ./auto-dl-playlist.sh --playlist YT/playlist.txt --output YT/

    Option              Meaning
    --playlist    -p    Define the location of the playlist text file
    --output      -o    Define the output folder
    --user        -u    Define the uid:gid to use
    --help        -h    Show this help
```

# 💭 To-Do
