> * 原文地址：[5 things you can do with Yarn](https://auth0.com/blog/five-things-you-can-do-with-yarn/)
* 原文作者：[Prosper Otemuyiwa](https://twitter.com/unicodeveloper?lang=en)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# 5 things you can do with Yarn

There are several package managers in the JavaScript land: **npm**, **bower**, **component**, and **volo**, to name a few. As of this writing, the most popular JavaScript package manager is **npm**. The npm client provides access to hundreds of thousands of code libraries in the npm registry. Just recently, Facebook launched a new package manager for JavaScript called **Yarn**, which claims to be faster, more reliable, and more secure than the existing npm client. In this article, you will learn five things you can do with Yarn.

**Yarn** is a new package manager for JavaScript created by Facebook. It offers a fast, highly reliable, and secure dependency management for developers using JavaScript in their apps. Here are five things you can do with Yarn.

## 1\. Work Offline

Yarn offers you the ability to work in offline mode. If you have installed a package before, you can install it again without an internet connection. A typical example is shown below:

When connected to the internet, I installed two packages with Yarn like so:

![Yarn init](https://cdn.auth0.com/blog/blog/yarn-int.png) _Create a package.json with yarn init_

![Install express and jsonwebtoken packages with Yarn](https://cdn.auth0.com/blog/blog/yarn-add-packages.png) _Install express and jsonwebtoken packages with yarn_

![Installation complete with Yarn](https://cdn.auth0.com/blog/blog/yarn-completed-install.png) _Installation complete_

After the installation was complete, I went ahead and deleted the _node_modules_ inside my _orijin_ directory and also disconnected from the Internet. I ran Yarn like so:

![Installing packages offline with Yarn](https://cdn.auth0.com/blog/blog/yarn-install-offline.png) _Yarn installed the packages offline_

Voilá! All the packages were installed again in less than two seconds. Apparently, Yarn caches every package it downloads so it never needs to do so again. It also maximizes resource utilization by parallelizing operations so that install times are faster than ever.

## 2\. Install from Multiple Registries

Yarn offers you the ability to install JavaScript packages from multiple registries, such as [npm](https://www.npmjs.com/), [bower](https://bower.io/), your git repository, and even your local file system.

By default, it scans the npm registry for your package as follows:

    yarn add <pkg-name>

Install a package from a remote gzipped tarball file as follows:

    yarn add <https://thatproject.code/package.tgz>

Install a package from your local file system as follows:

    yarn add file:/path/to/local/folder

This is particularly helpful for developers who constantly publish JavaScript packages. You can use this to test your packages before publishing them to a registry.

Install a package from a remote git repository like so:

    yarn add <git remote-url>

![Yarn installs from a Github Repo](https://cdn.auth0.com/blog/blog/yarn-add-gitrepo.png) _Yarn installs from a Github repo_

![Yarn detects that a Github Rep exists as a package in the bower registry](https://cdn.auth0.com/blog/blog/yarn-add-bowercomp.png) _Yarn also automatically detects that the git repo exists as a package in the bower registry and treats it as such_

## 3\. Fetch Packages Speedily

If you have used **npm** for a while, you must have had experiences where you had to run `npm install`, then go watch a movie, and come back to check whether all the packages you required are finished installing. Well, maybe not that long, but it takes a lot of time to traverse the dependency tree and pull dependencies in. With Yarn, installation time has really been cut down from having to wait several minutes to package installs happening in seconds.

Yarn efficiently queues up requests and avoids request waterfalls to maximize network utilization. It starts by making requests to the registry and recursively looking up each dependency. Next, it looks in a global cache directory to see whether the package has been downloaded before. If it hasn't, Yarn fetches the tarball package and places it in the global cache to enable it to work offline and eliminate the need to re-download.

During install, Yarn parallelizes operations, which makes the install process faster. I did a fresh install of three packages, **jsonwebtoken**, **express** and **lodash**, using **npm** and **yarn**. After _Yarn_ was finished installing them, _npm_ was still installing.

![Comparison of Yarn and Npm](https://cdn.auth0.com/blog/blog/yarn-npm-compare.png)

## 4\. Lock Package Versions Automatically

Npm has a feature called **shrinkwrap**, which is intended to lock down your package dependencies for production use. The challenge with **shrinkwrap** is that every developer has to manually run `npm shrinkwrap` to generate the `npm-shrinkwrap.json` file. Developers are also humans; we can forget!

With Yarn, it's a different ball game. During installation, a `yarn.lock` file is generated automatically. It is similar to the `composer.lock` file that PHP developers are familiar with. The `yarn.lock` file locks down the exact versions of the packages that have been installed and all their dependencies. With this file, you can be certain that every member of your engineering team have the exact package versions installed and deployments can easily be reproduced without unexpected bugs.

## 5\. Install Dependencies the Same Way across Machines

The **npm client** installs dependencies in a way that can make the structure of the contents of _Developer A_ `node_modules` directory different from _Developer B_. It uses a non-deterministic approach to install these package dependencies. This approach is sometimes responsible for bugs that can't be easily reproduced because of the popular _works on my system_ problem.

With Yarn, the presence of a lock file and an install algorithm ensures that the dependencies installed produce the exact same file and folder structure across development machines and when deploying applications to production.

**Note:** One more thing, I know I promised five but I can't help tell you how good **Yarn** makes me feel. Enterprise environments require the ability to be able to list a dependencies' license type. Yarn offers the ability to list the license type for a given dependency by running `yarn licences ls` in your root directory as follows:

![Yarn Licenses](https://cdn.auth0.com/blog/licenses.png)

## Conclusion

Yarn in its infancy has already brought significant improvements in the way JavaScript packages are fetched from global registries into local environments, especially with regard to speed and security. Will it grow to become the most popular choice among JavaScript developers? Have you switched yet? What are your thoughts about Yarn? Let me know in the comments section! 😊



