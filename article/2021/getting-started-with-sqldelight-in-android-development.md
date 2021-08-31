> * 原文地址：[Getting Started With SQLDelight in Android Development](https://betterprogramming.pub/getting-started-with-sqldelight-in-android-development-eecd0ae9bbdd)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md](https://github.com/xitu/gold-miner/blob/master/article/2021/getting-started-with-sqldelight-in-android-development.md)
> * 译者：
> * 校对者：

# Getting Started With SQLDelight in Android Development

![Photo by [Boitumelo Phetla](https://unsplash.com/@writecodenow?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*VDd7zDjJaPiGuQbA)

## Introduction

SQLDelight is a cross-platform database library. It’s quite opposite to the traditional approach of ow annotation processes and reflections generate the code.

What makes it unique, even more than the fact that it supports cross-platform is that it takes SQL code and converts it into Kotlin/Java/Native code which supports different platforms like Android, iOS, web.

When it comes to traditional platform-specific libraries like Room database, they make it easy to create the database tables and operations because you’re writing code in the same language.

But when it comes to SQLDelight, you need to be able to write SQL queries by yourself. In my opinion, it’s both the strength and weakness of the library. I don’t prefer writing code other than Kotlin/Java as an Android developer, but on the other hand, it gives me the opportunity to support multiple platforms.

To be frank, when you’re developing a mobile app, you won’t need that much in-depth knowledge regarding SQL, basic coding, and syntactical knowledge to make it work.

So, without any delay, let’s get started:

## Integration

Add the SQLDelight plugin in the project level Gradle file, as shown below:

```Gradle
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    ext.kotlin_version = "1.4.32"
    repositories {
        google()
        jcenter()
        // SQL Delight support repositories
        mavenCentral()
        maven { url 'https://www.jetbrains.com/intellij-repository/releases' }
        maven { url "https://jetbrains.bintray.com/intellij-third-party-dependencies" }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:4.1.3"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // SQL Delight plugin
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

The process of generating platform-specific code works because, in the end, you’re executing SQL queries. This is somewhat the same behavior when compared to platform-specific libraries like the Room database. Have a look at the following code:

```
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.squareup.sqldelight'
}
```

Until now we’ve integrated generic SQL Delight support, now we need to add the Android support library. `AndroidSqliteDriver` is what we need here. We need to add the following line under dependencies node in-app level Gradle file:

```
implementation "com.squareup.sqldelight:android-driver:1.3.0"
```

## Write the SQL Code

As a first to create the database, we should write the SQL code. The question is where should locate the (*.sq) files. We need to create a separate directory with the name `sqldelight` under the main directory, similar to java and Kotlin, and host all our (*.sq) files inside it.

```
src/main/sqldelight
```

Now without any further delay, let’s create our MovieItem.sql file. Add the following code inside the file:

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

## Android Code

As I said earlier, we need to use `AndroidSqliteDriver` to write the data into the android database which persists across app launches. First, create the `AndroidSqliteDriver` instance as shown below:

```
val androidSqlDriver = AndroidSqliteDriver(
    schema = Database.Schema,
    context = applicationContext,
    name = "movies.db"
)
```

Then we need to get hold of the queries that we’ve created inside movieitem.sql file. Have a look at the code:

```
val queries = Database(androidSqlDriver).movieItemQueries
```

Then we can directly execute all the functionalities that we created in our movieItem SQL file. Have a look at the code:

```
val movies: List = queries.selectAll().executeAsList()
Log.d("MovieDatabase", "Movies : $movies")
```

## Coroutines Support

One of the main reasons behind the success of the jetpack Room database library is that it’s easy to use and compatible ****with popular frameworks like coroutines, and paging.

SQL Delight also has that benefit; we only need to add the following line under the dependencies node inside the app level Gradle file to make it work.

```
implementation "com.squareup.sqldelight:coroutines-extensions-jvm:1.5.0"
```

Now it’s as simple as using coroutines with Room library. Here’s the code:

```
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asFlow()
    .mapToList()
```

If you’re still using RxJava, then you can add the following line to integrate Rxjava support to SQL Delight:

```
implementation "com.squareup.sqldelight:rxjava3-extensions:1.5.0"
```

Now to observe the query, we can use RxJava extensions artifact, as shown below:

```
val players: Flow<List<MoveItem>> = 
  queries.selectAll()
    .asObservable()
    .mapToList()
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
