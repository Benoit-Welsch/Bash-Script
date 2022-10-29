# PostGreSQL Backup

A simple script to backup your PostGreSQL database

# Dependency

- [docker](https://docs.docker.com/get-docker/)

# How to use

Create a .env file with your db credentials (--env-file) or pass them directly to docker (-e)

| env        |                |                            |
| ---------- | -------------- | -------------------------- |
| PGHOST     | postgresql     |                            |
| PGUSER     | root           |                            |
| PGPASSWORD | root           |                            |
| PGPORT     | 5432           |                            |
| PGDB       | db_1;db_2;db_3 | ( backup selected db only) |
| PGDB       | \*\*\*         | ( backup all db )          |

```bash
docker pull lv00/backup_postgres
docker run -it --rm -v pg_dump:/data --env-file .env lv00/backup_postgres
```

# To-Do

- ...
