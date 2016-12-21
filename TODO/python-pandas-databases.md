> * 原文地址：[Working with SQLite Databases using Python and Pandas](https://www.dataquest.io/blog/python-pandas-databases/)
* 原文作者：[Vik Paruchuri](https://twitter.com/vikparuchuri)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[marcmoore](https://github.com/marcmoore), [futureshine](https://github.com/futureshine)

# `Python` 和 `Pandas` 在 `SQLite` 数据库中的运用


[SQLite](https://www.sqlite.org) 是一个数据库引擎，使用它能方便地存储和处理关系型数据。它和 _csv_ 格式很相似，`SQLite` 把数据存储在一个单独的文件中，它能方便地与其他人共享。大部分的编程语言和编译环境都对 `SQLite` 数据库提供了很好的支持。`Python` 也不例外，并且专门有一个访问 `SQLite` 数据库的程序库，叫做 `sqlite3`，自从 `2.5` 版本以来，它就已经被 `Python` 纳入标准库里。在这篇博文中，我们将学会如何使用 `sqlite3` 创建、查询和更新数据库。也包括了，使用 [pandas](https://pandas.pydata.org/) 程序包如何简化 `SQLite` 数据库。我们会使用 `Python 3.5`，但是所有的实现方法应该兼容 `Python 2`。 

在我们开始之前，让我们先快速检阅下我们之后要处理的数据。我们看到的是航空公司的航班数据，它包含了有关航空公司的信息，机场名称和往来各个机场的航线名称。每一条航线代表着有一架航班重复往返于目的地和始发地的机场。

所有的数据都存在一个叫做 `flights.db` 的数据库中，它有三张表格 - `airports`, `airliens`, `routes`。你可以到 [这里](https://www.dropbox.com/s/a2wax843eniq12g/flights.db?dl=0) 下载到它。

这里有两行来自 `airlines` 表格的数据:


|     | id  | name                   | alias | iata | icao | callsign | country  | active |
|-----|-----|------------------------|-------|------|------|----------|----------|--------|
| 10  | 11  | 4D Air                 | \\N   | NaN  | QRT  | QUARTET  | Thailand | N      |
| 11  | 12  | 611897 Alberta Limited | \\N   | NaN  | THD  | DONUT    | Canada   | N      |

就如你在上表中看到的，每一行都是一个不同的航空公司，每一列是这个航空公司的属性，例如 `name` 和 `country`。每一个航空公司也都有一个独一无二的 `id`，所以如果需要的时候，我们能非常方便地查询到。

这里有两行来自 `airports` 表格的数据:


|     | id  | name   | city   | country          | code | icao | latitude  | longitude  | altitude | offset | dst | timezone              |
|-----|-----|--------|--------|------------------|------|------|-----------|------------|----------|--------|-----|-----------------------|
| 0   | 1   | Goroka | Goroka | Papua New Guinea | GKA  | AYGA | -6.081689 | 145.391881 | 5282     | 10     | U   | Pacific/Port\_Moresby |
| 1   | 2   | Madang | Madang | Papua New Guinea | MAG  | AYMD | -5.207083 | 145.7887   | 20       | 10     | U   | Pacific/Port\_Moresby |


就如你所看到的，每一行都对应了一个机场，并且包含了机场所在地的信息。每一个机场也有一个独一无二的 `id`，所以我们也能方便地进行查询。

这里有两行来自 `routes` 表格的数据:


|     | airline | airline\_id | source | source\_id | dest | dest\_id | codeshare | stops | equipment |
|-----|---------|-------------|--------|------------|------|----------|-----------|-------|-----------|
| 0   | 2B      | 410         | AER    | 2965       | KZN  | 2990     | NaN       | 0     | CR2       |
| 1   | 2B      | 410         | ASF    | 2966       | KZN  | 2990     | NaN       | 0     | CR2       |


每一条航线包含有一个 `airline_id`，这个 `id` 代表飞这条航线的航空公司，`souce_id` 也是，它是航班始发地机场的 `id`，而 `dest_id` 是该航班目的地机场的 `id`。

至此，我们知道了需要处理的是什么数据，让我们先从连接数据库和执行一条查询指令开始。

## 使用 `Python` 执行数据库的查询指令

为了通过 `Python` 使用 `SQLite` 数据库，我们先要连接这个数据库。我们可以使用 [connect](https://docs.python.org/3/library/sqlite3.html?highlight=connect#sqlite3.connect) 方法, 它返回一个 [Connection](https://docs.python.org/3/library/sqlite3.html?highlight=connect#sqlite3.Connection) 对象:



    import sqlite3

    conn = sqlite3.connect("flights.db")



一旦我们有了一个 `Connection 对象`，之后创建一个 [Cursor](https://docs.python.org/3/library/sqlite3.html#cursor-objects) 对象。`Cursors` 让我们能对一个数据库执行 `SQL` 查询指令。



    cur = conn.cursor()



一旦我们有了这个 `Cursor 对象`，我们能使用它通过适当地调用 [execute](https://docs.python.org/3/library/sqlite3.html?highlight=connect#sqlite3.Cursor.execute) 方法来对数据库执行查询指令。通过以下代码，你能从 `airlines` 表中获取前 `5` 行数据结果。



    cur.execute("select * from airlines limit 5;")



你可能已经注意到，我们没有把之前的查询结果存储到一个变量中。这是因为我们需要执行另外一个指令来真正地获得结果。我们可以使用 [fetchall](https://docs.python.org/3/library/sqlite3.html?highlight=connect#sqlite3.Cursor.fetchall) 方法来获取查询的结果。



    results = cur.fetchall()
    print(results)





    [(0, '1', 'Private flight', '\\N', '-', None, None, None, 'Y'),
     (1, '2', '135 Airways', '\\N', None, 'GNL', 'GENERAL', 'United States', 'N'),
     (2, '3', '1Time Airline', '\\N', '1T', 'RNX', 'NEXTIME', 'South Africa', 'Y'),
     (3, '4', '2 Sqn No 1 Elementary Flying Training School', '\\N', None, 'WYT', None, 'United Kingdom', 'N'),
     (4, '5', '213 Flight Unit', '\\N', None, 'TFU', None, 'Russia', 'N')]



如你所见，查询结果以 一组 [tuples](https://docs.python.org/3.5/tutorial/datastructures.html#tuples-and-sequences) 的格式返回。每一个 `tuple` 对应了我们从数据库中访问到某一行数据。以这种形式处理数据是非常麻烦的。我们需要人为地增加每一列的表头，并且手动解析数据。 幸运的是，`pandas` 提供的库中有更加便捷的方法，我们会在下一个部分中提到它。

在我们继续探索之前，及时关闭那些被打开的 `Connection 对象` 和 `Cursor 对象` 是良好的习惯。这样避免了 `SQLite` 数据库被锁上。当一个 `SQLite` 数据库被锁上的时候，你可能就无法对这个数据库进行更新操作了，也会得到错误的提示。我们能通过以下方式关闭 `Connection 对象` 和 `Cusor 对象`:



    cur.close()
    conn.close()



### 绘制机场地图

使用我们新发现的查询指令，我们能在世界地图上描绘和展示出所有机场的位置。首先，我们先要查询机场的经纬度坐标：



    import sqlite3

    conn = sqlite3.connect("flights.db")
    cur = conn.cursor()
    coords = cur.execute("""
      select cast(longitude as float),
      cast(latitude as float)
      from airports;"""
    ).fetchall()



以上的查询代码将检索返回 `airports` 表中每列 `latitude` 和 `longitude` 的数据，并把结果转化成 `float` 类型。之后，我们调用 `fetchall` 方法来获取他们。

接下来，我们通过导入 [matplotlib](http://matplotlib.org/) 来创建我们的测绘图，它是 `Python` 上主要的绘图库。结合 [basemap](http://matplotlib.org/basemap/) 包，这允许我们只使用 `Python` 就能创建地图。

首先，我们需要导入这些库:



    from mpl_toolkits.basemap import Basemap
    import matplotlib.pyplot as plt



之后，建立我们的地图，并且描绘出大陆和海岸线，它们会构成我们地图的背景。



    m = Basemap(
      projection='merc',
      llcrnrlat=-80,
      urcrnrlat=80,
      llcrnrlon=-180,
      urcrnrlon=180,
      lat_ts=20,
      resolution='c'
    )

    m.drawcoastlines()
    m.drawmapboundary()



最后，我们在地图上描绘出每一个机场的坐标。我们从 `SQLite` 数据库中检索一组 `tuples`。 在每个 `tuple` 中第一个元素是飞机场的经度，第二个是纬度。我们会把这些经度和纬度转换成它们自己的数组，之后把它们描绘在地图上。 



    x, y = m(
      [l[0] for l in coords],
      [l[1] for l in coords]
    )

    m.scatter(
      x,
      y,
      1,
      marker='o',
      color='red'
    )



最终，我们把每一个机场都展现在了世界地图上:





![](https://www.dataquest.io/blog/images/pyviz/mplmap.png)





你可能注意到，直接操作来自数据库的数据让你痛苦不堪。我们需要记住每一个 `tuple`
 的位置对应到数据库中每一列是什么，并且手动为每一列解析出每组各自的内容。

### 用 `pandas DataFrame` 读取数据结果

我们能使用 `pandas` 的 [read_sql_query](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_sql_query.html) 方法直接把一条 `SQL` 查询结果读取到一个 `pandas DataFrame` 中。下面的代码将执行和前文中作用一样的查询，但是它会返回一个 `DataFrame`。对比前文的数据查询方式，它能带来诸多好处:

* 我们不需要每次到最后都创建一个 `Cursor 对象` 或者调用 `fetchall`。
* 它能自动通过表头的名字来阅读整个表。
* 它创建了一个 `DataFrame`，所以我们能快速的挖掘数据。


```
    import pandas as pd
    import sqlite3

    conn = sqlite3.connect("flights.db")
    df = pd.read_sql_query("select * from airlines limit 5;", conn)
    df
```


|     | index | id  | name                                         | alias | iata | icao | callsign | country        | active |
|-----|-------|-----|----------------------------------------------|-------|------|------|----------|----------------|--------|
| 0   | 0     | 1   | Private flight                               | \\N   | -    | None | None     | None           | Y      |
| 1   | 1     | 2   | 135 Airways                                  | \\N   | None | GNL  | GENERAL  | United States  | N      |
| 2   | 2     | 3   | 1Time Airline                                | \\N   | 1T   | RNX  | NEXTIME  | South Africa   | Y      |
| 3   | 3     | 4   | 2 Sqn No 1 Elementary Flying Training School | \\N   | None | WYT  | None     | United Kingdom | N      |
| 4   | 4     | 5   | 213 Flight Unit                              | \\N   | None | TFU  | None     | Russia         | N      |

如你所见，我们得到了一个有着清晰格式的 `DataFrame` 作为结果。我们能方便地操作这些列:


    df["country"]





      0              None
      1     United States
      2      South Africa
      3    United Kingdom
      4            Russia
      Name: country, dtype: object



强烈建议尽可能使用 `read_sql_query` 方法。

### 构建航线图

至此，我们已经知道如何把查询结果读取到 `pandas DataFrames` 中，我们能在世界地图上创建每一个航空公司的航线图。首先，我们需要查询这些数据。查询方式如下:

* 获取每一条航线中始发地机场的经纬度。
* 获取每一条航线中目的地机场的经纬度。
* 把所有这些坐标转换成 `float` 类型。
* 把检索结果读取进一个 `DataFrame` 中，并把他们存在变量 `routes` 中。 


```
    routes = pd.read_sql_query("""
                               select cast(sa.longitude as float) as source_lon,
                               cast(sa.latitude as float) as source_lat,
                               cast(da.longitude as float) as dest_lon,
                               cast(da.latitude as float) as dest_lat
                               from routes
                               inner join airports sa on
                               sa.id = routes.source_id
                               inner join airports da on
                               da.id = routes.dest_id;
                               """,
                               conn)
```


之后，我们开始创建地图:



    m = Basemap(projection='merc',llcrnrlat=-80,urcrnrlat=80,llcrnrlon=-180,urcrnrlon=180,lat_ts=20,resolution='c')
    m.drawcoastlines()



首先，我们开始遍历最先的 `3000` 行数据，并绘制他们。代码如下:

* 把前 `3000` 行数据遍历存储到 `routes` 中。
* 判断航线是否太长。
* 如果航线不是很长:
    * 在始发地和目的地之间画一个圈。


```
    for name, row in routes[:3000].iterrows():
        if abs(row["source_lon"] - row["dest_lon"]) < 90:
            # Draw a great circle between source and dest airports.
            m.drawgreatcircle(
                row["source_lon"],
                row["source_lat"],
                row["dest_lon"],
                row["dest_lat"],
                linewidth=1,
                color='b'
            )
```


最后，我们完成了这个地图:





![](https://www.dataquest.io/blog/images/pyviz/mplmap2.png)





比起直接使用 `sqlite3` 处理这些原始检索数据，当我们使用 `pandas` 把所有的 `SQL` 检索到的数据读入一个 `DataFrame` 中是一个非常有效的方法。

至此，我们理解了如何检索数据库的内容，接下来，让我们看看如何对这些数据进行修改。





### 这篇博文还是挺有趣的吧？ 让我们使用 `Dataquest` 学习数据科学 

#####

* 选一个你喜欢的浏览器继续学习。
* 操作真实世界的数据。
* 创建一个项目集。

[免费在线课堂](https://www.dataquest.io/)



## 修改数据库的内容

我们可以使用 `sqlite3` 开发包来修改一个 `SQLite` 数据库，比如插入，更新或者删除某些行内容。创建数据库的连接和查询一个数据表的方法一样，所以我们会跳过这个部分。

### 使用 `Python` 插入行内容

为了插入一行数据，我们需要写一条 `INSERT` 查询指令。以下代码会对 `airlines` 表中新增加一行数据。我们指定 `9` 个需要被添加的数据，对应着 `airlines` 表格的每一列。这会为这个表增加一行新数据。 



    cur = conn.cursor()
    cur.execute("insert into airlines values (6048, 19846, 'Test flight', '', '', null, null, null, 'Y')")



如果你尝试对这个表格进行检索，你其实还不能看到这条新的数据。然而，你会看到一个名字为 `flights.db-journal` 的文件被创建了。在你准备好把它 `commit` 到主数据库 `flights.db` 之前，`flights.db-journal` 会代为存储新增加的行数据。 

`SQLite` 并不会写入数据库直到你提交了一个 [transaction](https://www.sqlite.org/lang_transaction.html)。每一个 `transaction` 包含了 1 个或者多个查询指令，它能把所有新的变化一次性提交给数据库。这样的设计使得从意外的修改或错误中恢复变得更加容易。`Transaction` 允许你执行多个查询指令，最终这些结果都会修改数据库。这确保了如果有一条查询指令失败了，数据库不会只有部分内容被更新。

举个例子来说，如果你有两张表，一张表包含了对银行账户收取的费用(`charges`)，另一张表包含了账户在银行内存款的余额(`balances`)。假定有一位银行客户 Roberto，他想给姐妹 Luisa 转 $50 美元。为了完成这笔交易，银行应该需要执行以下几步:

* 在 `charges` 中新增加一行，描述有 $50 美元正要从 Roberto 的账户转到 Luisa。
* 更新 Roberto `balances` 表中的数据内容，并且移除 $50 美元。
* 更新 Luisa `balances` 表中的数据内容，并且增加 $50 美元。

如此来说，为了更新所有的表格需要三次单独的 `SQL` 查询指令。如果一个查询指令失败了，我们的数据库就会被破损的数据卡住。举例来说，如果前两条指令成功运行了，第三条失败了，Roberto 将会损失他的钱，但是 Luisa 也不会获得这笔钱。`Transactions` 意味着主数据库不会被更新除非所有的查询指令都被成功执行。这避免了系统进入错误的状态，用户可能会丢失他们的存款。

默认情况下，当你执行了任何会修改数据库的查询指令时，`sqlite3` 会打开一个 `transaction`。你能在 [这里](https://docs.python.org/3/library/sqlite3.html#sqlite3-controlling-transactions) 了解更多。我们能提交 `transaction`，也能使用 [commit](https://docs.python.org/3/library/sqlite3.html#sqlite3.Connection.commit) 方法对 `airlines` 表新增加内容:


    conn.commit()



现在，当我们检索 `flights.db` 的时候，我们将看到这个额外的数据，它包含我们的测试航班。



    pd.read_sql_query("select * from airlines where id=19846;", conn)




|     | index | id    | name        | alias | iata | icao | callsign | country | active |
|-----|-------|-------|-------------|-------|------|------|----------|---------|--------|
| 0   | 1     | 19846 | Test flight |       |      | None | None     | None    | Y      |



### 对检索增加条件参数

在最后那条查询指令中，我们把固定值插入到所需要的数据库中。多数情况下，当你想插入数据到数据库中的时候，它不会是一些固定值，它应该是一些你想传入方法的动态值。这些动态值可能来自于下载得到的数据，或者来自于用户的输入。

当操作动态值的时候，有些人尝试用 `Python` 的格式化字符串来插入这些值:



    cur = conn.cursor()
    name = "Test Flight"
    cur.execute("insert into airlines values (6049, 19847, {0}, '', '', null, null, null, 'Y')".format(name))
    conn.commit()



你应该避免这样做！通过 `Python` 的格式化字符串插入数值会让你的程序更加容易受到 [SQL 注入](https://en.wikipedia.org/wiki/SQL_injection) 的攻击。幸运的是，`sqlite3` 有一个更加直接的方式来注入动态值，而不是依赖格式化的字符串。




    cur = conn.cursor()
    values = ('Test Flight', 'Y')
    cur.execute("insert into airlines values (6049, 19847, ?, '', '', null, null, null, ?)", values)
    conn.commit()



任何在查询指令中以 `?` 形式出现的数值都会被 `values` 中的数值替代。第一个 `?` 将会被 `values` 中的第一个数值替代，第二个也是，其他以此类推。这个方式对任何形式的查询指令都有用。如此就创建了一个 `SQLite` [带参数形式的查询指令](https://www.sqlite.org/lang_expr.html)，它有效避免了 `SQLite 注入` 的问题。

### 更新行数据内容

通过使用 `execute` 方法，我们可以修改在 `SQLite` 表格中某些行数据的内容:



    cur = conn.cursor()
    values = ('USA', 19847)
    cur.execute("update airlines set country=? where id=?", values)
    conn.commit()



之后，我们能验证更新的内容:



    pd.read_sql_query("select * from airlines where id=19847;", conn)


|     | index | id    | name        | alias | iata | icao | callsign | country | active |
|-----|-------|-------|-------------|-------|------|------|----------|---------|--------|
| 0   | 6049  | 19847 | Test Flight |       |      | None | None     | USA     | Y      |


### 删除某些行数据的内容

最后，通过使用 `execute` 方法，我们能删除数据库中的某些行数据内容:



    cur = conn.cursor()
    values = (19847, )
    cur.execute("delete from airlines where id=?", values)
    conn.commit()



之后，通过确认没有相匹配的查询内容，我们能验证这些行数据内容确实被删除了:



    pd.read_sql_query("select * from airlines where id=19847;", conn)



|     | index | id  | name | alias | iata | icao | callsign | country | active |
|-----|-------|-----|------|-------|------|------|----------|---------|--------|


## 创建表格

我们可以通过执行一条 `SQLite` 查询指令来创建表。我们能创建一个表，它能展示每天在某一条航线上的航班，使用以下几列:

* `id` — 整型
* `departure` — 日期型，表示飞机离开机场的时间 
*  `arrival` — 日期型，表示飞机到达目的地的时间
* `number` — 文本型，飞机航班号
* `route_id` — 整型，正在飞行的航线号


```
    cur = conn.cursor()
    cur.execute("create table daily_flights (id integer, departure date, arrival date, number text, route_id integer)")
    conn.commit()
```


一旦我们创建了这个表，我们就能对这个表插入数据:



    cur.execute("insert into daily_flights values (1, '2016-09-28 0:00', '2016-09-28 12:00', 'T1', 1)")
    conn.commit()



当我们对该表执行查询指令的时候，我们就能看到这些行数据内容:



    pd.read_sql_query("select * from daily_flights;", conn)



|     | id  | departure       | arrival          | number | route\_id |
|-----|-----|-----------------|------------------|--------|-----------|
| 0   | 1   | 2016-09-28 0:00 | 2016-09-28 12:00 | T1     | 1         |


### 使用 `pandas` 创建表

`pandas` 包提供给我们一个更加快捷地创建表格的方法。我们只需要先创建一个 `DataFrame`，之后把它导出到一个 `SQL` 表格内。首先，我们将创建一个 `DataFrame`:



    from datetime import datetime
    df = pd.DataFrame(
        [[1, datetime(2016, 9, 29, 0, 0) , datetime(2016, 9, 29, 12, 0), 'T1', 1]],
        columns=["id", "departure", "arrival", "number", "route_id"]
    )



之后，我们就能调用 [to_sql](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.to_sql.html) 方法，它将 `df` 转化成一个数据库中的数据表。我们把参数 `keep_exists` 设定成 `replace`，为了删除并且替换数据库中任何已存在的 `daily_flights`: 



    df.to_sql("daily_flights", conn, if_exists="replace")



通过对数据库执行查询指令，我们能验证是否正常工作了:



    pd.read_sql_query("select * from daily_flights;", conn)



|     | index | id  | departure           | arrival             | number | route\_id |
|-----|-------|-----|---------------------|---------------------|--------|-----------|
| 0   | 0     | 1   | 2016-09-29 00:00:00 | 2016-09-29 12:00:00 | T1     | 1         |


## 使用 `Pandas` 修改数据表

对于现实世界中的数据科学来说，最难处理的部分就是那些几乎经常每秒都不停变换着的数据。拿 `aireline` 这个例子来说，我们可能决定在 `airelines` 表中新增加一个 `airplanes` 的属性，它显示出每一个航空公司拥有多少架飞机。幸运的是，在 `SQLite` 中有一个方式能修改表并且添加这些列:



    cur.execute("alter table airlines add column airplanes integer;")



请注意，我们不需要调用 `commit` 方法 —— `alter table` 查询指令会被立刻执行，并且不会发生在一个 `transaction` 中。现在，我们能查询并且看到这些额外的列:



    pd.read_sql_query("select * from airlines limit 1;", conn)




|     | index | id  | name           | alias | iata | icao | callsign | country | active | airplanes |
|-----|-------|-----|----------------|-------|------|------|----------|---------|--------|-----------|
| 0   | 0     | 1   | Private flight | \\N   | -    | None | None     | None    | Y      | None      |



你可能注意到了，在 `SQLite` 中所有的列都被设值成了 `null`（在 `Python` 中被转化成了 `None`），因为这些列还没有任何数值。

### 使用 `Pandas` 修改表

也可以使用 `Pandas` 通过把表导出成 `DataFrame` 去修改表格的内容，仅需要对 `DataFrame` 进行修改，之后把这个 `DataFrame` 导出成一个表:



    df = pd.read_sql("select * from daily_flights", conn)
    df["delay_minutes"] = None
    df.to_sql("daily_flights", conn, if_exists="replace")



以上代码将会对 `daily_flight` 表增加一个叫做 `delay_minutes` 的列项。

## 延伸阅读

你现在应该对在 `SQLite` 数据库中如何使用 `Python` 和 `Pandas` 对数据操作有了一个很好的掌握和认识了。本文包含了查询数据库，更新行数据内容，插入行数据内容，删除行数据内容，创建数据表和修改数据表。这些已经覆盖了主要的 `SQL` 操作内容，这些几乎就是你的日常工作。

如果你想要深入了解，以下是一些补充资料:

*   [sqlite3 在线文档](https://docs.python.org/3/library/sqlite3.html)
*   [比较 `pandas` 和 `SQL`](http://pandas.pydata.org/pandas-docs/stable/comparison_with_sql.html)
*   [在线课程 —— `Dataquest SQL`](https://www.dataquest.io/path-step/working-with-data-sources)
*   [sqlite3 操作指南](http://sebastianraschka.com/Articles/2014_sqlite_in_python_tutorial.html)

如果你想继续自己操作下，你能从 [这里](https://www.dropbox.com/s/a2wax843eniq12g/flights.db?dl=0) 下载到博文中使用的 `flights.db` 文件。
