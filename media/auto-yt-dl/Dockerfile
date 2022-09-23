FROM lv00/yt-dlp

RUN apk add util-linux bash

COPY auto-yt-dl.sh /usr/bin/start.sh

WORKDIR /data

RUN chmod +x /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]