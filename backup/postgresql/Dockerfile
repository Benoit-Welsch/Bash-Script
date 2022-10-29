FROM postgres:latest

WORKDIR /data

COPY pg_dump.sh /usr/local/bin/pg_dump.sh

RUN chmod +x /usr/local/bin/pg_dump.sh

CMD ["/usr/local/bin/pg_dump.sh"]