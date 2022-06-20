> * 原文地址：[Getting Started With SQLDelight in Android Development](https://betterprogramming.pub/getting-started-with-sqldelight-in-android-development-eecd0ae9bbdd)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md](https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md)
> * 译者：[airfri](https://github.com/airfri)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[greycodee](https://github.com/greycodee)、[haiyang-tju](https://github.com/haiyang-tju)

# Android 开发中的 SQLDelight 入门

![图片由 [Boitumelo Phetla](https://unsplash.com/@writecodenow?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*VDd7zDjJaPiGuQbA)

## 简介

SQLDelight 是一个跨平台的数据库，它与传统的注释处理和反射生成代码的方式完全相反。

比起支持跨平台这一特点，SQLDelight 有一个更为重要的特点：它能够将 SQL 代码转换为 Kotlin、Java 或者原生代码，从而支持 Android、iOS、Web 等不同的平台。

就算使用诸如 Room 数据库之类的传统的、平台特定的库，也可以仅用 SQL 这一门语言轻松地创建数据库表和操作。

SQLDelight 需要开发者能自己编写 SQL 查询，这既是 SQLDelight 的优势也是它的劣势。作为一名 Android 开发人员，我不喜欢编写除了 Kotlin/Java 以外的代码，但另一方面，它给了我支持跨平台的机会。

但是说实话，开发者开发一个移动端应用程序时，就算对 SQL 的基础编程方法和语法了解地不深入，也可以写出 SQL 代码并运行编译。

所以还在等什么，让我们开始吧。

## 集成

把 SQLDelight 插件添加到项目级 Gradle 文件中，如下面的代码所示：

```groovy
// 顶级构建文件，可以在其中添加所有子项目/模块的通用配置选项。
buildscript {
    ext.kotlin_version = "1.4.32"
    repositories {
        google()
        jcenter()
        // SQLDelight 支持存储库
        mavenCentral()
        maven { url 'https://www.jetbrains.com/intellij-repository/releases' }
        maven { url "https://jetbrains.bintray.com/intellij-third-party-dependencies" }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:4.1.3"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
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

第二步，需要在应用级 Gradle 文件上应用 SQLDelight 插件来支持代码生成。 SQLDelight 不会基于 `kapt` 这样的注释处理器来生成代码。

生成特定平台的代码的过程之所以有效，是因为最终执行的都是 SQL 查询，在某种程度上，这与 Room 数据库等平台特定库是相似的。看看下面的代码：

```groovy
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.squareup.sqldelight'
}
```

上面的操作已经集成了通用的 SQLDelight 支持，现在需要添加 Android 支持库 —— `AndroidSqliteDriver` ，在依赖项节点应用程序级 Gradle 文件下添加以下代码：

```groovy
implementation "com.squareup.sqldelight:android-driver:1.3.0"
```

## 编写 SQL 代码

写 SQL 代码来创建数据库，首先应该定位 `*.sq` 文件。在 `main` 目录下创建一个名为 `sqldelight` 的单独目录（类似于 Java 和 Kotlin 代码的文件夹），并将所有的 `*.sq` 文件存放其中。

```
src/main/sqldelight
```

紧接着，创建 `MovieItem.sql` 文件，然后把下面的代码添加到该文件中：

```sql
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
INSERT OR REPLACE INTO moveItem (
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

添加了上述代码后，将会弹出提示安装 SQLDelight Android Studio 插件。这不是强制性的，但它可以让你更容易理解 SQL 语法。我建议安装该插件。

## Android 代码

如上文所述，我们需要用 `AndroidSqliteDriver` 把数据写进 Android 数据库，该数据库在应用程序启动期间持续存在。首先，创建 `AndroidSqliteDriver` 实例：

```kotlin
val androidSqlDriver = AndroidSqliteDriver(
    schema = Database.Schema,
    context = applicationContext,
    name = "movies.db"
)
```

接着，需要获取在 `MovieItem.sql` 文件中创建的查询语句。代码如下：

```kotlin
val queries = Database(androidSqlDriver).movieItemQueries
```

然后，直接执行 `MovieItem.sql` 文件中的 `selectAll` 函数，代码如下：

```kotlin
val movies: List = queries.selectAll().executeAsList()
Log.d("MovieDatabase", "Movies : $movies")
```

## 协程支持

Room 库成功背后的主要原因之一是它易于使用，而且与 `coroutines` 和 `paging` 等流行框架相兼容。

SQLDelight 也有这个好处；我们只需要在应用程序级别的 Gradle 文件的 `dependencies` 节点下添加以下这行代码就可以了：

```groovy
implementation "com.squareup.sqldelight:coroutines-extensions-jvm:1.5.0"
```

现在就像在 Room 库中使用协程一样简单。代码如下:

```kotlin
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asFlow()
    .mapToList()
```

如果你仍在使用 RxJava，那么你可以添加下面这行代码，以便将 RxJava 支持集成到 SQLDelight 中：

```groovy
implementation "com.squareup.sqldelight:rxjava3-extensions:1.5.0"
```

现在来观察这个查询，我们可以使用 RxJava 扩展构件，如下所示：

```kotlin
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asObservable()
    .mapToList()
```

这就是目前的全部内容，希望你能有所收获。

感谢阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
