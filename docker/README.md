# Azkaban 3.70.3

## Set up environment
Spin up the `mysql` and the `azkaban_executor` containers.

```
docker-compose -f docker-compose.yml up mysql azkaban_executor --build
```

Access the `azkaban_executor` container.

```
docker exec -ti 3703-azkaban_executor-1 /bin/bash
```

Create the default database with the required tables.
```
echo "CREATE DATABASE azkaban;" | mysql -hmysql -proot
mysql -hmysql -proot azkaban </opt/azkaban/sql/create-all-sql-3.70.3.sql
```

Activate the executor.

```
curl -G "localhost:12321/executor?action=activate" && echo
```

Spin up the Azkaban web UI.

```
docker-compose -f docker-compose.yml up azkaban_web --build
```

Go to [http://localhost](http://localhost:80) to access Azkaban