> * 原文地址：[The Definitive PHP 5.6, 7.0, 7.1, 7.2 & HHVM Benchmarks (2018)](https://kinsta.com/blog/php-7-hhvm-benchmarks/)
> * 原文作者：[Mark Gavalda](https://kinsta.com/blog/author/kinstadmin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/php-7-hhvm-benchmarks.md](https://github.com/xitu/gold-miner/blob/master/TODO/php-7-hhvm-benchmarks.md)
> * 译者：[AlbertHao](https://github.com/Albertao)
> * 校对者：[foxxnuaa](https://github.com/foxxnuaa) [allenlongbaobao](https://github.com/allenlongbaobao)

# 这可能是 2018 年最好的一篇 PHP 性能测评（包含 5.6 到 7.2，以及 HHVM）

![](https://kinsta.com/wp-content/uploads/2018/02/php-7-hhvm-benchmarks-1.png)

每年我们都会在大量不同的平台上尝试并深入研究 PHP 不同版本以及 HHVM 在性能方面的差异。而今年，我们一鼓作气在 20 个不同的平台/配置下评测了四个不同版本的 PHP 引擎以及 HHVM，测评使用的应用包括了 WordPress，Drupal，Joomla!，Laravel，Symfony以及其他各种各样的应用。此外，我们也测试了近些年流行的一些电子商务解决方案如 WooCommerce，Easy Digital Downloads，Magento，和 PrestaShop。

想看这篇文章的西班牙语版本吗？[我是传送门](https://kinsta.com/es/blog/php-7-hhvm-rendimiento/)

我们鼓励 WordPress 用户使用 PHP 的[最新支持版本](https://kinsta.com/blog/php-versions/)，除了更好的安全性外，它们还提供了额外的性能提升。我们并不只是在谈论 WordPress，这个结论对于大部分的平台也是适用的。今天我们将向你展示 **PHP7.2 是如何打败它面对的一切敌人的！🚀**

今年的测评结果相比起我们以前那些 HHVM 获胜的测评发生了大大的改变。我们很高兴能看到 PHP7.2 成为目前速度最快的 PHP 引擎。关于 WordPress，有一个需要提及的重要事情，那就是 [HHVM 不再被支持]((https://make.wordpress.org/core/2017/05/25/hhvm-no-longer-part-of-wordpress-cores-testing-infrastructure/))并将会渐渐地淡出历史舞台，我们不再鼓励我们的顾客迁移到 HHVM ，同时也声明在大量不同的平台上支持它并不是一个好的选择。

对于开发者和终端用户来说这都是一个好消息，因为这意味着我们将更多地关注 PHP，并为每个人都提供更快的网站和 web 服务。

## PHP 和 HHVM 测评（2018）

对于每个测试，我们都使用了每个平台系统的最新版本并在 15 个并发用户的条件下对主页跑了1分钟的测试，下面是我们测试环境的具体细节。

*   **使用机器：** 8核 Intel(R) Xeon(R) CPU @ 2.20GHz (由 [Google Cloud Platform](https://kinsta.com/blog/google-cloud-hosting/) 提供并运行于一个隔离的容器中)
*   **操作系统:** Ubuntu 16.04.3 LTS
*   **Docker 栈:** Debian 8, Nginx 1.13.8, MariaDB 10.1.31
*   **PHP 引擎版本:** 5.6, 7.0, 7.1, 7.2
*   **HHVM版本:** 3.24.2
*   **OPCache:** 对于 WordPress， Joomla，和 Drupal，我们使用了官方的 Docker 镜像。对于其他的评测应用，我们使用了与 OPcache 相同的镜像配置。OPcache 应用了如下的 [php.ini 推荐设置](https://secure.php.net/manual/en/opcache.installation.php)。 

```
opcache.memory_consumption=128

opcache.interned_strings_buffer=8

opcache.max_accelerated_files=4000

opcache.revalidate_freq=60

opcache.fast_shutdown=1

opcache.enable_cli=1

```

测试由 [Thoriq Firdaus](https://twitter.com/tfirdaus) 执行，他是一位 WordPress 代码贡献者以及工作于 Kinsta 的服务支持工程师。他曾经为 WordPress 的核心部分和 [WordPress Indonesia 的翻译编辑器](https://translate.wordpress.org/locale/id/default/wp/dev)贡献过代码。

### 什么是 PHP？

PHP 的全称是超文本预处理器（Hypertext Preprocessor）。它是目前 web 界最流行的脚本语言之一。根据 W3Techs 的调查结果，[超过 83% 的网站](https://w3techs.com/technologies/details/pl-php/all/all)使用 PHP 作为它们的服务器端编程语言。

### 什么是 HHVM？

由于 PHP 的性能问题，Facebook 开发了 HipHop Virtual Machine（[HHVM](https://hhvm.com/)）。它使用即时编译（JIT）技术来将 PHP 代码转换为机器语言，从而在 PHP 代码和驱动代码的底层硬件之间建立协同关系。

### 测试的平台和配置

我们的测试涵盖了如下 20 个平台/配置。在一些平台上，因为缺少某些特殊 PHP 版本的支持，我们需要测试该平台多个版本的表现。点击下面任意一个链接你可以直接跳转到该平台的测试信息以及结果。数据以每秒的请求量进行衡量。这个数值越大越好。

*   [WordPress 4.9.4](#wordpress-benchmarks)
*   [WordPress 4.9.4 + WooCommerce 3.3.1](#wordpress-woocommerce-benchmarks)
*   [WordPress 4.94 + Easy Digital Downloads 2.8.18](#wordpress-edd-benchmarks)
*   [Drupal 8.4.4](#drupal-benchmarks)
*   [Joomla! 3.8.5](#joomla!-benchmarks)
*   [Magento 2 (CE) 2.1.11 + 2.2.2](#magento-benchmarks)
*   [Grav CMS 1.3.10](#gravcms-benchmarks)
*   [October CMS 1.0.433](#octobercms-benchmarks)
*   [Laravel 5.4.36 + 5.6](#laravel-benchmarks)
*   [Symfony 3.3.6 + 4.0.1](#symfony-benchmarks)
*   [PyroCMS 3.4.14](#pyrocms-benchmarks)
*   [Pagekit 1.0.13](#pagekit-benchmarks)
*   [Bolt CMS 3.4.8](#boltcms-benchmarks)
*   [AnchorCMS 0.12.6 (pre-release)](#anchorcms-benchmarks)
*   [PrestaShop 1.7.2.4](#prestashop-benchmarks)
*   [CraftCMS 2.6.3011](#craftcms-benchmarks)
*   [ForkCMS 5.2.2](#forkcms-benchmarks)

## WordPress 4.9.4

我们测试的第一个平台，理所当然应该是我们最喜欢的其中之一：[WordPress](https://wordpress.org/)（我们可能偏向于认为我们每天都在使用使用这个 CMS 系统 😉）。从它的核心来看，WordPress 是一个你能用来建立精美的网站，博客或者 App 的开源软件。事实上，WordPress 驱动了互联网上[超过 29% 的网站](https://kinsta.com/wordpress-market-share/)。是的，没错 — 你访问的每四个网站中就可能有超过一个是由 WordPress 驱动的。

![WordPress CMS](https://kinsta.com/wp-content/uploads/2018/02/wordpress-cms.png)

对于 WordPress 的测评，我们选择了免费的 [Twenty Seventeen 主题](https://kinsta.com/blog/twenty-seventeen-theme/)。并使用了由 wptest.io 生成的测试内容，通过 15 个并发用户对主页的访问测试了1分钟。

*   文章数目：由 wptest.io 生成，10 篇/页
*   『搜索』是侧边栏唯一的菜单项目
*   Docker 镜像派生自 [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-php-benchmarks.png)

WordPress 测试

#### 测试结果

*   WordPress 4.9.4 PHP 5.6 测试结果: 49.18 req/sec
*   WordPress 4.9.4 PHP 7.0 测试结果: 133.55 req/sec
*   WordPress 4.9.4 PHP 7.1 测试结果: 134.24 req/sec
*   WordPress 4.9.4 **PHP 7.2 测试结果**: **148.80 req/sec 🏆**
*   WordPress 4.9.4 HHVM 测试结果: 144.76 req/sec

PHP 7.2 成为了赢家，证明其比 HHVM 略快。这与 2016 年的基准相比有显著的变化，因为在 2016 年，HHVM 显然是赢家。WordPress 的 PHP 也更加稳定。在使用 HHVM 的过程中，我们亲身经历了很多问题。

## WordPress 4.9.4 + WooCommerce 3.3.1

[WooCommerce](https://woocommerce.com/) 是一个支持高度自定义，使用 WordPress 搭建的开源电子商务平台。它也是到目前为止，最流行的电子商务解决方案之一，驱动了互联网上超过 [42% 的电子商务网站](https://kinsta.com/wordpress-market-share/#woocommerce)。

![WooCommerce](https://kinsta.com/wp-content/uploads/2018/02/woocommerce.png)

对于接下来的这个测试，我们选择了将 WordPress 与 WooCommerce 一起安装。并选择了免费的 [Storefront eCommerce 主题](https://woocommerce.com/storefront/).

*   商品数目: 8 (每行两件商品)
*   将购物页面设置为首页
*   Docker 镜像派生自 [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress + WooCommerce benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-woocommerce-php-benchmarks.png)

WordPress + WooCommerce 测试

#### 测试结果

*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 5.6 测试结果: 34.47 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 7.0 测试结果: 84.89 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 7.1 测试结果: 86.04 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 **PHP 7.2 测试结果:** **92.60 req/sec 🏆**
*   WordPress 4.9.4 + WooCommerce 3.3.1 HHVM 测试结果: 69.58 req/sec

WooCommerce 在使用 HHVM 的过程中遇到了一些小问题，而 PHP 7.2 以微弱优势打败了 PHP 7.1。

## WordPress 4.9.4 + Easy Digital Downloads 2.8.18

[Easy Digital Downloads](https://easydigitaldownloads.com/) (EDD)，这是一款由 Pippin Williamson 编写的，专注于帮助使用者和开发者售卖电子商品的免费的 WordPress 电子商务插件。

![Easy Digital Downloads](https://kinsta.com/wp-content/uploads/2018/02/easy-digital-downloads.png)

在了解清楚 WooCommerce 是怎么运作的之后，我们采用了 WordPress 和 Easy Digital Downloads 一起安装的方式。并使用了免费的 [EDD Starter 主题](https://easydigitaldownloads.com/downloads/edd-starter-theme/)。

*   商品数目: 6 (从插件中获取的默认商品样例)
*   缺失的商品列表上有 2 张图片
*   Docker 镜像派生自 [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress + Easy Digital Downloads benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-edd-php-benchmarks.png)

WordPress + Easy Digital Downloads 测试

#### 测试结果

*   WordPress 4.9.4 + EDD 2.8.18 PHP 5.6 测试结果: 76.71 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 PHP 7.0 测试结果: 123.83 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 PHP 7.1 测试结果: 124.82 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 **PHP 7.2 测试结果:** **135.74 req/sec 🏆**
*   WordPress 4.9.4 + EDD 2.8.18 HHVM 测试结果: 127.74 req/sec

PHP 7.2 在 WordPress 和 Easy Digital Downloads 的测试中，毫无疑问地占据了主导地位。

### Drupal 8.4.4

[Drupal](https://www.drupal.org/) 是一款开源的 CMS，它以模块化的系统和强大的开发者社区而流行。它最初于 2000 年上线，根据 W3Techs 的数据，它支持了互联网上 2.2% 的网站，占据了 CMS 市场 4.4% 的份额。

![Drupal](https://kinsta.com/wp-content/uploads/2018/02/drupal-logo.png)

对于 Drupal 的测评，我们使用了免费的 [Bartik 8.4.4 主题](https://github.com/pantheon-systems/drops-8/tree/master/core/themes/bartik)。值得注意的一点是 **Drupal 8.4.x 并不兼容 PHP 7.2** ([#2932574](https://www.drupal.org/project/drupal/issues/2932574))， 因此本次测试中并没有加入这个版本的 PHP 引擎。

*   文章数目: 通过 Devel 模块生成了 10 篇
*   关闭了页缓存: [https://www.drupal.org/node/2598914](https://www.drupal.org/node/2598914)
*   Docker 镜像派生自 [https://hub.docker.com/_/drupal/](https://hub.docker.com/_/drupal/)

![Drupal benchmarks](https://kinsta.com/wp-content/uploads/2018/02/drupal-benchmarks.png)

Drupal 测试

#### 测试结果

*   Drupal 8.4.4 PHP 5.6 测试结果: 7.05 req/sec
*   Drupal 8.4.4 PHP 7.0 测试结果: 15.94 req/sec
*   Drupal 8.4.4 PHP 7.1 测试结果: 19.15 req/sec
*   Drupal 8.4.4 PHP 7.2 测试结果: (不支持的版本)
*   Drupal 8.4.4 **HHVM 测试结果: 19.57 req/sec 🏆**

因为 Drupal 的最新版本并不支持 PHP 7.2，HHVM 获得了最高的得分。然而回顾前几个 PHP 版本的性能提升，我们依然能够稳定推测出 PHP 7.2 可能会更加地快。

### Joomla! 3.8.5

[Joomla!](https://www.joomla.org/) 是一款用于发布 web 内容的免费开源 CMS 软件，最初发布于 2005 年 8 月 17 日。它是基于一个 MVC web 应用框架搭建的。根据 W3Techs 的数据，互联网上 [3.1% 的网站](https://w3techs.com/technologies/details/cm-joomla/all/all) 都使用了它。

![Joomla!](https://kinsta.com/wp-content/uploads/2018/02/joomla-logo-e1519705676991.png)

对于 Joomla! 的测试，我们使用了免费的 [Beez3 模板](http://a4joomla.com/joomla-templates/countryside-free/using-joomla/extensions/templates/beez3.html)。

*   文章数目: 4 (在安装过程中添加的 Joomla 默认样例文章)
*   关闭默认侧边栏
*   Docker 镜像派生自 [https://hub.docker.com/_/joomla/](https://hub.docker.com/_/joomla/)

![Joomla! benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Joomla-benchmarks-1.png)

Joomla! 测试

#### 测试结果

*   Joomla! 3.8.5 PHP 5.6 测试结果: 26.42 req/sec
*   Joomla! 3.8.5 PHP 7.0 测试结果: 41.46 req/sec
*   Joomla! 3.8.5 PHP 7.1 测试结果: 41.17 req/sec
*   Joomla! 3.8.5 PHP 7.2 测试结果: 42.36 req/sec
*   Joomla! 3.8.5 **HHVM 测试结果: 51.84 req/sec 🏆**

在 Joomla! 的测试中，我们可以看到 PHP 的每个版本都有一个稳定的提升，但是 HHVM 依然成为了第一。

### Magento 2 (CE) 2.1.11 + 2.2.2

[Magento](https://magento.com/) 是一款使用 PHP 编写的流行的开源电子商务平台，最初发布于 2008 年 3 月 31 日。根据 W3Techs的数据，它驱动了互联网上 [1.2% 的站点](https://w3techs.com/technologies/details/cm-magento/all/all)。

![Magento](https://kinsta.com/wp-content/uploads/2018/02/magento.png)

对于 Magento 2 的测试，我们使用了免费的 [Luma 主题](http://magento2-demo.nexcess.net/)。我们采用了两个版本，因为 2.1.11 是唯一一个支持 PHP 5.6的版本。我们使用了样例数据和它自带的默认主题进行安装。对于额外的测试，我们使用了 2.2.2版本。**Magento 2 目前为止还不支持 PHP 7.2** 或者 HHVM 的最新版本。

*   商品数目: 7
*   [http://pubfiles.nexcess.net/magento/ce-packages/](http://pubfiles.nexcess.net/magento/ce-packages/)

![Magento 2 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/magento-2-benchmarks-1.png)

Magento 2 测试

#### 测试结果

*   Magento 2 (CE) 2.1.11 PHP 5.6 测试结果: 10.75 req/sec
*   Magento 2 (CE) 2.1.11 PHP 7.0 测试结果: 20.87 req/sec
*   Magento 2 (CE) 2.1.11 **PHP 7.1 测试结果: 29.84 req/sec 🏆**
*   Magento 2 (CE) 2.1.11 PHP 7.2 测试结果: not supported
*   Magento 2 (CE) 2.1.11 HHVM 测试结果: not supported

因为 Magento 2 并不支持 PHP 7.2 和最新版本的 HHVM，PHP 7.1 成为了显然的赢家。而 PHP 每个版本之间一致的性能收益提升也让我们印象深刻。

### Grav CMS 1.3.10

[Grav](https://getgrav.org/) 是一款使用简便，又强大且不需要数据库的开源 CMS 软件。某些时候这也被称作是一种 flat-file CMS（译者注：关于 flat-file 的解释可见[这里](https://baike.baidu.com/item/flat%20file)）。

![Grav CMS](https://kinsta.com/wp-content/uploads/2018/02/grav-cms.png)

对于 Grav CMS 的测试，我们使用了免费的 [Clean Blog 脚手架](https://getgrav.org/downloads/skeletons)。需要注意的是 **Grav CMS 不再支持 HHVM **编译器并已经从他们的 Travis 构建中 [移除了 HHVM 环境](https://github.com/getgrav/grav/commit/abccf2278dac637089fb5b20b6386d88905335c5)。

*   文章数目: 4 (「Clean Blog」脚手架中的预设文章)
*   页/文件缓存已关闭: [https://learn.getgrav.org/advanced/performance-and-caching](https://learn.getgrav.org/advanced/performance-and-caching)，而 Twig 缓存依然是开启的。

![Grav CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/grav-cms-benchmarks-1.png)

Grav CMS 测试

#### 测试结果

*   Grav CMS 1.3.10 PHP 5.6 测试结果: 34.83 req/sec
*   Grav CMS 1.3.10 PHP 7.0 测试结果: 53.37 req/sec
*   Grav CMS 1.3.10 PHP 7.1 测试结果: 53.37 req/sec
*   Grav CMS 1.3.10 **PHP 7.2 测试结果: 55.12 req/sec 🏆**
*   Grav CMS 1.3.10 HHVM 测试结果: 不支持

我们可以在 Grav CMS 的测试中再一次看到最新版本的 PHP (7.2) 成为了显然的赢家。

### October CMS 1.0.433

[October CMS](https://octobercms.com/) 是一款免费开源，自托管且模块化的基于 Laravel PHP 框架的 CMS 平台。它最初发布于 2014 年 5 月 15 日。

![October CMS](https://kinsta.com/wp-content/uploads/2018/02/october-cms.png)

对于 October CMS 的测试，我们使用了免费的 [Clean Blog 主题](https://octobercms.com/theme/responsiv-clean)。值得注意的一点是 **October CMS 不再兼容 PHP 5.6 或者 HHVM**。尽管我们通过在安装程序中移除 PHP 版本检查的方式来尝试进行安装，但依然在配置向导中出现了 500 的错误代码。

*   文章数目: 5 篇文章加上两个左侧边栏 (最近文章和「关注我」按钮)

![October CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/October-CMS-benchmarks.png)

October CMS 测试

#### 测试结果

*   October CMS 1.0.433 PHP 5.6 测试结果: 不支持
*   October CMS 1.0.433 PHP 7.0 测试结果: 43.83 req/sec
*   October CMS 1.0.433 PHP 7.1 测试结果: 47.95 req/sec
*   **October CMS 1.0.433 PHP 7.2 测试结果: 48.87 req/sec 🏆**
*   October CMS 1.0.433 HHVM 测试结果: 不支持

尽管有两个引擎没有得到支持，我们仍然可以看到 PHP 7.2 又一次胜出了。

同时我们也很高兴地看到这些小型的 CMS 正在渐渐舍弃对老旧版本 PHP 的支持。尽管这是一个不那么大的好处。不幸的是当我们在讨论 WordPress 和其他占有大量市场份额的平台时，由于兼容性问题，一切进展缓慢。

### Laravel 5.4.36 + 5.6

[Laravel](https://laravel.com/) 是一个用来开发 web 应用的，非常热门的开源 PHP 框架。它是由 Taylor Otwell 开发的，其最初版本发布于 2011 年 6 月。

![Laravel](https://kinsta.com/wp-content/uploads/2018/02/Laravel-logo.png)

对于 Laravel 的测试，我们选用了一个纯 HTML 的主题。测试通过多次运行并取平均值。你可以在这份 [电子表格](https://docs.google.com/spreadsheets/d/1aHfpfSPA3MA82-KDGP5jmkGXkDqbbqu5qykYpCqOpIM/edit?usp=sharing)（注：须科学上网） 上看到额外的测试细节。

*   文章数目: 10 篇，加上 [Blade](https://laravel.com/docs/5.0/templates) 模板的 foreach 循环
*   数据库包含一张表 `posts`
*   数据表包含 6 个字段 `post_title`，`post_content`， `post_author`， `created_at`，和 `updated_at`。
*   关闭 Session
*   在执行测试前运行这几条命令：composer dump-autoload –classmap-authoritative, php artisan optimize –force, php artisan config:cache, php artisan route:cache

![Laravel 5.4.36 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Laravel-5.4.36-benchmarks-1.png)

Laravel 5.4.36 测试

#### 测试结果

*   Laravel 5.4.36 PHP 5.6 测试结果: 66.57 req/sec
*   Laravel 5.4.36 PHP 7.0 测试结果: 114.55 req/sec
*   Laravel 5.4.36 PHP 7.1 测试结果: 113.26 req/sec
*   Laravel 5.4.36 PHP 7.2 测试结果: 114.04 req/sec
*   Laravel 5.4.36 **HHVM 测试结果: 394.31 req/sec 🏆**

显然，HHVM 在这一次测试中成为了赢家。

然而，很重要的一点是，**Laravel 5.6 并不支持 HHVM 并要求 PHP 版本 7.1 或者更高**。

![Laravel 5.6 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Laravel-5.6-benchmarks-1.png)

Laravel 5.6 测试

#### 测试结果

*   Laravel 5.6 PHP 5.6 测试结果: 不支持
*   Laravel 5.6 PHP 7.0 测试结果: 不支持
*   Laravel 5.6 PHP 7.1 测试结果: 411.39 req/sec
*   Laravel 5.6 **PHP 7.2 测试结果: 442.17 req/sec 🏆**
*   Laravel 5.6 HHVM 测试结果: 不支持

如果你把 Laravel 5.6 加上 PHP 7.2 的测试结果与其他在 Laravel 5.4.36 上的测试结果对比的话就会发现，两者之间的差距简直是令人震惊的！Laravel 在最新版本的 PHP 上的性能表现确实是相当好的。

### Symfony 3.3.6 + 4.0.1

[Symfony](https://symfony.com/) 是一系列可复用的 PHP 组件以及一个用来搭建 web 应用，APIs，微服务，和 web 服务的 PHP 框架。它的最初版本发布于 2005 年 10 月 22 日。

![Symfony](https://kinsta.com/wp-content/uploads/2018/02/symfony.png)

对于 Symfony 的测试。我们选用了 [Symfony Demo](https://github.com/symfony/demo) 与 MySQL 的组合 (它的默认数据库是 SQLite)。测试通过多次运行取平均值。值得注意的一点是 HHVM 并没有如预期中的正常工作且抛出了 500 错误。你可以在这份 [电子表格](https://docs.google.com/spreadsheets/d/1aHfpfSPA3MA82-KDGP5jmkGXkDqbbqu5qykYpCqOpIM/edit?usp=sharing)（注：须科学上网）上看到更多的测试细节。

*   文章数目: 10
*   测试的 URL: /en/blog/
*   composer dump-autoload -o, php bin/console doctrine:database:create, php bin/console doctrine:schema:create, php bin/console doctrine:fixtures:load, php bin/console cache:clear –no-warmup –env=prod

![Symfony 3.3.6 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Symfony-3.3.6-benchmarks.png)

Symfony 3.3.6 测试

#### 测试结果

*   Symfony 3.3.6 PHP 5.6 测试结果: 81.78 req/sec
*   Symfony 3.3.6 PHP 7.0 测试结果: 184.15 req/sec
*   Symfony 3.3.6 PHP 7.1 测试结果: 187.60 req/sec
*   Symfony 3.3.6 **PHP 7.2 测试结果: 196.94 req/sec 🏆**
*   Symfony 3.3.6 HHVM 测试结果: 不支持

PHP 7.2 又双叒叕成为了赢家！

另外，**Symfony 4.0.1** **要求 PHP 7.1 版本或者更高**。而且，HHVM 又双叒叕无法正常工作并抛出 500 错误了。

![Symfony 4.0.1 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Symfony-4.0.1-benchmarks.png)

Symfony 4.0.1 测试

#### 测试结果

*   Symfony 4.0.1 PHP 5.6 测试结果: 不支持
*   Symfony 4.0.1 PHP 7.0 测试结果: 不支持
*   Symfony 4.0.1 PHP 7.1 测试结果: 188.12 req/sec
*   Symfony 4.0.1 **PHP 7.2 测试结果: 197.17 req/sec 🏆**
*   Symfony 4.0.1 HHVM 测试结果: 不支持

预料之中，PHP 7.2 再一次获得了第一名。

### PyroCMS 3.4.14

[PyroCMS](https://pyrocms.com/) 是一款开源且高效的 Laravel 插件，它能让你在基于框架的基础上开发网站和应用时如虎添翼。

![PyroCMS](https://kinsta.com/wp-content/uploads/2018/02/pyrocms.png)

对于 PyroCMS 的测试，我们选用了免费的 [Accelerant 主题](https://github.com/pyrocms/accelerant-theme) (PyroCMS 的默认主题)。需要注意的是 PyroCMS 并不能在 HHVM 上正常工作，可能是它依赖于 Laravel 的原因。

*   文章数目: 5
*   Debug 模式开启 (APP_DEBUG=true)

![PyroCMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/PyroCMS-benchmarks.png)

PyroCMS 测试

#### 测试结果

*   PyroCMS 3.4.14 PHP 5.6 测试结果: 不支持
*   PyroCMS 3.4.14 PHP 7.0 测试结果: 27.33 req/sec
*   PyroCMS 3.4.14 PHP 7.1 测试结果: 27.81 req/sec
*   PyroCMS 3.4.14 **PHP 7.2 测试结果: 29.28 req/sec 🏆**
*   PyroCMS 3.4.14 HHVM 测试结果: 不支持

尽管各个版本在 PyroCMS 上的测试结果非常接近，但是 PHP 7.2 确实再次地赢下了这次测试。

### Pagekit 1.0.13

[Pagekit](https://pagekit.com/) 是一款由 YOOtheme 创立的开源且模块化的轻量级 CMS 软件。它赋予了你用来创建漂亮网站的工具。它的最初版本发布于 2016 年的春天。

![pagekit](https://kinsta.com/wp-content/uploads/2018/02/pagekit.png)

对于 Pagekit 的测试，我们选用了免费的 [One 主题](https://pagekit.com/marketplace/package/pagekit/theme-one) (Pagekit 的默认主题)。

*   文章数目: 5
*   关闭缓存
*   测试的 URL: /blog

![Pagekit benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Pagekit-benchmarks.png)

Pagekit 测试

#### 测试结果

*   Pagekit 1.0.13 PHP 5.6 测试结果: 51.70 req/sec
*   Pagekit 1.0.13 PHP 7.0 测试结果: 108.61 req/sec
*   Pagekit 1.0.13 PHP 7.1 测试结果: 112.30 req/sec
*   Pagekit 1.0.13 **PHP 7.2 测试结果: 116.18 req/sec 🏆**
*   Pagekit 1.0.13 HHVM 测试结果: 61.16 req/sec

Pagekit 在 HHVM 上运行时遇到了一些小问题。很显然，PHP 7.2 已经超神了。

### Bolt CMS 3.4.8

Bolt CMS，又称 [Bolt](https://bolt.cm/)，是一款尽其所能做到简单粗暴的开源内容管理工具。它是基于 Silex 和 Symfony 的一系列组件开发的，使用 Twig 作为模板语言，还有其他诸如 SQLite，MySQL 或者 PostgreSQL 等作为数据库存储方案。

![Bolt CMS](https://kinsta.com/wp-content/uploads/2018/02/bolt-cms.png)

对于 Bolt CMS 的测试，我们选用了免费的 [Bolt Base 2016 主题](https://market.bolt.cm/view/bolt/theme-2016)。需要注意的是其 **并不支持 HHVM ** ([#6921](https://github.com/bolt/bolt/pull/6921)).

*   文章数目: 5
*   测试的 URL: /entries
*   开启 Session

![Bolt CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Bolt-CMS-benchmarks.png)

Bolt CMS 测试

#### 测试结果

*   Bolt CMS 3.4.8 PHP 5.6 测试结果: 33.45 req/sec
*   Bolt CMS 3.4.8 PHP 7.0 测试结果: 60.21 req/sec
*   Bolt CMS 3.4.8 PHP 7.1 测试结果: 67.96 req/sec
*   Bolt CMS 3.4.8 **PHP 7.2 测试结果: 72.05 req/sec 🏆**
*   Bolt CMS 3.4.8 HHVM 测试结果: 不支持

在这一次测试中，我们可以看到一个明显的迹象，那就是每当 PHP 发布一个新版本，Bolt CMS 都有一个稳定的性能提升。

### Anchor CMS 0.12.6 (预发布版本)

[Anchor](https://anchorcms.com/) 是一个极简主义的，开源的轻量级博客系统，它的创始初衷是为了「let you just write」。

![Anchor CMS](https://kinsta.com/wp-content/uploads/2018/02/anchor-cms-1.png)

对于 Anchor CMS 的测试，我们选用了由 Visual Idiot 开发的免费 [默认主题](https://github.com/anchorcms/anchor-cms/tree/master/themes/default)。

*   文章数目: 5

![Anchor CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Anchor-CMS-benchmarks.png)

Anchor CMS 测试

#### 测试结果

*   Anchor CMS 0.12.6 PHP 5.6 测试结果: 495.33 req/sec
*   Anchor CMS 0.12.6 PHP 7.0 测试结果: 546.02 req/sec
*   Anchor CMS 0.12.6 **PHP 7.1 测试结果: 565.00 req/sec 🏆**
*   Anchor CMS 0.12.6 PHP 7.2 测试结果: 561.73 req/sec
*   Anchor CMS 0.12.6 HHVM 测试结果: 487.71 req/sec

在我们的测试中，PHP 7.1 和 7.2 版本之间的测试结果相当接近。但 PHP 7.1 版本还是以微弱的性能优势领先。

### PrestaShop 1.7.2.4

[PrestaShop](https://www.prestashop.com/en) 是一款很热门且正处于飞速发展中的开源电子商务解决方案。它的最初版本发布于 2008 年 7 月 31 日，根据 W3Techs 的数据，互联网上有 [0.6% 的网站](https://w3techs.com/technologies/details/cm-prestashop/all/all) 使用了它。

![PrestaShop](https://kinsta.com/wp-content/uploads/2018/02/prestashop.png)

对于 PrestaShop 的测试，我们选用了免费的 [经典主题](https://github.com/PrestaShop/PrestaShop/tree/develop/themes/classic)。要注意的一点是 [PrestaShop 并不支持 HHVM](https://www.prestashop.com/forums/topic/579038-hhvm-prestashop/).

*   商品数目: 7 (默认样例商品)
*   测试的 URL: /index.php
*   页面缓存: 关闭，智能缓存: 开启

![PrestaShop benchmarks](https://kinsta.com/wp-content/uploads/2018/02/PrestaShop-benchmarks.png)

PrestaShop 测试

#### 测试结果

*   Prestashop 1.7.2.4 PHP 5.6 测试结果: 61.96 req/sec
*   Prestashop 1.7.2.4 PHP 7.0 测试结果: 108.34 req/sec
*   Prestashop 1.7.2.4 PHP 7.1 测试结果: 111.38 req/sec
*   Prestashop 1.7.2.4 **PHP 7.2 测试结果: 111.48 req/sec** **🏆**
*   Prestashop 1.7.2.4 HHVM 测试结果: 不支持

测试结果 7.0 版本之后的 PHP 之间旗鼓相当，但是 PHP 7.2 最终还是以细微的差距挤上了头名的位置。

### Craft CMS 2.6.3011

[Craft CMS](https://craftcms.com/) 是一款专注于为开发者，设计师和 web 专家提供灵活性，强大性以及客户端易用性的 CMS 软件。

![Craft CMS](https://kinsta.com/wp-content/uploads/2018/02/craft-cms.png)

对于 Craft CMS 的测试，我们选用了免费的 [默认主题](https://github.com/craftcms/cms).

*   文章数目: 5
*   测试的 URL: /index.php?p=news
*   CraftCMS 自带了一份 Dockerfile。我们自定义了一部分以使其兼容 Nginx。

![Craft CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Craft-CMS-benchmarks.png)

Craft CMS 测试

#### 测试结果

*   Craft CMS 2.6.3011 PHP 5.6 测试结果: 131.04 req/sec
*   Craft CMS 2.6.3011 PHP 7.0 测试结果: 266.54 req/sec
*   Craft CMS 2.6.3011 PHP 7.1 测试结果: 272.14 req/sec
*   Craft CMS 2.6.3011 **PHP 7.2 测试结果: 280.02 req/sec** **🏆**
*   Craft CMS 2.6.3011 HHVM 测试结果: 26.28 req/sec

Craft CMS 在 HHVM 上并没有表现好。但是在 PHP 7.2 上却是相当的快！

### Fork CMS 5.2.2

Fork 是一款使用了 Symfony 组件开发的使用方便的 CMS 软件。对于 Fork CMS 的测试，我们选用了免费的默认 [Fork 主题](https://github.com/forkcms/forkcms/tree/master/src/Frontend/Themes/Fork)。需要注意的是 **Fork CMS 要求 PHP 版本为 7.1 或者更高，而且不支持 HHVM**。

*   文章数目: 2 (从 ForkCMS 中获取的默认样例数据)
*   测试的 URL: /modules/blog

![Fork CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Fork-CMS-benchmarks.png)

Fork CMS 测试

#### 测试结果

*   Fork CMS 5.2.2 PHP 5.6 测试结果: 不支持
*   Fork CMS 5.2.2 PHP 7.0 测试结果: 不支持
*   Fork CMS 5.2.2 PHP 7.1 测试结果: 10.68 req/sec
*   **Fork CMS 5.2.2 PHP 7.2 测试结果: 12.83 req/sec** **🏆**
*   Fork CMS 5.2.2 HHVM 测试结果: 不支持

本次测试中，PHP 7.2 在性能方面击败了 PHP 7.1。

### 现在在 Kinsta 上升级到 PHP 7.2

如果上面的结果仍不能使你信服，那我们也不知道还有什么可以！温馨提示，如果你是 Kinsta 的客户，我们在 2017 年的十二月就发布了对于 [PHP 7.2](https://kinsta.com/blog/php-7-2/) 的支持。如果你想看到性能的提升，你只需在你的 MyKinsta 后台通过轻轻一点来切换到 PHP 7.2 版本即可。

![Changing the WordPress PHP version on Kinsta](https://kinsta.com/wp-content/uploads/2016/05/wordpress-php-version-2.png)

在 Kinsta 上切换到 PHP 7.2

如果你担心会与一些第三方插件产生兼容性问题的话（这确实可能会发生），我们的测试站点功能就可以排上用场了。😉 你可以随意进行测试而不用担心破坏掉你的生产环境。

## 本次测试的总结

就像你很清晰地从上面所有测试中看到的一样，**PHP 7.2 在多个平台的性能上已经成为了领头羊**. 🏋

*   在上面测试的20种配置中，PHP 7.2 有 14 次是速度最快的引擎。其中还有两个（Drupal 和 Magento ）不支持PHP 7.2，所以这个比例可能高达 16/20。
*   **而对于 WordPress 来说，PHP 7.2 是所有测试中最快的** (包含 WordPress 站点，WooCommerce，和 Easy Digital Downloads).
*   在许多基准测试结果中，你可以很轻易地发现 PHP 新版本与性能提升是成正比的。这也就是为什么测试你的站点、插件并坚持定期升级计划是如此的重要。你的访问者和客户将会因为他们享受到的速度而感谢你！
*   如果你的空间提供商并没有提供新版本的 PHP，那你可能是时候要考虑进行迁移了。

我们对于 PHP 7.2 感到十分兴奋，期待你也与我们一样！我们很乐意听到您对于我们的测评的看法或者是您的升级攻略，请将您想说的留在下方的评论中。

---

这篇文章是由 [Mark Gavalda](https://kinsta.com/blog/author/kinstadmin/) 编写的。Mark 在市场，web 设计和开发领域拥有多年的带队经验。作为一个开发者，他利用他在 WP 领域的专业知识来收集关于如何创建一个可靠且对用户友好的托管公司的诀窍。他是一名从不停止学习新技能的自学者和城市自行车手。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
