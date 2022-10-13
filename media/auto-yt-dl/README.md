# 💾 Auto-dl-playlist

# 🛈 Info

- A simple script to download video from a playlist.
- Download file in the highest quality possible and merge it to a mp4.
- Use crontab to automate the download

# 🎓 How it works

- The script reads your url(s) playlists from a file and downloads all the videos from them. <br>
- Then, the script saves the id of all the downloaded videos to avoid re-downloading the videos several times.

# 🔗 Dependency

- [Docker](https://docs.docker.com/get-docker/)

# 👷 How to use

```bash
# build image
$ docker build -t lv00/auto-yt-dl .
```

```bash
# Run container
$ docker run --rm -d \
  -v /data:/data \ # Default location of download
  lv00/auto-yt-dl
```

```bash
# Run container with args
$ docker run --rm -d \
  -v /path/to/data:/data \
  lv00/auto-yt-dl \
  --playlist /data/pl.txt \
  --output /data/yt
```

```bash
# Cron job example
0 0 * * * root docker run --rm -d -v /data/tankT/media/YT:/data lv00/auto-yt-dl
```

# 🔧 Args

| Options    | Short | Meaning                                       | Default             |
| ---------- | ----- | --------------------------------------------- | ------------------- |
| --playlist | -p    | Define the location of the playlist text file | /data/playlist.txt  |
| --output   | -o    | Define the output folder                      | /data               |
| --help     | -h    | Show help                                     |                     |

# 💭 To-Do
