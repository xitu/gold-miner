> * 原文地址：[Sharing databases between Laravel applications](https://dyrynda.com.au/blog/sharing-databases-between-laravel-applications)
> * 原文作者：[Michael Dyrynda](https://dyrynda.com.au/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sharing-databases-between-laravel-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sharing-databases-between-laravel-applications.md)
> * 译者：[Elliott Zhao](https://github.com/elliott-zhao)
> * 校对者：

# 在 Laravel 应用程序之间共享数据库

### 介绍

如果您碰巧在 [Twitter](https://twitter.com/michaeldyrynda) 上关注了我，您可能已经看到我发表了一些我正在做的日常工作。我们有一个面向客户的会员区和一个内部 CRM，它们工作在同一个主数据库上。

CRM 是在我为现在的老板打工之前建立起来的，而会员区是我在 2017 年初作为外包商建立的。会员区本身是一个新的 Laravel 应用程序，而 CRM 则是一个完全自定义编写的软件。


304/5000
作为外包商，我有一个数据库的不完整副本，并且我设法从数据库模式中反向工程 Eloquent 模型，创建[工厂](https://laravel.com/docs/5.6/database-testing#writing-factories)，以便能够为会员应用编写测试。

在 2017 年年底，我们开始将我们的 CRM 迁移到 Laravel，以便对代码库进行一些现代化改造，为其提供一个标准结构，并且可以轻松地对其进行更改。现在我们有两个 Laravel 应用程序，我们开始研究如何在它们之间共享数据。

### Eloquent 模型

数据库模型是最容易处理的部分。为此，我们使用 Composer 为每个共享数据库表创建模型创建一个包，并将它们作为 [vcs 存储库](https://getcomposer.org/doc/05-repositories.md#loading-a-package-from-a-vcs-repository)。这使我们能够无需通过Packagist发布就可以共享这些模型。

这个包中的模型每个都从它们自己的基础模型扩展而来，它为每个数据库设置连接，并包含可以将它们连接在一起的最少量的逻辑。

我们试着让包模型仅仅包含互相之间的关系，和一些通用的方法和行为。思路就是是，每个使用它们的应用程序都会根据需要扩展它们并实现它们自己的特定逻辑。

### 迁移

迁移是事情开始变得有点棘手的地方。虽然我们有一个技术上由 CRM 应用程序拥有的数据库，但迁移应该可用于任何将访问其中的数据的应用程序。那么问题就变成了：“哪个程序负责管理数据库模式？”

Laravel 在` `config/database.php` 文件中附带多个数据库连接，向您显示各种驱动的可用性。我们简单的定义几个都使用 `mysql` 驱动程序的连接。

我们对管理数据库模式有一些要求：

1.  使用数据库的任何一个应用程序不应负责管理迁移
2.  迁移应该能够用于测试
3.  如果可能，我们希望使用 Laravel 的迁移功能

前两个要求相当简单，假设我们可以通过某种方式解决第三个要求。

### 独立的实用程序

我花了很长时间把类似 Artisan 的工具集中在一起，这个工具只关注迁移和数据库填充功能 —— [Nomad](https://github.com/michaeldyrynda/nomad)。为了管理许多应用程序的数据库迁移，Nomad 可以被引入独立的 Composer 项目 - 例如 [Vagabond](https://github.com/michaeldyrynda/vagabond)。

Vagabond项目随后被作为一个包，您可以将其作为 VCS 存储库使用，并使用服务提供者，指导 Laravel 加载迁移，以及使用它的应用程序中可能存在的所有迁移。

```
// 在你的 Vagabond 项目的服务提供者中
public function boot()
{
    $this->loadMigrationsFrom(dirname(__FILE__).'/../database/migrations');
}
```

### Nomad 实战

我们在 Nomad 路径中遇到的第一个问题是，如果您没有在迁移文件中指定迁移应该运行的连接，它们将全部在您的默认连接上运行。

```
// 在您的迁移文件中
public function up()
{
    Schema::connection('the_connection')->create('table', function (Blueprint $table)
    {
        //
    }
}
```

第二个问题是，虽然 Laravel 应用程序会在正确的连接上运行迁移，但它会跟踪默认连接上的**所有**迁移，即如果您为三个不同的连接运行迁移，则迁移历史记录将全部在应用程序默认连接的 `migrations` 表。

为什么这是个问题？如果您的数据库用户具有足够的权限，它将尝试并在已存在这些表的数据库上反复运行相同的迁移。

如果您有许多不同的应用程序都使用集中式迁移文件，并且每次都尝试运行相同的迁移，则会出现此问题。

为了解决这个问题，我们在迁移项目的 `database/migrations` 文件夹中为每个连接的迁移创建了文件夹。

```
database/migrations/
                   /crm
                   /gis
                   /coverage
```

这样做，我们现在可以为各种迁移命令使用 `path` 和 `database`  参数，使我们能够显式运行每个连接的迁移： `php nomad migrate --database=gis --path=database/migrations/gis`。这确保只运行 `gis` 迁移，并且在 `gis` 数据库的 `migrations` 表中追踪运行迁移的历史记录。

这现在解决了要求1和3; 我们现在在一个的独立的数据库上使用 Laravel 式迁移,**并且**我们还拥有能够运行迁移的独立应用程序。这意味着我们可以在代码的任何地方运行运行针对特定数据库连接的迁移 a) 可以访问到数据库服务器，并且 b) 拥有具有足够权限的用户。

### 在测试中使用共享的迁移和模型

我们遇到的另一个问题是运行测试。

在我们的测试环境中，我们使用 Laravel 的  [`RefreshDatabase`](https://laravel.com/docs/5.6/database-testing#resetting-the-database-after-each-test) 特征，它可以智能地为每个测试建立并删除整个数据库。然而，在撰写本文时，虽然它正确运行所有迁移，**但它只会删除默认数据库连接上的表**。

这意味着如果我们对使用自己的数据库以及共享数据库的应用程序进行测试，则每次测试都将失败，因为 Laravel 会尝试运行未丢弃连接的迁移。对此，[Sepehr Lajevardi](https://twitter.com/sepehrlajevardi) 有一个[解决方案](https://github.com/laravel/framework/issues/21063#issuecomment-360616841)，[Keith Damiani](https://twitter.com/keithdamiani) 为我指出明路。

Sepehr 的建议中提及的的特性使用一个从待删表的连接数组中查找属性的方法覆盖 Laravel 的默认 `refreshTestDatabase` 方法。

### 数据库配置

现在你已经将自己的模型和迁移都打包到了自己的仓库中，这是最后一件你不想做的事情。从项目手动复制到另一个项目，就是配置本身。

Laravel 实际上很容易将第三方软件包的配置合并到主配置中。在我们的生产应用程序中，我们的数据库配置中**没有**配置任何连接。

相反，这个功能位于每个数据库连接的服务提供者内部。我们有一个顶级提供程序，每个提供程序都可以扩展，默认情况下，每个提供程序只需定义一个受保护的属性： `$connectionName`。

你可以在[这里](https://gist.github.com/michaeldyrynda/381024012249661a52fed7351c3e39a5)看到这个功能的独立样例。

您需要在应用程序中执行的操作是将服务提供程序添加到您的 `config/app.php` 文件的提供程序数组中，并为每个连接定义必要的环境变量。

### 持续集成

这个拼图给我们留下的最后一块是让测试在 CI 管道中运行。对我们来说，是 [BitBucket](https://bitbucket.org)。

由于我们现有的数据库包含很多 `ENUM` 字段（我不建议使用它们，尤其是因为它们不受这个库的支持 —— `doctrine/dbal` —— Laravel 用于迁移功能），我们必须在我们的测试环境中使用 MySQL。

在CI管道中使用容器可以轻松启动 MySQL 服务，但是，如何配置多个数据库却并不是显而易见的。由于我们使用的 MariaDB 映像不允许指定绑定的端口，因此多个数据库服务都尝试侦听同一个端口（3306），随后无法启动，从而导致测试套件失败。

解决方案非常简单，只是我之前没发现：在测试套件运行之前使用 MySQL 客户端创建数据库。

你的 `bitbucket-pipelines.yml` 文件应该如下所示：

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

`export` 这几行为我们的应用程序作用的三个数据库中的每个数据库进行配置。我们让 MariaDB 服务使用 `MYSQL_DATABASE` 环境变量配置第一个数据库，然后使用 MySQL 客户端创建 `second_db` 和 `third_db`。

> `MYSQL_ROOT_PASSWORD` 变量被定义为一个静态字符串，因为我没弄明白如何把随机密码注入部署步骤中，但是如果您知道如何做，请告诉我！

### 结论

如果您发现自己需要使用共享两个或更多数据库的应用程序，我希望您在本文中学到了有关管理和使用它们的知识。

涵盖如下内容：

*   打包模型和独立迁移 [Vagabond](https://github.com/michaeldyrynda/vagabond) project
*   利用 [Nomad](https://github.com/michaeldyrynda/nomad) 把迁移作为独立应用程序运行
*   在测试中处理多个数据库连接
*   使用 [BitBucket Pipelines](https://bitbucket.org/product/features/pipelines) 在多个数据库中成功运行测试


由于应用程序与数据库的分离，我们必须考虑的一个因素是迁移应该如何以及何时运行，因为我们现在需要将其作为单独的操作来完成。它当然会根据具体情况而有所不同，我们需要确保针对每个应用程序进行测试，以确保不会对数据库引入重大更改。

我花了几个月的时间才把它变成了工作状态，所以我希望在未来的某个时候，如果你遇到和我相似的情况，我能够为你节省一些时间！

感谢 [Keith Damiani](https://twitter.com/keithdamiani) 和 [Sepehr Lajevardi](https://twitter.com/sepehrlajevardi) 指出我拼图中缺失的最后一块。

[Jake Bennett](https://twitter.com/jacobbennett) 和我在North Meets South网络播客的 [episode 43](http://www.northmeetssouth.audio/43) 中讨论了这种迁移行为。


如果您对本文中涵盖的任何内容有任何疑问，或有任何改进建议，请随时在 Twitter 上[提出](https://twitter.com/michaeldyrynda)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
