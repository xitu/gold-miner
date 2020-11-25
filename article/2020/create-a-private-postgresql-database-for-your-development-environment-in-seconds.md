> - 原文地址：[Create a Private PostgreSQL Database for Your Development Environment in Seconds](https://medium.com/better-programming/create-a-private-postgresql-database-for-your-development-environment-in-seconds-b781640ed01b)
> - 原文作者：[Doron Chosnek](https://medium.com/@doronchosnek)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/create-a-private-postgresql-database-for-your-development-environment-in-seconds.md](https://github.com/xitu/gold-miner/blob/master/article/2020/create-a-private-postgresql-database-for-your-development-environment-in-seconds.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[zenblo](https://github.com/zenblo),[hncboy](https://github.com/hncboy)

# 在几秒钟内为你的开发环境创建一个私有 PostgreSQL 数据库

![Photo by [Roi Dimor](https://unsplash.com/@roi_dimor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5948/0*msfDTPGlbTAD6DCs)

很多开发者在开始一个新项目的时候，通常会使用 JSON，CSV 或者其他 Flat File 来模拟真实存放在数据库中的数据。这是因为他们总是在没有真实的数据库环境限制和是否需要自己创建模拟数据库之间左右为难。既然这样，为什么不使用 Docker Compose 定义一个可以在几秒钟内创建、销毁和重新创建的 PostgreSQL 数据库**和监视工具**？

![Image source: Author](https://cdn-images-1.medium.com/max/2068/0*DHWuzy6UNQ4T1_zl)

正确创建配置两个容器的 Docker 命令过于冗长。而使用 Docker Compose，你只需要记住 `up` 命令和 `down` 命令！

`Up` 命令将创建指定版本的 PostgreSQL 数据库和一个 GUI 管理工具。`Down` 命令会将其关闭并删除。

## 基于私有容器的数据库的好处

- 不同版本的 PostgreSQL 在行为和功能上存在差异，因此开发人员应针对一个数据库版本进行长期开发。你可以选择的一个版本是 9.6.12，另一个可以是 12.4。
- 大多数程序员都不是数据库管理员或 SQL 专家。可视化工具可以让他们直观地验证其代码的运行效果并支持手动修改数据。
- 项目的不同阶段需要不同类型的存储方案。在项目早期，非持久型数据库可以最大程度地减少麻烦。在项目的后期阶段，持久型数据库提供了更实际的方案。

![Create and recreate a database with simple commands](https://cdn-images-1.medium.com/max/2000/0*oFz9LrOPfZNQdhcw)

## 建立开发堆栈

下面所展示的这份 `docker-compose.yml` 文件定义了一个运行特定版本 PostgreSQL 和 pgAdmin 4（Postgres 最常用的管理工具）的 PostgreSQL 容器。该文件的内容值得我们详细的探讨。

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

#### Docker Compose 的文件结构

该文件定义了两个要创建的“服务”：Postgres 和 pgAdmin。每个服务都包含一个从 Docker Hub 拉取的容器。Postgres 和 pgAdmin 将分别开放 5432 端口和 8080 端口。将你写的任何程序指向主机名“localhost”，然后用浏览器访问 [http://localhost:8080](http://localhost:8080/) 即可访问 pgAdmin。

继续阅读有关如何将 pgAdmin 指向 Postgres 的说明。

#### PostgreSQL 的版本

在定义 Postgres 容器的这一行中，你需要准确指定所需的 Postgres 版本。在这里，版本是一个标签，而 `9.6.12-alpine` 就是示例中使用的版本。点击[这里查看其他可用的版本](https://hub.docker.com/_/postgres?tab=tags)。

#### Postgres 的存储

上面的 `docker-compose.yml` 文件为 Postgres 指定了两个 volume 映射。这两个映射将使 Postgres 可以访问你计算机上的目录。

1. 被映射到 `/docker-entrypoint-initdb.d` 的文件夹包含了初始化 Postgres 将会用到的 SQL 文件。将所需的 SQL 文件和 Shell 脚本放在该目录中，它们将会按字母顺序自动执行。
2. 被映射到 `/var/lib/postgresql/data` 的文件夹存放了数据库持久化存储所需要的实际文件。

当 Postgres 启动时，他的简单运行流程如下图所示。如果数据库中没有数据，那么它将执行被映射到 `/docker-entrypoint-initdb.d` 目录中的每个 SQL 文件和 Shell 脚本（按字母顺序）。如果被映射到 `/var/lib/postgresql/data` 目录的文件夹中有数据，那么它将会忽略掉这些文件。

![](https://cdn-images-1.medium.com/max/2024/0*nMQaPxUKmYq67hAa)

你是否需要挂载这两个目录？这个得视情况而定。下表描述了通过 Postgres 的两个不同映射得到的一个预期结果。

![](https://cdn-images-1.medium.com/max/3492/1*gsuTB2Ge04sCccMKLzW6ww.png)

我的建议是对这两个文件目录都做映射。如果你不想再初始化你的数据库，你可以从 init 目录中删除文件。你也可以在你的计算机上删除任何可能已经持久化的数据（当你下一次运行 `docker-compose up` 命令时，Docker 将会在其位置重新创建一个空文件夹）。

**专业提示**：你可以将 CSV 文件放在计算机的 init 文件夹中，然后在 init 目录中通过适当的 SQL 命令将 CSV 文件中的数据填充到数据表中。

```
CREATE TABLE Employee(id, first_name, last_name, salary);
COPY Employee FROM '/docker-entrypoint-initdb.d/emp.csv'
    WITH (FORMAT CSV, HEADER);
```

#### pgAdmin 的存储

![](https://cdn-images-1.medium.com/max/2000/1*pXNa6oSZ72IOr6DCodBWsQ.png)

尽管 pgAdmin 只是一个用于查看和配置数据库的工具，但必须配置其与数据库的连接。这可以通过可视化工具中的 `add server`指令完成。这里需要注意的是，主机名（the hostname）是我们在 YML 文件中配置的 `container_name` 这一参数的名称，即 `some-postgres`。同样地，密码也已经在 YML 文件中指定了，即 `mysecret`。

另一种方法是通过在 JSON 文件中指定这些配置（除了密码之外的所有配置），通过这种方式可以免去大量的单击和输入操作。为了避免手动配置 pgAdmin 到 Postgres 的连接，我们需要将该 JSON 文件映射到容器 `/pgadmin4/servers.json` 上（在示例 YML 文件中的第 22 行）。

设置文件可以指定 pgAdmin 和 Postgres 之间的多个连接（以不同用户的身份连接或者连接到多个不同的数据库）。下面是只有一个数据库连接的示例。

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

#### 网络

`container_name` 参数仅仅只表示一个名字。但是 pgAdmin 将使用这个名称访问 5432 端口上的数据库。原因如下图所示。这两个容器通过私有网络相互连接，因此可以通过它们的主机名（容器名）也就是 `some-postgres` 和 `some-pgadmin` 相互访问。然而，你的主机（也就是你的计算机和 web 浏览器）只能访问容器对外暴露的 5432 端口和 8080 端口，因此你可以通过 `localhost:5432` 和 `localhost:8080` 访问它们。

![](https://cdn-images-1.medium.com/max/2000/0*U5ZE2OtxU4JKmWTq)

内部网络的名称可以在 compose 文件中指定，但是为一个从未被代码引用的网络命名没有任何价值！如果你还是好奇，可以随时查看你的私人及临时网络的名称。在下面的代码片段中，我从桌面运行了 Docker Compose，因此将该网络命名为 `desktop_default`。

```
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
23a6be9b8021        bridge              bridge              local
49a120440f88        desktop_default     bridge              local
44a949b56fa7        host                host                local
3892b16dca2d        none                null                local
```

## Docker 和 docker-compose 命令

在这里，我必须承认我在前言中过于简化了命令操作，但只是稍微简化了一点。

**为了启动容器**，可以使用 `docker-compose up -d`。`-d` 参数指定这是一个 `detached` 模式，它将会在后台运行，并且不会影响你在命令提示符中执行其他命令。

```
$ docker-compose up -d
Creating network "desktop_default" with the default driver
Creating some-postgres ... done
Creating some-pgadmin  ... done
$
```

**为了关闭并删除容器**，你可以使用 `docker-compose down -v`。`-v` 参数表示删除容器在运行时使用的 volume。这个**不会**删除计算机映射到容器上的目录。

```
$ docker-compose down -v
Stopping some-pgadmin  ... done
Stopping some-postgres ... done
Removing some-pgadmin  ... done
Removing some-postgres ... done
Removing network desktop_default
```

随着时间的推移，如果不使用 `-v` 标志，就会累积不必要的 volume。你可以使用 `docker volume ls` 来验证这一点。

如果要调试一个没有正确启动的容器，请使用 `docker logs [container_name]`。例如，由于 init 目录中的一个 SQL 文件中出现错误，数据库可能无法正确初始化。通过执行 `docker logs some-postgres` 命令，可以生成容器启动时记录的日志，通过对该日志的查阅，我在一个特殊命名的 SQL 文件中发现一个错误：

```
/usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/broken.sql
ERROR:  syntax error at end of input at character 34
STATEMENT:  CREATE TABLE Songs(id, name, year
psql:/docker-entrypoint-initdb.d/broken.sql:1: ERROR:  syntax error at end of input
LINE 1: CREATE TABLE Song(id, name, year
```

日志告诉我在 `broken.sql` 文件的第 1 行有一个错误。该命令缺少右括号和分号。我可以修复这个错误，并使用 `down` 和 `up` 来验证。

---

## 使用 Python

使用 localhost 作为 YML 文件中指定的主机名和密码，连接到数据库很容易。

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

## 使用 pgAdmin

简单的访问 [http://localhost:8080](http://localhost:8080) 即可进入登录界面，使用你在 `docker-compose.yml` 文件中定义的用户名和密码登录即可（在我们的示例中是 `user@domain.com` 和 `admin`）。

![](https://cdn-images-1.medium.com/max/2248/1*-OLNPQfPVcaVcm55_endYQ.png)

如果你使用的是本文之前讨论的 `servers.json` 文件来指定连接细节，你将会在展开用户界面左侧的导航树时，收到系统要求你输入 Postgres 数据库的密码的提示。在我们示例的 `docker-compose.yml` 文件中，这个密码是 `mysecret`。如果你并没有创建 `servers.json` 文件或文件中有错误，你就必须手动添加服务器。

![](https://cdn-images-1.medium.com/max/2000/1*sMq0Cmnkvn35uUO3pImD4A.png)

现在，你应该能够查看和操作数据库了。

![](https://cdn-images-1.medium.com/max/2248/1*DRpjQBkotrGn8QryDRjQ7w.png)

## 进入 PSQL

有时候，开发者需要一个熟悉的命令行。Docker 使得访问 PSQL 和执行高级用户命令等操作变得更加容易。执行下面的命令进入 PSQL 命令行。

![](https://cdn-images-1.medium.com/max/2156/0*yYxwukbBZY7poPVw)

连接后，你就可以执行所有 PSQL 命令，例如，输入 `\i` 用于导入外部数据库，输入 `\dt` 显示数据表的描述，输入 `\df` 显示函数的描述。想要退出，可以使用 `\q` 命令。

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

## pgAdmin 的替代品

![Adminer is a much simpler interface](https://cdn-images-1.medium.com/max/2248/1*m5zp3RSC4VN9_0-IaeSjBg.png)

pgAdmin 是 PostgreSQL 最常见的 GUI 管理工具，但我们还有其他选择。Adminer 的使用更加简单，并且你可能已经拥有使用它的经验了，因为它支持多种风格的 SQL。如果你是刚开始使用 PostgreSQL 或者只有非常简单的需求，那么它可能是一个更合适你的工具。

在登录界面上，设置主机名为 `some-postgres` ，密码为 `mysecret`。

![](https://cdn-images-1.medium.com/max/2000/1*iTf4Z6_ATNyE1VW3CTI5dg.png)

要在你的环境中用 Adminer 替换 pgAdmin，你需要在 `docker-compose.yml` 中替换几行有关 pgAdmin 容器的定义。

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

## 参考资料

所有优秀的开发者都依赖于产品文档和其他人员的经验。这是我在创建工作流程和编写本文时引用的参考资料。

- [https://hub.docker.com/\_/postgres](https://hub.docker.com/_/postgres)
- [https://hub.docker.com/\_/adminer](https://hub.docker.com/_/adminer)
- [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)
- [https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html](https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html)
- [https://technology.amis.nl/2020/01/02/pgadmin-in-docker-provision-connections-and-passwords/](https://technology.amis.nl/2020/01/02/pgadmin-in-docker-provision-connections-and-passwords/)
- [https://stackoverflow.com/questions/42248198/how-to-mount-a-single-file-in-a-volume](https://stackoverflow.com/questions/42248198/how-to-mount-a-single-file-in-a-volume)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
