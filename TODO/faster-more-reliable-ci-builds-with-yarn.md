> * 原文地址：[Faster, More Reliable CI Builds with Yarn](https://medium.com/javascript-scene/faster-more-reliable-ci-builds-with-yarn-7dbc0ef31580#.8jbyo2k64)
* 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Faster, More Reliable CI Builds with Yarn


You may have heard of Yarn. It’s intended as a faster, more reliable alternative to the npm client. It’s nice to have packages install faster locally, but to really get the most from Yarn, you should also be using it with your continuous integration server.

When paired with a continuous integration server, Yarn can reduce the number of random CI failures that result from packages resolving differently for different installs.

Because slow installs and random CI failures can slow down your whole team, they have a multiplying drag effect on your team’s productivity. Random failures are even more frustrating than slow installs, because when something fails, you have to determine whether or not it was an intermittent bug, or the result of shifting packages. Easier said than done.

Yarn to the rescue!









![](https://cdn-images-1.medium.com/max/1600/1*m6zlwvyKm9BPeFQCKvGQEQ.png)





### Yarn is Not

*   A replacement for the npm registry

Yarn is not a replacement for the npm package registry. It is not a competing package library ecosystem. This is not a repeat of the Bower fiasco.

It’s a client that works with the npm package registry.

### Yarn Is

*   Faster installs.
*   Deterministic dependencies — with `yarn.lock`, you’ll get the same versions of the same packages installed in the same directory structure every time.

### Switching to Yarn

When Yarn was announced, I immediately understood that it could be valuable, but I waited a few days to hear from other people whether or not it lived up to the promise.

When word started getting around that it was working well for people, I decided to start using it in an app project.

#### Installing Yarn

The Yarn team recommends installing Yarn the same way you’d install a native app. **I recommend that you ignore their install documentation**.

There is no native Mac installer, so on Mac, they recommend Homebrew. Unless you used Homebrew to install Node (which I don’t recommend — use [nvm instead](https://github.com/creationix/nvm), to save a lot of headaches and easily switch between Node versions), **you should not use Homebrew to install Yarn**.

Homebrew will also install Node, which will relink the `node` and `npm` global commands to the Homebrew path and break your previous Node setup.

In addition to the dependency management problems with the Homebrew route, if you upgrade macOS to the latest version, it will break Homebrew by messing with the ownership of `usr/local`, so you’ll have that mess to sort out, too.

**Thankfully there’s a better option:**

    npm install -g yarn

Bonus: When you set up your CI server, you should have `npm` available there, too, so you can **use the same installer to install** `yarn` **everywhere you need it**.

Ironically, yes: I do recommend that you install a JavaScript package manager to install your new JavaScript package manager. I’m convinced that this is the real reason that the Yarn team recommends Homebrew for Mac installs. Mostly to avoid this slightly embarrassing irony. But trust me:

> `npm` is the easiest and best way for experienced JavaScript developers to install Yarn.

The Yarn team will tell you that the OS native package dependency manager is the best way because it can keep track of all your package dependencies. I can see that logic, but in practice, _it only holds up on Linux_. **Homebrew is not the native package dependency manager for macOS. It does not and should not manage all your app dependencies on Mac.**

Yarn’s chief dependency is Node, and **Homebrew is not the best way to install Node**. So why use Homebrew to manage Yarn dependencies?

Windows has its own story, which I’m less familiar with, so I won’t comment on how well their install instructions work for Windows users.

You know what does work on Mac, Windows, and Linux, though, with one set of instructions and none of the platform-specific headaches? **npm.**

### Using Yarn

These are the commands you need to memorize, in a nutshell:

**Add a dependency:**

`yarn add `

**Add a dev dependency:**

`yarn add --dev `

**Remove a dependency:**

`yarn remove `

**Install:**

`yarn` _(install is the default behavior)_









![](https://cdn-images-1.medium.com/max/1600/1*FdFjSsPAyHmg1nft-VuqSw.gif)





That’s all you need most of the time.

### The Lock File

Yarn pulls off its deterministic dependency magic using the `yarn.lock` file. It’s supposed to be an even more reliable form of `npm shrinkwrap`. The key difference is that npm’s installer algorithm is not deterministic, even shrinkwrapped. Yarn’s installer algorithm is deterministic. That means what gets installed on one machine, using the same lock file, will be exactly what gets installed on another machine.

> Don’t .gitignore yarn.lock. It is there to ensure deterministic dependency resolution to avoid “works on my machine” bugs.

In order for the lock file to work for you, **you must check it into git.**

### Setting Up Continuous Integration

As I mentioned in the install step, you can install yarn with `npm install -g yarn`, and that will work on most CI servers. Here’s an example `.travis.yml`for Travis-CI users:

    language: node_js
    node_js:
      - "6"
    env:
      - CXX=g++-4.8
    addons:
      apt:
        sources:
          - ubuntu-toolchain-r-test
        packages:
          - g++-4.8
    before_install:
      - npm install -g yarn --cache-min 999999999
    install:
      - yarn



### How Does Yarn Work in Reality?

If you’re curious about how much faster installs are, here are the numbers I pulled from my test app for from-scratch installs:

**Using npm:**

    $ time npm install
    0m30.193s

**Using Yarn:**

    $ time yarn
    0m44.835s

**_Oops!_**

Yarn’s primary selling point is that it’s supposed to be faster than npm, but in my testing with real projects, it’s actually _slower at installing all dependencies from scratch._

What about adding new dependencies?

**Using npm:**

    $ time npm install lodash
    0m6.204s

**Using Yarn:**

    $ time yarn add lodash
    0m2.948s

Okay, that’s more like it. I’m still concerned about the from-scratch install time, but for now, adding packages with yarn is roughly **twice as fast as npm**.

Clearly, there is room for improvement on from-scratch installs (which is what determines the speed of your CI install), but I’m satisfied for now.

Take this with a grain of salt, because these things can change from one OS to another, and one version patch to the next:

> Yarn adds new packages about twice as fast as npm.  
> Yarn is slower than npm at from-scratch installs.

### Conclusion

My experience with Yarn so far has been _mostly good._

I’m just starting to test it out in production, so I can’t speak confidently about its reliability yet, but I’m optimistic.

If it does work out as expected, Yarn could save your team a lot of time. So far I’ve had mixed results.

#### Should you be using Yarn?

It’s too early for me to say absolutely yes, but I’m going to give it an optimistic nod of approval. I’m rooting for the Yarn team to iron out the issues and improve it over time.