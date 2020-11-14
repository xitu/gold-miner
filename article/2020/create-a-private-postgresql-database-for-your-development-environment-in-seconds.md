> * 原文地址：[Create a Private PostgreSQL Database for Your Development Environment in Seconds](https://medium.com/better-programming/create-a-private-postgresql-database-for-your-development-environment-in-seconds-b781640ed01b)
> * 原文作者：[Doron Chosnek](https://medium.com/@doronchosnek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/create-a-private-postgresql-database-for-your-development-environment-in-seconds.md](https://github.com/xitu/gold-miner/blob/master/article/2020/create-a-private-postgresql-database-for-your-development-environment-in-seconds.md)
> * 译者：
> * 校对者：

# Create a Private PostgreSQL Database for Your Development Environment in Seconds

![Photo by [Roi Dimor](https://unsplash.com/@roi_dimor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5948/0*msfDTPGlbTAD6DCs)

When starting a new project, many developers use a JSON, CSV, or other flat file to simulate the data that might live in a database. Developers are torn between the hassle of creating their own database and the limitations associated with not having a real database. Why not define a PostgreSQL database **and monitoring tool** that you can create, destroy, and recreate in a matter of seconds using Docker Compose?

![Image source: Author](https://cdn-images-1.medium.com/max/2068/0*DHWuzy6UNQ4T1_zl)

The Docker commands for creating two containers with just the right settings are lengthy. With Docker Compose, you only need to remember the commands `up` and `down`!

`Up` will create a PostgreSQL database at a specified version and a GUI-based tool for management. `Down` will shut down and remove them.

## Benefits of a Private Container-Based Database

* There are behavioral and feature differences between versions of PostgreSQL, so developers should develop against the database version they will be supporting long-term. It could be 9.6.12 on one project and 12.4 on another.
* Most app developers are not database admins or SQL experts. A graphical tool enables visual verification of the effects of their code and manual modification of the data.
* Different stages of a project necessitate different types of storage. In the early stages of a project, a non-persistent database minimizes headaches. In the later stages of a project, a persistent database provides more realistic scenarios.

![Create and recreate a database with simple commands](https://cdn-images-1.medium.com/max/2000/0*oFz9LrOPfZNQdhcw)

## Build the Dev Stack

The following `docker-compose.yml` file defines a PostgreSQL container running a specific version of PostgreSQL and pgAdmin 4 (the most common administrative tool for Postgres). The contents of this file warrant a deeper explanation.

```YAML
version: "3.8"
services:
  postgres:
    image: postgres:9.6.12-alpine
    container_name: some-postgres
    volumes:
      - "~/Documents/docker_pgsql_init:/docker-entrypoint-initdb.d"
      - "~/Documents/docker_pgsql_volume:/var/lib/postgresql/data"
    ports:
      - 5432:5432
    environment:
      - POSTGRES_PASSWORD=mysecret
    deploy:
      restart_policy:
        condition: on-failure
        max_attempts: 3
      
  pgadmin:
    image: dpage/pgadmin4
    container_name: some-pgadmin
    volumes:
      - ${PWD}/servers.json:/pgadmin4/servers.json
    ports:
      - 8080:80
    environment:
      - PGADMIN_DEFAULT_EMAIL=user@domain.com
      - PGADMIN_DEFAULT_PASSWORD=admin
    deploy:
      restart_policy:
        condition: on-failure
        max_attempts: 3
```

#### The Docker Compose file structure

This file defines two “services” to be created: Postgres and pgAdmin. Each service consists of a single container pulled for you from Docker Hub. Postgres and pgAdmin will be available at port 5432 and port 8080 respectively. Point any programs you write at hostname `localhost` and browse to [http://localhost:8080](http://localhost:8080) to access pgAdmin.

Keep reading for instructions on how to point pgAdmin to Postgres.

#### PostgreSQL version

In the line that defines the Postgres container, you’ll want to specify the exact version of Postgres that you need. The version is represented as a tag where `9.6.12-alpine` is the version in our example. Check [here to see which other versions are available](https://hub.docker.com/_/postgres?tab=tags).

#### Storage for Postgres

The `docker-compose.yml` file above specifies two volume mappings for Postgres. These two mappings will make directories on your computer accessible to Postgres.

1. The folder mapped to `/docker-entrypoint-initdb.d` contains the SQL files that Postgres will use to initialize the database. Put SQL files and shell scripts you need in that directory and they will be automatically executed in alphabetical order.
2. The folder mapped to `/var/lib/postgresql/data` contains the persistent storage for the actual database.

When Postgres starts, it follows the simple flowchart below. If there is no data in the DB, then it executes every SQL file and shell script (in alphabetical order) in the folder on your computer that is mapped to in the `/docker-entrypoint-initdb.d` directory. If there is data in the folder on your computer mapped to `/var/lib/postgresql/data`, then it ignores the files.

![](https://cdn-images-1.medium.com/max/2024/0*nMQaPxUKmYq67hAa)

Should you mount both directories? It depends. The table below describes the behavior you should expect by mapping each of the two volumes for Postgres.

![](https://cdn-images-1.medium.com/max/3492/1*gsuTB2Ge04sCccMKLzW6ww.png)

My advice is to map both directories. You can remove files from the init directory if you no longer want to initialize your DB. You can also delete the data directory from your computer to delete any data that would have persisted (Docker will recreate an empty folder in its place the next time you run `docker-compose up`).

**Pro Tip**: you can include CSV files in the init folder on your computer and then populate tables with data from those CSV files by adding the appropriate command to an SQL file in the init directory.

```
CREATE TABLE Employee(id, first_name, last_name, salary);
COPY Employee FROM '/docker-entrypoint-initdb.d/emp.csv'
    WITH (FORMAT CSV, HEADER);
```

#### Storage for pgAdmin

![](https://cdn-images-1.medium.com/max/2000/1*pXNa6oSZ72IOr6DCodBWsQ.png)

Although pgAdmin is just a tool for viewing and configuring the database, its connection(s) to the database must be configured. This can be done through the GUI with the “add server” command. Note that the hostname is the `container_name` parameter from our YML file: `some-postgres`. The password is also specified in the YML file: `mysecret`.

An alternative is to save a lot of clicking and typing by specifying these settings (everything except the password) in a JSON file. Map that JSON file to `/pgadmin4/servers.json` on the container (line 22 in our example YML file) to avoid having to manually configure pgAdmin’s connection to Postgres.

The settings file can specify multiple connections between pgAdmin and Postgres (to connect as different users or to connect to different databases). The following example has only one connection.

```JSON
{
    "Servers": {
        "1": {
            "Name": "my-postgres",
            "Group": "Servers",
            "Port": 5432,
            "Username": "postgres",
            "Host": "some-postgres",
            "SSLMode": "prefer",
            "MaintenanceDB": "postgres"
        }
    }
}
```

#### Networking

The `container_name` parameter is just a name, but it is the name that will be used by pgAdmin to access the database on port 5432. The reason is illustrated in this diagram. The two containers are connected to each other via a private network and can therefore access each other via their hostnames (the container names) `some-postgres` and `some-pgadmin`. The host (your computer and web browser), however, only sees ports 5432 and 8080 exposed and therefore accesses them at `localhost:5432` and `localhost:8080`.

![](https://cdn-images-1.medium.com/max/2000/0*U5ZE2OtxU4JKmWTq)

The name of that internal network can be specified in the compose file, but there is no value in naming a network whose name is never referenced by your code. Let Docker handle that! If you are curious, you can always view your private and temporary network’s name. In the snippet below, I ran Docker Compose from desktop, so it named the network `desktop_default`.

```
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
23a6be9b8021        bridge              bridge              local
49a120440f88        desktop_default     bridge              local
44a949b56fa7        host                host                local
3892b16dca2d        none                null                local
```

## Docker and docker-compose Commands

Here is where I have to admit that I oversimplified the commands in my introduction, but only slightly.

**To start the containers**, use `docker-compose up -d`. The `-d` option specifies “detached” mode, where containers run in the background and you can execute additional commands at the command prompt.

```
$ docker-compose up -d        
Creating network "desktop_default" with the default driver
Creating some-postgres ... done
Creating some-pgadmin  ... done
$
```

**To stop and remove the containers**, use `docker-compose down -v`. The `-v` option removes volumes that the containers used while they were running. This **does not** delete the directories on your computer that were mapped to the containers.

```
$ docker-compose down -v
Stopping some-pgadmin  ... done
Stopping some-postgres ... done
Removing some-pgadmin  ... done
Removing some-postgres ... done
Removing network desktop_default
```

Over time, you will accumulate unnecessary volumes if you don’t use the `-v` flag. You can verify this with `docker volume ls`.

**To troubleshoot a container** that is not starting properly, use `docker logs [container_name]`. For example, your database might not initialize properly due to an error in one of the SQL files in the init directory. I scrolled through the logs after running `docker logs some-postgres` to find an error in an appropriately named SQL file:

```
/usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/broken.sql
ERROR:  syntax error at end of input at character 34
STATEMENT:  CREATE TABLE Songs(id, name, year
psql:/docker-entrypoint-initdb.d/broken.sql:1: ERROR:  syntax error at end of input
LINE 1: CREATE TABLE Song(id, name, year
```

The log tells me that there is an error on line 1 of the file `broken.sql`. That command is missing the closing parenthesis and semicolon. I can fix that error and use `down` and `up` to verify.

---

## Using Python

Using localhost as the hostname and the password specified in the YML file, connecting to the database is easy.

```Python
import psycopg2

# connect to DB
conn = psycopg2.connect(host="localhost", dbname="postgres", user="postgres",
    password="mysecret")
cursor = conn.cursor()

# execute SQL commands in SQL file
cursor.execute(open("emp.sql", "r").read())

# retrieve data from the database
cursor.execute("SELECT * FROM Employee")
print(cursor.fetchall())
```

## Using pgAdmin

Simply connect to [http://localhost:8080](http://localhost:8080) to access the login page, and use the username and passwords specified in `docker-compose.yml` (`user@domain.com` and `admin` in our example).

![](https://cdn-images-1.medium.com/max/2248/1*-OLNPQfPVcaVcm55_endYQ.png)

If you specified connection details in a `servers.json` file as discussed earlier in this article, you will be prompted for the password for the Postgres database when you try to expand the navigation tree on the left side of the user interface. That password is `mysecret` in our `docker-compose.yml`. If you did not include a `servers.json` file or there is an error in your file, you will have to add a server manually.

![](https://cdn-images-1.medium.com/max/2000/1*sMq0Cmnkvn35uUO3pImD4A.png)

You should now be able to view and manipulate the database.

![](https://cdn-images-1.medium.com/max/2248/1*DRpjQBkotrGn8QryDRjQ7w.png)

## Getting to PSQL

Sometimes a developer needs the familiar command line. Docker makes it easy to access PSQL and execute commands like a power user. Enter the PSQL command line with the command shown here.

![](https://cdn-images-1.medium.com/max/2156/0*yYxwukbBZY7poPVw)

Once connected, you have access to all the PSQL commands, like `\i` for include or `\dt` and `\df` to describe tables and functions. To exit, use the `\q` command.

```
$ docker exec -it some-postgres psql -U postgres

psql (9.6.12)
Type "help" for help.

postgres=# \dt
List of relations
Schema |     Name     | Type  |  Owner
--------+--------------+-------+----------
public | peak         | table | postgres
public | climb        | table | postgres
public | climber      | table | postgres
```

## Alternative to pgAdmin

![Adminer is a much simpler interface](https://cdn-images-1.medium.com/max/2248/1*m5zp3RSC4VN9_0-IaeSjBg.png)

pgAdmin is the most common administrative GUI for PostgreSQL, but there are others. Adminer is much simpler to use, and you may already have experience with it as it supports several SQL flavors. If you are just getting started with PostgreSQL or have very simple needs, this might be a more appropriate tool.

At the login screen, use `some-postgres` as the host and `mysecret` as the password.

![](https://cdn-images-1.medium.com/max/2000/1*iTf4Z6_ATNyE1VW3CTI5dg.png)

To replace pgAdmin with Adminer in your environment, replace the pgAdmin container definition in `docker-compose.yml` with the lines below.

```YAML
  adminer:
    image: adminer
    container_name: some-adminer
    ports:
      - 8080:8080
    deploy:
      restart_policy:
        condition: on-failure
        max_attempts: 3
```

## References

All good developers rely on product documentation combined with the experiences of others. Here are the sources I used in creating my workflow and this article.

* [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)
* [https://hub.docker.com/_/adminer](https://hub.docker.com/_/adminer)
* [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)
* [https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html](https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html)
* [https://technology.amis.nl/2020/01/02/pgadmin-in-docker-provision-connections-and-passwords/](https://technology.amis.nl/2020/01/02/pgadmin-in-docker-provision-connections-and-passwords/)
* [https://stackoverflow.com/questions/42248198/how-to-mount-a-single-file-in-a-volume](https://stackoverflow.com/questions/42248198/how-to-mount-a-single-file-in-a-volume)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
