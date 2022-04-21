# PostGreSQL Backup

A simple script to backup your PostGreSQL database

# Dependency

- [docker](https://docs.docker.com/get-docker/)

# How to use

Create a .env file with your db credentials (--env-file) or pass them directly to docker (-e)

| env        |                |
| ---------- | -------------- |
| PGHOST     | 127.0.01       |
| PGUSER     | root           |
| PGPASSWORD | root           |
| PGPORT     | 5432           |
| PGDB       | db_1;db_2;db_3 |

```bash
docker pull lv00/pg_dump
docker run -it --rm -v pg_dump:/data --env-file .env lv00/pg_dump
```

# To-Do

- ...
