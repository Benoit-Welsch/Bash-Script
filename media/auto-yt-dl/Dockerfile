FROM lv00/yt-dlp

RUN apk add util-linux

COPY auto-yt-dl.sh /usr/bin/start.sh

WORKDIR /media

RUN chmod +x /usr/bin/start.sh

ENTRYPOINT ["sh /usr/bin/start.sh"]