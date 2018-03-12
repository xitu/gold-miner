> * 原文地址：[The Definitive PHP 5.6, 7.0, 7.1, 7.2 & HHVM Benchmarks (2018)](https://kinsta.com/blog/php-7-hhvm-benchmarks/)
> * 原文作者：[Mark Gavalda](https://kinsta.com/blog/author/kinstadmin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/php-7-hhvm-benchmarks.md](https://github.com/xitu/gold-miner/blob/master/TODO/php-7-hhvm-benchmarks.md)
> * 译者：
> * 校对者：

# The Definitive PHP 5.6, 7.0, 7.1, 7.2 & HHVM Benchmarks (2018)

![](https://kinsta.com/wp-content/uploads/2018/02/php-7-hhvm-benchmarks-1.png)

Each year we try and take a deep dive into performance benchmarks across various platforms and see how different versions of PHP and HHVM stack up against each other. This year we went all out and benchmarked four different PHP engines and HHVM across 20 different platforms/configurations; including WordPress, Drupal, Joomla!, Laravel, Symfony, and many more. We also tested popular eCommerce solutions such as WooCommerce, Easy Digital Downloads, Magento, and PrestaShop.

Looking for the Spanish version? [Leer en Español](https://kinsta.com/es/blog/php-7-hhvm-rendimiento/)

We are always encouraging WordPress users to take advantage of the latest [supported versions of PHP](https://kinsta.com/blog/php-versions/). Not only are they more secure, but they offer additional performance improvements. We aren’t talking just about WordPress either, this true for the most part across all platforms. We’ll show you today how **PHP 7.2 knocks the socks off of everything we put it against! 🚀**

The results this year have drastically changed from our previous benchmarks where HHVM was the winner. We now are excited to see PHP 7.2 as the leading engine in terms of speed. It’s important to note that as far as WordPress is concerned, [HHVM is no longer supported](https://make.wordpress.org/core/2017/05/25/hhvm-no-longer-part-of-wordpress-cores-testing-infrastructure/) and will slowly be fading away. We no longer encourage our customers to move to HHVM and also noticed support for it across various platforms was subpar as well.

This is great news for developers and end-users alike as it means more of a focus back on PHP and providing faster websites and web services for everyone.

## PHP & HHVM Benchmarks (2018)

For each test, we used the latest version of each platform and benchmarked the home page for a minute with 15 concurrent users. Below are the details of our test environment.

*   **Machine used:** 8x Intel(R) Xeon(R) CPU @ 2.20GHz (Powered by [Google Cloud Platform](https://kinsta.com/blog/google-cloud-hosting/) and running in an isolated container)
*   **OS:** Ubuntu 16.04.3 LTS
*   **Docker Stack:** Debian 8, Nginx 1.13.8, MariaDB 10.1.31
*   **PHP Engines:** 5.6, 7.0, 7.1, 7.2
*   **HHVM:** 3.24.2
*   **OPCache:** For WordPress, Joomla, and Drupal, we used the official Docker image. For the rest we used the same image setup with the OPcache enabled using the following [recommended php.ini settings](https://secure.php.net/manual/en/opcache.installation.php).

```
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
```

The tests were performed by [Thoriq Firdaus](https://twitter.com/tfirdaus) a WordPress contributor and support engineer here at Kinsta. He’s contributed to WordPress Core and [Translation Editor for WordPress Indonesia](https://translate.wordpress.org/locale/id/default/wp/dev).

### What is PHP?

PHP stands for Hypertext Preprocessor. It is one of the most popular scripting languages on the web today. According to W3Techs, PHP is used by over [83% of all the websites](https://w3techs.com/technologies/details/pl-php/all/all) who use a server-side programming language.

### What is HHVM?

Due to performance issues with PHP the team at Facebook developed the HipHop Virtual Machine ([HHVM](https://hhvm.com/)). It is a system that uses just-in-time (JIT) compilation to convert PHP code into a machine language to establish a synergy between the PHP code and the underlying hardware that runs it.

### Platforms and Configurations Tested

Our tests include the following 20 platforms/configurations. On some, we had to test multiple versions due to the lack of support for a specific PHP version. Click on one below to skip directly to its test notes and results. The data is measured in requests per second. The more requests the better.

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

The first platform we tested was, of course, one of our favorites: [WordPress](https://wordpress.org/) (we might be a little biased being that we live and breath this CMS on a daily basis 😉). At its core, WordPress is open-source software you can use to create a beautiful website, blog, or app. In fact, WordPress powers over [29% of all the websites](https://kinsta.com/wordpress-market-share/) on the internet. Yes – more than one in four websites that you visit are likely powered by WordPress.

![WordPress CMS](https://kinsta.com/wp-content/uploads/2018/02/wordpress-cms.png)

For the WordPress benchmark, we utilized the free [Twenty Seventeen theme](https://kinsta.com/blog/twenty-seventeen-theme/). We used dummy content from wptest.io and benchmarked the home page for a minute with 15 concurrent users.

*   Number of Posts: 10 / page generated with wptest.io
*   “Search” sidebar is the only thing present on the Sidebar
*   Docker Image is derived from [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-php-benchmarks.png)

WordPress benchmarks

#### Benchmark Results

*   WordPress 4.9.4 PHP 5.6 benchmark results: 49.18 req/sec
*   WordPress 4.9.4 PHP 7.0 benchmark results: 133.55 req/sec
*   WordPress 4.9.4 PHP 7.1 benchmark results: 134.24 req/sec
*   WordPress 4.9.4 **PHP 7.2 benchmark results**: **148.80 req/sec 🏆**
*   WordPress 4.9.4 HHVM benchmark results: 144.76 req/sec

PHP 7.2 was the winner, proving to be slightly faster than HHVM. This is a significant change from our benchmarks in 2016 where HHVM was clearly the winner. PHP for WordPress is also a lot more stable. We have experienced first-hand many issues with HHVM.

## WordPress 4.9.4 + WooCommerce 3.3.1

[WooCommerce](https://woocommerce.com/) is a fully customizable, open-source eCommerce platform built for WordPress. It’s also by far, one of the most popular eCommerce solutions, powering over [42% of all eCommerce sites](https://kinsta.com/wordpress-market-share/#woocommerce) on the internet.

![WooCommerce](https://kinsta.com/wp-content/uploads/2018/02/woocommerce.png)

For this next test, we took WordPress along with WooCommerce installed. We utilized the free [Storefront eCommerce theme](https://woocommerce.com/storefront/).

*   Number of Products: 8 (2 products per row)
*   Set the shop page as the homepage
*   Docker Image is derived from [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress + WooCommerce benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-woocommerce-php-benchmarks.png)

WordPress + WooCommerce benchmarks

#### Benchmark Results

*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 5.6 benchmark results: 34.47 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 7.0 benchmark results: 84.89 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 PHP 7.1 benchmark results: 86.04 req/sec
*   WordPress 4.9.4 + WooCommerce 3.3.1 **PHP 7.2 benchmark results:** **92.60 req/sec 🏆**
*   WordPress 4.9.4 + WooCommerce 3.3.1 HHVM benchmark results: 69.58 req/sec

WooCommerce struggled with HHVM, and PHP 7.2 beat out PHP 7.1 by a small margin.

## WordPress 4.9.4 + Easy Digital Downloads 2.8.18

[Easy Digital Downloads](https://easydigitaldownloads.com/) (EDD), created by Pippin Williamson, is a free WordPress eCommerce plugin that focuses purely on helping creators and developers sell digital products.

![Easy Digital Downloads](https://kinsta.com/wp-content/uploads/2018/02/easy-digital-downloads.png)

After seeing how WooCommerce performed, we then took WordPress along with Easy Digital Downloads installed. We utilized the free [EDD Starter Theme](https://easydigitaldownloads.com/downloads/edd-starter-theme/).

*   Number of Products: 6 (Default product samples from the plugin)
*   2 images on the products list are missing
*   Docker Image is derived from [https://hub.docker.com/_/wordpress/](https://hub.docker.com/_/wordpress/)

![WordPress + Easy Digital Downloads benchmarks](https://kinsta.com/wp-content/uploads/2018/02/wordpress-edd-php-benchmarks.png)

WordPress + Easy Digital Downloads benchmarks

#### Benchmark Results

*   WordPress 4.9.4 + EDD 2.8.18 PHP 5.6 benchmark results: 76.71 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 PHP 7.0 benchmark results: 123.83 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 PHP 7.1 benchmark results: 124.82 req/sec
*   WordPress 4.9.4 + EDD 2.8.18 **PHP 7.2 benchmark results:** **135.74 req/sec 🏆**
*   WordPress 4.9.4 + EDD 2.8.18 HHVM benchmark results: 127.74 req/sec

PHP 7.2 dominated the tests with WordPress and Easy Digital Downloads.

### Drupal 8.4.4

[Drupal](https://www.drupal.org/) is an open-source CMS popular for its modular system and strong developer community. It was originally launched in 2000 and according to W3Techs, powers [2.2% of all websites](https://w3techs.com/technologies/overview/content_management/all) with a 4.4% share of the content management system market.

![Drupal](https://kinsta.com/wp-content/uploads/2018/02/drupal-logo.png)

For the Drupal benchmark, we utilized the free [Bartik 8.4.4 theme](https://github.com/pantheon-systems/drops-8/tree/master/core/themes/bartik). It’s important to note that **Drupal 8.4.x is not compatible with PHP 7.2** ([#2932574](https://www.drupal.org/project/drupal/issues/2932574)), therefore that engine wasn’t tested.

*   Number of Posts: 10 generated with Devel module
*   Page caching is turned off: [https://www.drupal.org/node/2598914](https://www.drupal.org/node/2598914)
*   Docker Image is derived from [https://hub.docker.com/_/drupal/](https://hub.docker.com/_/drupal/)

![Drupal benchmarks](https://kinsta.com/wp-content/uploads/2018/02/drupal-benchmarks.png)

Drupal benchmarks

#### Benchmark Results

*   Drupal 8.4.4 PHP 5.6 benchmark results: 7.05 req/sec
*   Drupal 8.4.4 PHP 7.0 benchmark results: 15.94 req/sec
*   Drupal 8.4.4 PHP 7.1 benchmark results: 19.15 req/sec
*   Drupal 8.4.4 PHP 7.2 benchmark results: (not supported)
*   Drupal 8.4.4 **HHVM benchmark results: 19.57 req/sec 🏆**

Due to the fact that the latest version of Drupal doesn’t support PHP 7.2, HHVM took the winning spot. Although looking back on performance improvements from previous PHP versions, we can safely assume PHP 7.2 would have probably been even faster!

### Joomla! 3.8.5

[Joomla!](https://www.joomla.org/) is a free and open source CMS for publishing web content, originally released on August 17, 2005. It’s built on a model–view–controller web application framework and according to W3Techs is used by [3.1% of all websites](https://w3techs.com/technologies/details/cm-joomla/all/all) on the internet.

![Joomla!](https://kinsta.com/wp-content/uploads/2018/02/joomla-logo-e1519705676991.png)

For the Joomla! benchmark, we utilized the free [Beez3 template](http://a4joomla.com/joomla-templates/countryside-free/using-joomla/extensions/templates/beez3.html).

*   Number of Posts: 4 (default Joomla sample posts added during installation)
*   Default Sidebars are unpublished
*   Docker Image is derived from [https://hub.docker.com/_/joomla/](https://hub.docker.com/_/joomla/)

![Joomla! benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Joomla-benchmarks-1.png)

Joomla! benchmarks

#### Benchmark Results

*   Joomla! 3.8.5 PHP 5.6 benchmark results: 26.42 req/sec
*   Joomla! 3.8.5 PHP 7.0 benchmark results: 41.46 req/sec
*   Joomla! 3.8.5 PHP 7.1 benchmark results: 41.17 req/sec
*   Joomla! 3.8.5 PHP 7.2 benchmark results: 42.36 req/sec
*   Joomla! 3.8.5 **HHVM benchmark results: 51.84 req/sec 🏆**

On Joomla! we can see a steady progression in performance with each version of PHP. But HHVM still leads the pack.

### Magento 2 (CE) 2.1.11 + 2.2.2

[Magento](https://magento.com/) is popular open-source e-commerce platform written in PHP and was released on March 31, 2008\. According to W3Techs, it powers [1.2% of all websites](https://w3techs.com/technologies/details/cm-magento/all/all) on the internet.

![Magento](https://kinsta.com/wp-content/uploads/2018/02/magento.png)

For the Magento 2 benchmark, we utilized the free [Luma theme](http://magento2-demo.nexcess.net/). We used two versions due to the fact that 2.1.11 was the only one that supported PHP 5.6\. We installed it with the sample data and the default theme that comes with it. For the additional tests, we used 2.2.2\. **Magento 2 does not support PHP 7.2 yet** or the latest version of HHVM.

*   Number of Products: 7
*   [http://pubfiles.nexcess.net/magento/ce-packages/](http://pubfiles.nexcess.net/magento/ce-packages/)

![Magento 2 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/magento-2-benchmarks-1.png)

Magento 2 benchmarks

#### Benchmark Results

*   Magento 2 (CE) 2.1.11 PHP 5.6 benchmark results: 10.75 req/sec
*   Magento 2 (CE) 2.1.11 PHP 7.0 benchmark results: 20.87 req/sec
*   Magento 2 (CE) 2.1.11 **PHP 7.1 benchmark results: 29.84 req/sec 🏆**
*   Magento 2 (CE) 2.1.11 PHP 7.2 benchmark results: not supported
*   Magento 2 (CE) 2.1.11 HHVM benchmark results: not supported

Due to the fact that both PHP 7.2 and the latest version of HHVM aren’t supported by Magento 2, PHP 7.1 was the clear winner. It is pretty impressive to see the consistent performance gains through each version.

### Grav CMS 1.3.10

[Grav](https://getgrav.org/) is an easy to use, yet powerful, open-source CMS that requires no database. This is also sometimes referred to as a flat-file CMS.

![Grav CMS](https://kinsta.com/wp-content/uploads/2018/02/grav-cms.png)

For the Grav CMS benchmark, we utilized the free [Clean Blog skeleton package](https://getgrav.org/downloads/skeletons). It’s important to note that **Grav CMS is no longer compatible with HHVM** compiler and it has [removed the HHVM environment](https://github.com/getgrav/grav/commit/abccf2278dac637089fb5b20b6386d88905335c5) from their Travis build.

*   Number of Posts: 4 (preset posts on the “Clean Blog” skeleton)
*   Page/File Caching is turned off [https://learn.getgrav.org/advanced/performance-and-caching](https://learn.getgrav.org/advanced/performance-and-caching), Twig caching is still enabled.

![Grav CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/grav-cms-benchmarks-1.png)

Grav CMS benchmarks

#### Benchmark Results

*   Grav CMS 1.3.10 PHP 5.6 benchmark results: 34.83 req/sec
*   Grav CMS 1.3.10 PHP 7.0 benchmark results: 53.37 req/sec
*   Grav CMS 1.3.10 PHP 7.1 benchmark results: 53.37 req/sec
*   Grav CMS 1.3.10 **PHP 7.2 benchmark results: 55.12 req/sec 🏆**
*   Grav CMS 1.3.10 HHVM benchmark results: not supported

We can again see with Grav CMS that the latest version of PHP (7.2) is the clear winner.

### October CMS 1.0.433

[October CMS](https://octobercms.com/) is a free, open-source, self-hosted and modular CMS platform based on the Laravel PHP Framework. It was originally released on May 15, 2014.

![October CMS](https://kinsta.com/wp-content/uploads/2018/02/october-cms.png)

For the October CMS benchmark, we utilized the free [Clean Blog theme](https://octobercms.com/theme/responsiv-clean). It’s important to note that **October CMS is no longer compatible with PHP 5.6 or HHVM**. Even though we were able to trick the installer by removing the PHP check, it failed with a 500 error code in the configuration wizard.

*   Number of Posts: 5 with two sidebars at the left (Recent posts and Follow me)

![October CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/October-CMS-benchmarks.png)

October CMS benchmarks

#### Benchmark Results

*   October CMS 1.0.433 PHP 5.6 benchmark results: not supported
*   October CMS 1.0.433 PHP 7.0 benchmark results: 43.83 req/sec
*   October CMS 1.0.433 PHP 7.1 benchmark results: 47.95 req/sec
*   **October CMS 1.0.433 PHP 7.2 benchmark results: 48.87 req/sec 🏆**
*   October CMS 1.0.433 HHVM benchmark results: not supported

Even though two of the engines weren’t supported, we can see that PHP 7.2 wins again.

It’s also nice to see these smaller content management systems dropping support for older versions of PHP. Although that is one advantage of not being quite as big either. Unfortunately when it comes to WordPress and other platforms with a large portion of the market share, things progress more slowly due to compatiblity issues.

### Laravel 5.4.36 + 5.6

[Laravel](https://laravel.com/) is a very popular open-source PHP framework used to develop web applications. It was created by Taylor Otwell and was released in June 2011.

![Laravel](https://kinsta.com/wp-content/uploads/2018/02/Laravel-logo.png)

For the Laravel benchmark, we used a plain HTML theme. Tests were run multiple times and averages taken. You can see additional details in this [spreadsheet](https://docs.google.com/spreadsheets/d/1aHfpfSPA3MA82-KDGP5jmkGXkDqbbqu5qykYpCqOpIM/edit?usp=sharing).

*   Number of Posts: 10 with [Blade](https://laravel.com/docs/5.0/templates) foreach loop
*   The database contains 1 table `posts`
*   The table contains 6 columns `post_title`, `post_content`, `post_author`, `created_at`, and `updated_at`.
*   Session is turned off
*   Run composer dump-autoload –classmap-authoritative, php artisan optimize –force, php artisan config:cache, php artisan route:cache before performing the benchmark

![Laravel 5.4.36 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Laravel-5.4.36-benchmarks-1.png)

Laravel 5.4.36 benchmarks

#### Benchmark Results

*   Laravel 5.4.36 PHP 5.6 benchmark results: 66.57 req/sec
*   Laravel 5.4.36 PHP 7.0 benchmark results: 114.55 req/sec
*   Laravel 5.4.36 PHP 7.1 benchmark results: 113.26 req/sec
*   Laravel 5.4.36 PHP 7.2 benchmark results: 114.04 req/sec
*   Laravel 5.4.36 **HHVM benchmark results: 394.31 req/sec 🏆**

HHVM is the clear winner here.

It’s important to note that **Laravel 5.6 is not compatible with HHVM** **and requires PHP 7.1 or higher**.

![Laravel 5.6 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Laravel-5.6-benchmarks-1.png)

Laravel 5.6 benchmarks

#### Benchmark Results

*   Laravel 5.6 PHP 5.6 benchmark results: not supported
*   Laravel 5.6 PHP 7.0 benchmark results: not supported
*   Laravel 5.6 PHP 7.1 benchmark results: 411.39 req/sec
*   Laravel 5.6 **PHP 7.2 benchmark results: 442.17 req/sec 🏆**
*   Laravel 5.6 HHVM benchmark results: not supported

If you compare Laravel 5.6 PHP 7.2 benchmarks to those of Laravel 5.4.36 the difference is astounding! Laravel performs really good with the latest versions of PHP.

### Symfony 3.3.6 + 4.0.1

[Symfony](https://symfony.com/) is a set of reusable PHP components and a PHP framework to build web applications, APIs, microservices and web services. It was released on October 22, 2005.

![Symfony](https://kinsta.com/wp-content/uploads/2018/02/symfony.png)

For the Symfony benchmark, we used the [Symfony Demo](https://github.com/symfony/demo) with MySQL (they default to SQLite). Tests were run multiple times and averages taken. It’s important to note that HHVM did not work well and throws a 500 error. You can see additional details in this [spreadsheet](https://docs.google.com/spreadsheets/d/1aHfpfSPA3MA82-KDGP5jmkGXkDqbbqu5qykYpCqOpIM/edit?usp=sharing).

*   Number of Posts: 10
*   Tested URL: /en/blog/
*   composer dump-autoload -o, php bin/console doctrine:database:create, php bin/console doctrine:schema:create, php bin/console doctrine:fixtures:load, php bin/console cache:clear –no-warmup –env=prod

![Symfony 3.3.6 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Symfony-3.3.6-benchmarks.png)

Symfony 3.3.6 benchmarks

#### Benchmark Results

*   Symfony 3.3.6 PHP 5.6 benchmark results: 81.78 req/sec
*   Symfony 3.3.6 PHP 7.0 benchmark results: 184.15 req/sec
*   Symfony 3.3.6 PHP 7.1 benchmark results: 187.60 req/sec
*   Symfony 3.3.6 **PHP 7.2 benchmark results: 196.94 req/sec 🏆**
*   Symfony 3.3.6 HHVM benchmark results: not supported

PHP 7.2 is yet again the winner!

It’s important to note that **Symfony 4.0.1** **requires PHP 7.1 or higher**. And again HHVM did not work well and throws a 500 error

![Symfony 4.0.1 benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Symfony-4.0.1-benchmarks.png)

Symfony 4.0.1 benchmarks

#### Benchmark Results

*   Symfony 4.0.1 PHP 5.6 benchmark results: not supported
*   Symfony 4.0.1 PHP 7.0 benchmark results: not supported
*   Symfony 4.0.1 PHP 7.1 benchmark results: 188.12 req/sec
*   Symfony 4.0.1 **PHP 7.2 benchmark results: 197.17 req/sec 🏆**
*   Symfony 4.0.1 HHVM benchmark results: not supported

No surprise here, PHP 7.2 is again on top.

### PyroCMS 3.4.14

[PyroCMS](https://pyrocms.com/) is open source and essentially an extension of Laravel which allows you to build websites and applications on the framework faster.

![PyroCMS](https://kinsta.com/wp-content/uploads/2018/02/pyrocms.png)

For the PyroCMS benchmark, we used the free [Accelerant Theme](https://github.com/pyrocms/accelerant-theme) (default PyroCMS theme). It’s important to note that PyroCMS doesn’t work in HHVM, possibly due to the dependent on Laravel.

*   Number of Posts: 5
*   Debug Mode is On (APP_DEBUG=true)

![PyroCMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/PyroCMS-benchmarks.png)

PyroCMS benchmarks

#### Benchmark Results

*   PyroCMS 3.4.14 PHP 5.6 benchmark results: not supported
*   PyroCMS 3.4.14 PHP 7.0 benchmark results: 27.33 req/sec
*   PyroCMS 3.4.14 PHP 7.1 benchmark results: 27.81 req/sec
*   PyroCMS 3.4.14 **PHP 7.2 benchmark results: 29.28 req/sec 🏆**
*   PyroCMS 3.4.14 HHVM benchmark results: not supported

The results were pretty close with PyroCMS, but PHP 7.2 did once again perform the best.

### Pagekit 1.0.13

[Pagekit](https://pagekit.com/) is an open-source modular and lightweight CMS founded by YOOtheme. It gives you the tools to create beautiful websites. It was released in the Spring of 2016.

![pagekit](https://kinsta.com/wp-content/uploads/2018/02/pagekit.png)

For the Pagekit benchmark, we used the free [One theme](https://pagekit.com/marketplace/package/pagekit/theme-one) (default Pagekit theme).

*   Number of Posts: 5
*   Cache is disabled
*   Tested URL: /blog

![Pagekit benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Pagekit-benchmarks.png)

Pagekit benchmarks

#### Benchmark Results

*   Pagekit 1.0.13 PHP 5.6 benchmark results: 51.70 req/sec
*   Pagekit 1.0.13 PHP 7.0 benchmark results: 108.61 req/sec
*   Pagekit 1.0.13 PHP 7.1 benchmark results: 112.30 req/sec
*   Pagekit 1.0.13 **PHP 7.2 benchmark results: 116.18 req/sec 🏆**
*   Pagekit 1.0.13 HHVM benchmark results: 61.16 req/sec

Pagekit struggled when running on HHVM. PHP 7.2 clearly dominated again in these tests.

### Bolt CMS 3.4.8

Bolt CMS, or [Bolt](https://bolt.cm/), is an open-source content management tool, which strives to be as simple and straightforward as possible. It is based on Silex and Symfony components, uses Twig and either SQLite, MySQL or PostgreSQL.

![Bolt CMS](https://kinsta.com/wp-content/uploads/2018/02/bolt-cms.png)

For the Bolt CMS benchmark, we used the free [Bolt Base 2016 theme](https://market.bolt.cm/view/bolt/theme-2016). It’s important to note that **HHVM is not supported** ([#6921](https://github.com/bolt/bolt/pull/6921)).

*   Number of Posts: 5
*   Tested URL: /entries
*   Session is still enabled

![Bolt CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Bolt-CMS-benchmarks.png)

Bolt CMS benchmarks

#### Benchmark Results

*   Bolt CMS 3.4.8 PHP 5.6 benchmark results: 33.45 req/sec
*   Bolt CMS 3.4.8 PHP 7.0 benchmark results: 60.21 req/sec
*   Bolt CMS 3.4.8 PHP 7.1 benchmark results: 67.96 req/sec
*   Bolt CMS 3.4.8 **PHP 7.2 benchmark results: 72.05 req/sec 🏆**
*   Bolt CMS 3.4.8 HHVM benchmark results: not supported

We can see a clear indicator here that with each new release of PHP the Bolt CMS saw consistent performance gains.

### Anchor CMS 0.12.6 (pre-release)

[Anchor](https://anchorcms.com/) is a super-simple, open-source and lightweight blog system, made to let you just write.

![Anchor CMS](https://kinsta.com/wp-content/uploads/2018/02/anchor-cms-1.png)

For the Anchor CMS benchmark, we used the free [Default Theme](https://github.com/anchorcms/anchor-cms/tree/master/themes/default) by Visual Idiot.

*   Number of Posts: 5

![Anchor CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Anchor-CMS-benchmarks.png)

Anchor CMS benchmarks

#### Benchmark Results

*   Anchor CMS 0.12.6 PHP 5.6 benchmark results: 495.33 req/sec
*   Anchor CMS 0.12.6 PHP 7.0 benchmark results: 546.02 req/sec
*   Anchor CMS 0.12.6 **PHP 7.1 benchmark results: 565.00 req/sec 🏆**
*   Anchor CMS 0.12.6 PHP 7.2 benchmark results: 561.73 req/sec
*   Anchor CMS 0.12.6 HHVM benchmark results: 487.71 req/sec

The results were very close between PHP 7.1 and PHP 7.2\. But PHP 7.1 saw slightly faster performance in our tests.

### PrestaShop 1.7.2.4

[PrestaShop](https://www.prestashop.com/en) is a popular and very fast growing open-source eCommerce solution. It was originally released on July 31, 2008, and according to W3Techs is used by [0.6% of all websites](https://w3techs.com/technologies/details/cm-prestashop/all/all) on the internet.

![PrestaShop](https://kinsta.com/wp-content/uploads/2018/02/prestashop.png)

For the PrestaShop benchmark, we used the free [Classic Theme](https://github.com/PrestaShop/PrestaShop/tree/develop/themes/classic). It’s important to note that [PrestaShop doesn’t support HHVM](https://www.prestashop.com/forums/topic/579038-hhvm-prestashop/).

*   Number of Products: 7 (Default sample products)
*   Tested URL: /index.php
*   Page Caching: Disabled, Smarty Caching: Enabled

![PrestaShop benchmarks](https://kinsta.com/wp-content/uploads/2018/02/PrestaShop-benchmarks.png)

PrestaShop benchmarks

#### Benchmark Results

*   Prestashop 1.7.2.4 PHP 5.6 benchmark results: 61.96 req/sec
*   Prestashop 1.7.2.4 PHP 7.0 benchmark results: 108.34 req/sec
*   Prestashop 1.7.2.4 PHP 7.1 benchmark results: 111.38 req/sec
*   Prestashop 1.7.2.4 **PHP 7.2 benchmark results: 111.48 req/sec** **🏆**
*   Prestashop 1.7.2.4 HHVM benchmark results: not supported

The results were almost too close to call, but PHP 7.2 managed to barely squeeze in as the leader.

### Craft CMS 2.6.3011

[Craft CMS](https://craftcms.com/) is a focused content management system for developers, designers, and web professionals that blends flexibility, power, and ease of use for clients.

![Craft CMS](https://kinsta.com/wp-content/uploads/2018/02/craft-cms.png)

For the Craft CMS benchmark, we used the free [default theme](https://github.com/craftcms/cms).

*   Number of Posts: 5
*   Tested URL: /index.php?p=news
*   CraftCMS comes with its own Dockerfile. We customize it a bit to be compatible with Nginx.

![Craft CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Craft-CMS-benchmarks.png)

Craft CMS benchmarks

#### Benchmark Results

*   Craft CMS 2.6.3011 PHP 5.6 benchmark results: 131.04 req/sec
*   Craft CMS 2.6.3011 PHP 7.0 benchmark results: 266.54 req/sec
*   Craft CMS 2.6.3011 PHP 7.1 benchmark results: 272.14 req/sec
*   Craft CMS 2.6.3011 **PHP 7.2 benchmark results: 280.02 req/sec** **🏆**
*   Craft CMS 2.6.3011 HHVM benchmark results: 26.28 req/sec

Craft CMS did not perform well for us on HHVM. But PHP 7.2 again was blazing fast!

### Fork CMS 5.2.2

Fork is an easy to use open-source CMS using Symfony Components. For the Fork CMS benchmark, we used the free default [Fork Theme](https://github.com/forkcms/forkcms/tree/master/src/Frontend/Themes/Fork). It’s important to note that **Fork CMS requires PHP 7.1 or higher and doesn’t support HHVM**.

*   Number of Posts: 2 (Default sample data from ForkCMS)
*   Tested URL: /modules/blog

![Fork CMS benchmarks](https://kinsta.com/wp-content/uploads/2018/02/Fork-CMS-benchmarks.png)

Fork CMS benchmarks

#### Benchmark Results

*   Fork CMS 5.2.2 PHP 5.6 benchmark results: not supported
*   Fork CMS 5.2.2 PHP 7.0 benchmark results: not supported
*   Fork CMS 5.2.2 PHP 7.1 benchmark results: 10.68 req/sec
*   **Fork CMS 5.2.2 PHP 7.2 benchmark results: 12.83 req/sec** **🏆**
*   Fork CMS 5.2.2 HHVM benchmark results: not supported

PHP 7.2 beat out PHP 7.1 in terms of performance.

### Upgrade to PHP 7.2 Now at Kinsta

If the results above don’t convince you, we aren’t sure what will! Just a friendly reminder. If you are a Kinsta client, we released [PHP 7.2](https://kinsta.com/blog/php-7-2/) back in December 2017\. If you are wanting to see performance improvements, you can easily change to PHP 7.2 with a single click in your MyKinsta dashboard.

![Changing the WordPress PHP version on Kinsta](https://kinsta.com/wp-content/uploads/2016/05/wordpress-php-version-2.png)

Change to PHP 7.2 on Kinsta

If you are worried about it being incompatible with a third-party plugin (which can happen), this is exactly why we have staging sites. 😉 You can test away without worrying about breaking your production site.

## Takeaway From Benchmark Results

As you can clearly see from the tests above, **PHP 7.2 is leading the pack when it comes to performance across all platforms**. 🏋

*   PHP 7.2 was the fastest engine in 14 out of the 20 configurations tested above. And two of these (Drupal and Magento) don’t support PHP 7.2 yet, so it could be as high as 16/20.
*   **As far as WordPress is concerned, PHP 7.2 was the fastest in all tests** (stock WordPress site, WooCommerce, and Easy Digital Downloads).
*   In many of the benchmark results, you can easily spot a pattern of increased performance with each new version of PHP that is released. This is why it’s so important to test your site, plugins, etc. and stick to a regular upgrade schedule. Your visitors and customers will thank you as they expect speed!
*   If your hosting provider doesn’t offer newer versions of PHP, perhaps it’s time you think about moving.

We are super excited about PHP 7.2 and hope you are too! We would love to hear your thoughts regarding our benchmarks or even experiences you’ve had once upgrading. Drop them below in the comments.

---

This article was written by [Mark Gavalda](https://kinsta.com/blog/author/kinstadmin/). Mark has many years of experience leading teams in the fields of marketing, web design and development. As a dev guy he used his WP expertise to collect the know-hows of creating a reliable and customer friendly hosting company to satisfy the increasing demand of clients. He is an urban cyclist and autodidact who never stops learning new skills.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
