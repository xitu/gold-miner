> * 原文地址：[Getting Started With SQLDelight in Android Development](https://betterprogramming.pub/getting-started-with-sqldelight-in-android-development-eecd0ae9bbdd)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md](https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md)
> * 译者：[airfri](https://github.com/airfri)
> * 校对者：

# Getting Started With SQLDelight in Android Development
# 在安卓开发中使用SQLDelight入门
![Photo by [Boitumelo Phetla](https://unsplash.com/@writecodenow?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*VDd7zDjJaPiGuQbA)

## Introduction
## 简介

SQLDelight is a cross-platform database library. It’s quite opposite to the traditional approach of ow annotation processes and reflections generate the code.

SQLDelight 是一个跨平台的数据库，ow 注释过程和反射生成代码的传统方法完全相反。

What makes it unique, even more than the fact that it supports cross-platform is that it takes SQL code and converts it into Kotlin/Java/Native code which supports different platforms like Android, iOS, web.

比起支持跨平台这一特点，SQLDelight 有一个更为重要的特点：将 SQL 代码转换为 Kotlin/Java/Native 代码，从而支持 Android、iOS、Web 等不同的平台。

When it comes to traditional platform-specific libraries like Room database, they make it easy to create the database tables and operations because you’re writing code in the same language.

就算使用诸如 Room 数据库之类的传统平台的特定库，也可以仅用 SQL 这一门语言轻松地创建数据库表和操作。

But when it comes to SQLDelight, you need to be able to write SQL queries by yourself. In my opinion, it’s both the strength and weakness of the library. I don’t prefer writing code other than Kotlin/Java as an Android developer, but on the other hand, it gives me the opportunity to support multiple platforms.

SQLDelight 需要开发者能自己编写 SQL 查询，这既是 SQLDelight 的优势也是它的劣势。因为，一方面，SQLDelight 可以使开发者编写的代码支持多个平台；但从另一方面来讲，有许多 Android 开发人员不喜欢编写除了 Kotlin/Java 以外的代码。

To be frank, when you’re developing a mobile app, you won’t need that much in-depth knowledge regarding SQL, basic coding, and syntactical knowledge to make it work.

但是说实话，开发者开发一个移动端 APP 时，就算对 SQL 的基础编程方法和语法了解地不深入，也可以写出 SQL 代码并运行编译。

So, without any delay, let’s get started:

因此，赶紧一起来入门 SQLDelight 吧：
## Integration
## 集成

Add the SQLDelight plugin in the project level Gradle file, as shown below:

把 SQLDelight 插件添加到项目级 Gradle 文件中，如下代码：

```Gradle
// Top-level build file where you can add configuration options common to all sub-projects/modules.
// 顶级构建文件，可以在其中添加所有子项目/模块的通用配置选项。

buildscript {
    ext.kotlin_version = "1.4.32"
    repositories {
        google()
        jcenter()
        // SQL Delight support repositories
        // SQL Delight支持存储库
        mavenCentral()
        maven { url 'https://www.jetbrains.com/intellij-repository/releases' }
        maven { url "https://jetbrains.bintray.com/intellij-third-party-dependencies" }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:4.1.3"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // SQL Delight plugin
        // SQL Delight 插件
        classpath 'com.squareup.sqldelight:gradle-plugin:1.5.0'
        
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

As a second step, we need to apply the SQLDelight plug-in on the app-level Gradle file to support code generation. SQL delight won’t base on annotation processors like `kapt` for code generation.

第二步，需要在应用级 Gradle 文件上应用 SQLDelight 插件来支持代码生成。 SQLDelight 不会基于 `kapt` 这样的注释处理器来生成代码。

The process of generating platform-specific code works because, in the end, you’re executing SQL queries. This is somewhat the same behavior when compared to platform-specific libraries like the Room database. Have a look at the following code:

生成特定平台的代码的过程之所以有效，是因为最终正在执行 SQL 查询，在某种程度上，这与 Room 数据库等特定平台的库是相似的。看看下面的代码：

```
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.squareup.sqldelight'
}
```

Until now we’ve integrated generic SQL Delight support, now we need to add the Android support library. `AndroidSqliteDriver` is what we need here. We need to add the following line under dependencies node in-app level Gradle file:

上面的操作已经集成了通用 SQL Delight 支持，现在需要添加 Android 支持库 —— `AndroidSqliteDriver` ，在依赖项节点应用程序级 Gradle 文件下添加以下代码：

```
implementation "com.squareup.sqldelight:android-driver:1.3.0"
```

## Write the SQL Code
## 写SQL代码

As a first to create the database, we should write the SQL code. The question is where should locate the (*.sq) files. We need to create a separate directory with the name `sqldelight` under the main directory, similar to java and Kotlin, and host all our (*.sq) files inside it.

写SQL代码来创建数据库，首先应该定位 *.sq 文件。在主目录下创建一个名为 `sqldelight` 的单独目录，类似于 java 和 Kotlin，并将所有的 *.sq 文件托管在其中。

```
src/main/sqldelight
```

Now without any further delay, let’s create our MovieItem.sql file. Add the following code inside the file:

紧接着，创建 MovieItem.sql 文件，把如下代码添加到 sql 文件中：

```SQL
CREATE TABLE moveItem (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    image TEXT NOT NULL,
    rating INTEGER NOT NULL DEFAULT 0
);
selectAll:
SELECT *
FROM moveItem
ORDER BY name;
insertOrReplace:
INSERT OR REPLACE INTO moveItem(
  name,
  image,
  rating
)
VALUES (?, ?, ?);
selectByName:
SELECT *
FROM moveItem
WHERE name = ?;

empty:
DELETE FROM moveItem;
```

Once you add the above code, you’ll be shown a suggestion to Install the SQLDelight Android Studio Plugin. It’s not mandatory but makes it easy to understand the syntax. I recommend installing the plugin.

添加了上述代码后，将会弹出提示安装 SQLDelight Android Studio 插件，这不是强制性的，但可以很容易地理解语法。建议安装插件。

## Android Code
## Android代码 

As I said earlier, we need to use `AndroidSqliteDriver` to write the data into the android database which persists across app launches. First, create the `AndroidSqliteDriver` instance as shown below:

如上文所述，需要用`AndroidSqliteDriver`把数据写进 Android 数据库，该数据库在 APP 启动期间存在。首先，创建 `AndroidSqliteDriver` ：

```
val androidSqlDriver = AndroidSqliteDriver(
    schema = Database.Schema,
    context = applicationContext,
    name = "movies.db"
)
```

Then we need to get hold of the queries that we’ve created inside movieitem.sql file. Have a look at the code:

接着，需要获取在 movieitem.sql 文件中创建的查询。代码如下：

```
val queries = Database(androidSqlDriver).movieItemQueries
```

Then we can directly execute all the functionalities that we created in our movieItem SQL file. Have a look at the code:

然后，直接执行 movieItem.sql 文件中的所有函数，代码如下 

```
val movies: List = queries.selectAll().executeAsList()
Log.d("MovieDatabase", "Movies : $movies")
```

## Coroutines Support
## 协程支持

One of the main reasons behind the success of the jetpack Room database library is that it’s easy to use and compatible ****with popular frameworks like coroutines, and paging.

jetpack Room 数据库库成功背后的主要原因之一是它易于使用，并与**协程**和**分页**等流行框架兼容。

SQL Delight also has that benefit; we only need to add the following line under the dependencies node inside the app level Gradle file to make it work.

SQL Delight 也有这个好处；我们只需要在应用级Gradle文件的依赖项节点下添加以下代码行就可以了：

```
implementation "com.squareup.sqldelight:coroutines-extensions-jvm:1.5.0"
```

Now it’s as simple as using coroutines with Room library. Here’s the code:

现在就像在 Room 库中使用协程一样简单。代码如下:

```
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asFlow()
    .mapToList()
```

If you’re still using RxJava, then you can add the following line to integrate Rxjava support to SQL Delight:

如果你还在使用 RxJava，那么你可以添加以下一行来集成RxJava支持到SQL Delight:

```
implementation "com.squareup.sqldelight:rxjava3-extensions:1.5.0"
```

Now to observe the query, we can use RxJava extensions artifact, as shown below:

现在来观察这个查询，我们可以使用 RxJava 扩展构件，如下所示:

```
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asObservable()
    .mapToList()
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
