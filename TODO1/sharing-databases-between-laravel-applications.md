> * 原文地址：[Sharing databases between Laravel applications](https://dyrynda.com.au/blog/sharing-databases-between-laravel-applications)
> * 原文作者：[Michael Dyrynda](https://dyrynda.com.au/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sharing-databases-between-laravel-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sharing-databases-between-laravel-applications.md)
> * 译者：
> * 校对者：

# Sharing databases between Laravel applications

### Introduction

If you happen to follow me on [Twitter](https://twitter.com/michaeldyrynda), you may have seen me tweeting about some of the work I'm doing in my day job. We have a customer-facing members area and an internal CRM that both work with the same main database.

The CRM was built before I started working at my now-employer, whilst the members area was built by me as a contractor in the early part of 2017\. The members area itself was a fresh Laravel application, whilst the CRM is a totally custom-written piece of software.

As a contractor, I had a sanitised copy of the database, and I managed to reverse engineer the Eloquent models from the database schema, creating [factories](https://laravel.com/docs/5.6/database-testing#writing-factories) along the way, in order to be able to write tests for the members application.

In late 2017, we started migrating our CRM to Laravel as well, in order to modernise the code base a bit, give it a standard structure, and make it easy to make changes to it moving forward. Now that we had two Laravel applications, we started looking at how best to share data between them.

### Eloquent models

Database models are the easiest part to deal with. For this, we simply created models for each of the shared database tables, created a package, and pulled them into our apps as a [vcs repository](https://getcomposer.org/doc/05-repositories.md#loading-a-package-from-a-vcs-repository) with Composer. This allowed us to share the models, without exposing them publicly via Packagist.

The models in this package each extend from their own base model, which sets the connection per database, and contain the minimal amount of logic to tie them all together.

We try and keep the package models to just the relationships between each other, and any generic methods or behaviours; the idea being that each application using them would then extend from them and implement their own specific logic as needed.

### Migrations

Migrations are where things start getting a little bit tricky. Whilst we have a database that is technically owned by the CRM application, the migrations should be available to any application that will access the data in it. The question then became, "which application is responsible for managing the database schema?"

Laravel ships with multiple database connections in the `config/database.php` file, showing you the availability of various drivers. We simply define multiple connections that all use the `mysql` driver.

We had a few requirements for managing the database schema:

1.  No single application using the databases should be responsible for managing migrations
2.  The migrations should be able to be used for testing purposes
3.  We would like to use Laravel's migration functionality, if possible

The first two requirements are fairly straightforward, assuming we could solve the third in some way.

### A standalone utility

I spent quite some time putting together an Artisan-like utility that focuses solely on the migration and database seeding functionality - [Nomad](https://github.com/michaeldyrynda/nomad). Nomad can be pulled into a standalone Composer project - such as [Vagabond](https://github.com/michaeldyrynda/vagabond), in order to manage database migrations for many applications.

The Vagabond project is subsequently used as a package that you can pull into your applications - as a VCS repository - and using a service provider, instruct Laravel to load its migrations, in addition to any migrations that might exist in the application that uses it.

```
// In your Vagabond project's service provider
public function boot()
{
    $this->loadMigrationsFrom(dirname(__FILE__).'/../database/migrations');
}
```

### Nomad in practice

The first problem we encountered with the Nomad approach, was that if you don't specify the connection migrations ought to run against in your migration files, they will all run against your default connection.

```
// In your migration file
public function up()
{
    Schema::connection('the_connection')->create('table', function (Blueprint $table)
    {
        //
    }
}
```

The second problem, was that although the Laravel application would run the migrations against the correct connection, it would track _all_ of the migrations against the default connection i.e. if you ran migrations for three different connections, they resulting migration history would all be tracked in the `migrations` table of your application's default connection.

Why is this a problem? If your database user had sufficient privileges, it would try and run the same migrations over and over on a database where those tables already existed.

This issue is compounded if you have many different applications all using the centralised migration files, trying to run the same migrations each time.

In order to solve this problem, we created folders for each connection's migrations within the migration project's `database/migrations` folder.

```
database/migrations/
                   /crm
                   /gis
                   /coverage
```

In doing so, we could now use the `path` and `database` arguments for various migration commands, allowing us to explicitly run migrations per-connection: `php nomad migrate --database=gis --path=database/migrations/gis`. This ensured that only the `gis` migrations were run, and that the history for the run migrations was tracked in the `gis` database's `migrations` table.

This now solved requirements 1 and 3; we were now using Laravel-style migrations from a standalone repository _and_ we had a standalone application capable of running the migrations. This means we can run migrations for a specific database connection anywhere the code a) had access to the database server and b) had a user with sufficient privileges.

### Using the shared migrations and models in testing

Another problem we encountered along the way was in running tests.

In our test environment, we use Laravel's [`RefreshDatabase`](https://laravel.com/docs/5.6/database-testing#resetting-the-database-after-each-test) trait, which intelligently handles building up and tearing down your entire database for each test. At the time of writing, however, whilst it runs all of the migrations correctly, _it only drops tables on the default database connection_.

This means if we have tests for an application using its own database as well as one of the shared ones, each test will fail as Laravel tries to run the migrations for a connection that was not dropped. There is a [solution](https://github.com/laravel/framework/issues/21063#issuecomment-360616841) to this problem by [Sepehr Lajevardi](https://twitter.com/sepehrlajevardi), which was pointed out to me by [Keith Damiani](https://twitter.com/keithdamiani).

The trait in Sepehr's suggestion overwrites Laravel's default `refreshTestDatabase` method with one that looks for a property containing an array of connections to drop tables from.

### Database configuration

Now that you have your models and migrations all packaged up in their own repository, the last thing you don't want to have to. manually duplicate from project to project is the configuration itself.

Laravel actually makes it pretty easy to merge configurations from third-party packages into the main configuration. In our production application, our database configuration has absolutely _no_ connections configured in it.

Instead, this functionality lives inside each database connection's service provider. We have a top-level provider that each extends from, and by default each provider need only define a single protected property; `$connectionName`.

You can see a standalone sample of this functionality [here](https://gist.github.com/michaeldyrynda/381024012249661a52fed7351c3e39a5).

All you need to do in your application is add the service provider to your `config/app.php` file's providers array and define the necessary environment variables for each connection.

### Continuous Integration

The very last piece of this puzzle for us is to have the tests running in a CI-pipeline. For us, this is [BitBucket](https://bitbucket.org).

As our existing database contains a lot of `ENUM` fields (I don't recommend using them, not least of all because they are not supported by the library - `doctrine/dbal` - that Laravel uses for its migration functionality), we had to use MySQL in our test environment.

Using containers in our CI pipeline makes it easy spin up a MySQL service, however, it is not immediately obvious how you would configure multiple databases. As the MariaDB image we're using doesn't let you specify the port it binds to, multiple database services all try to listen on the same port (3306) and subsequently fail to start, causing the test suite to fail.

The solution is so simple that it was overlooked initially; use the MySQL client to create the databases before the test suite runs.

Your `bitbucket-pipelines.yml` file ought to look like the following:

```
image: php:7.1.15

pipelines:
  default:
    - step:
        deployment: test
        caches:
          - composer
        script:
          - apt-get update && apt-get install -y unzip git mysql-client
          - docker-php-ext-install pdo_mysql
          - curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
          - cp -n .env.example .env
          - export DB_USERNAME=root
          - export DB_DATABASE=first_db
          - export DB_PASSWORD=supersecret
          - export DB_SECOND_USERNAME=root
          - export DB_SECOND_DATABASE=second_db
          - export DB_SECOND_PASSWORD=supersecret
          - export DB_THIRD_USERNAME=root
          - export DB_THIRD_DATABASE=third_db
          - export DB_THIRD_PASSWORD=supersecret
          - composer install
          - php artisan key:generate
          - mysql -uroot -psupersecret -h127.0.0.1 -e 'create database second_db; create database third_db;'
          - vendor/bin/phpunit --colors=always -c phpunit.xml
        services:
          - mariadb
definitions:
  services:
    mariadb:
      image: mariadb:5.5
      environment:
        MYSQL_DATABASE: 'first_db'
        MYSQL_ROOT_PASSWORD: 'supersecret'
```

The `export` lines set the database configuration for each of the three databases that our app interacts with. We let the MariaDB service configure the first database using the `MYSQL_DATABASE` environment variable, then use the MySQL client to create `second_db` and `third_db`.

> The `MYSQL_ROOT_PASSWORD` variable is defined as a static string as I couldn't figure out how to get a random password injected into the deploy step, but if you know how to do so let me know!

### Conclusion

If you ever find yourself needing to work with applications that share two or more databases, I hope you've learnt something about managing and working with them in this post.

A lot has been covered:

*   packaging models and migrations in a standalone [Vagabond](https://github.com/michaeldyrynda/vagabond) project
*   running migrations as a standalone application with [Nomad](https://github.com/michaeldyrynda/nomad)
*   dealing with multiple database connections in tests
*   successfully running your tests using [BitBucket Pipelines](https://bitbucket.org/product/features/pipelines) with multiple databases

One consideration we'll have to make as a result of this decoupling of application from database, is how and when migrations should be run, given we'll need to now do this as a separate operation. It will, of course vary on a case by case basis, and we'll need to be sure to test against each application to ensure no breaking changes were introduced to the database.

It took me a couple of months to get this to a working state, so I hope that I'm able to save you some time should you find yourself in my shoes at some point in the future!

Thanks to [Keith Damiani](https://twitter.com/keithdamiani) and [Sepehr Lajevardi](https://twitter.com/sepehrlajevardi) for pointing out one of my last missing puzzle pieces,

[Jake Bennett](https://twitter.com/jacobbennett) and I discussed this migration behaviour in [episode 43](http://www.northmeetssouth.audio/43) of the North Meets South web podcast.

If you have any questions about anything covered in this post, or suggestions for improvement, feel free to [reach out](https://twitter.com/michaeldyrynda) on Twitter.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
