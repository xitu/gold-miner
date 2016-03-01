> * 原文链接: [Introducing Swift 3.0](http://dev.iachieved.it/iachievedit/)
* 原文作者 : [ Joe](http://dev.iachieved.it/iachievedit/author/admin/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 认领中


[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://swift.org/)

If you’re looking for Swift 2.2 Ubuntu packages, see our instructions [here](http://dev.iachieved.it/iachievedit/ubuntu-packages-for-open-source-swift/).

### Swift 3.0

Swift 2.2 has branched off of `master` onto a `swift-2.2` branch. At that point the `master` branch of the Swift repositories became the development branch for version 3.0 of the language. The instructions for cloning all of the source code required for a complete Swift build has changed for 3.0\. Rather than cloning each repository one at a time you can:

    mkdir swift-build
    cd swift-build
    git clone https://github.com/apple/swift.git 
    ./swift/utils/update-checkout --clone

The `update-checkout` script in the `swift` repository is capable of cloning all of the repositories required for a build and placing them into a `.tar.gz` archive file.

We use the “build and package” preset to not only build all of the required targets, but to package them nicely into a `.tar.gz` archive file. This is accomplished through a script (available in our `package-swift` repo) called `package.sh`:

    #!/bin/bash
    pushd `dirname $0` > /dev/null
    WHERE_I_AM=`pwd`
    popd > /dev/null
    INSTALL_DIR=${WHERE_I_AM}/install
    PACKAGE=${WHERE_I_AM}/swift.tar.gz
    LSB_RELEASE=`lsb_release -rs  | tr -d .`
    rm -rf $INSTALL_DIR $PACKAGE
    ./swift/utils/build-script --preset=buildbot_linux_${LSB_RELEASE} install_destdir=${INSTALL_DIR} in

The key thing in this script is detecting the Ubuntu release (`lsb_release -rs`) and using the `buildbot_linux_${LSB_RELEASE}` preset to build and package everything to the `${PACKAGE}` `.tar.gz` file.

### apt-get

Downloading a `.tar.gz` from Apple is nice. Using `apt-get` on an Ubuntu distribution is even better. To make it is easy to get started with Swift on Linux, we’ve provided an Ubuntu repository that you can obtain the latest Swift packages from.

At the moment we’re providing both `swift-3.0` and `swift-2.2` packages, and they are _not_ compatible. For example, both packages install to `swift` to `/usr/bin`. Until we take the time to separate the installations out this will be the case. The plan is to provide this at a later date, perhaps mid-2016.

With the restrictions and limitations out of the way, let’s get on with looking at how to get Swift 3.0!

**1\. Add the repository key**

    wget -qO- http://dev.iachieved.it/iachievedit.gpg.key | sudo apt-key add -

**2\. Add the appropriate repository to `sources.list`**

**Ubuntu 14.04**

    echo "deb http://iachievedit-repos.s3.amazonaws.com/ trusty main" | sudo tee --append /etc/apt/sources.list

**Ubuntu 15.10**

echo "deb http://iachievedit-repos.s3.amazonaws.com/ wily main" | sudo tee --append /etc/apt/sources.list

**3\. Run `apt-get update`**

```
sudo apt-get update
```

**4\. Install swift-3.0!**

```
apt-get install swift-3.0
```

**5\. Try it out**

    git clone https://github.com/apple/example-package-dealer
    cd example-packager-dealer
    swift build
    Compiling Swift Module 'FisherYates' (1 sources)
    Linking Library:  .build/debug/FisherYates.a
    Compiling Swift Module 'PlayingCard' (3 sources)
    Linking Library:  .build/debug/PlayingCard.a
    Compiling Swift Module 'DeckOfPlayingCards' (1 sources)
    Linking Library:  .build/debug/DeckOfPlayingCards.a
    Compiling Swift Module 'Dealer' (1 sources)
    Linking Executable:  .build/debug/Dealer

Run it!

```
.build/debug/Dealer
```

## FAQ

**Q.** Did Apple build these binaries?  
**A.** No, I built them on my personal server using the instructions I posted [here](http://dev.iachieved.it/iachievedit/keeping-up-with-open-source-swift/).

**Q.** What git revisions are included in the build?  
**A.** You can use `apt-cache show swift-3.0` to see this information. For example:

    # apt-cache show swift-3.0
    Package: swift-3.0
    Status: install ok installed
    Priority: optional
    Section: development
    Installed-Size: 281773
    Maintainer: iachievedit (support@iachieved.it)
    Architecture: amd64
    Version: 1:3.0-0ubuntu2
    Depends: clang (&gt;= 3.6), libicu-dev
    Conflicts: swift-2.2
    Description: Open Source Swift
     This is a packaged version of Open Source Swift 3.0 built from
     the following git revisions of the Apple Github repositories:
           Clang:  c18bb21a04
            LLVM:  0d07a5d3d5
           Swift:  8aa4dadf92
      Foundation:  dc4fa2d80b
    Description-md5: 08508c39657c159d064917af87d8d411
    Homepage: http://dev.iachieved.it/iachievedit/swift

The source tree is _untouched_ for each build.

**Q.** Do you test the binaries before you upload them?  
**A.** The Swift build process tests the resulting binaries, and I then do run some basic tests and compile my own applications, but there is currently no separate exhaustive test suite.

**Q.** Are you releasing builds on a set schedule?  
**A.** Not really, though I may try to stay in sync with the releases from Apple. The idea was to get something out for folks to experiment with and start coding Swift on Linux.

**Q.** Where is everything installed?  
**A.** Everything gets put in `/usr`, just like installing `clang`, `gcc`, etc.

**Q.** How do I decipher the package version number?  
**A.** This was my first take on what I thought should be an appropriate package version number. Breaking it down, `3.0-0ubuntu2~trusty1` should be:

*   3.0 is the version of Swift that is packaged
*   -0ubuntu2 indicates that this is the 2nd package for Ubuntu, with the 0 indicating that there is no upstream Debian package upon which this package was based
*   ~trusty1 indicates that this package is for Trusty Tahr

Wily packages do not contain anything like `~wiley1` in their version number such that an upgrade from Trusty to Wiley would automatically upgrade your `swift-3.0` package correctly.

I _think_ I got that right, but if you feel otherwise please do drop me a line at `support@iachieved.it`.

## How Does This Work?

I used [these awesome instructions](http://xn.pinkhamster.net/blog/tech/host-a-debian-repository-on-s3.html) on how to host a Debian package repository on Amazon S3\. I tried to set up a Launchpad PPA, but quite frankly, got tired of trying to wade through all the metadata required to put together a simple package. I’m sure for hosting distribution repositories it’s all required, but for this it felt like overkill. The folks that develop [fpm](https://github.com/jordansissel/fpm) also have some choice things to say about it.

The packaging scripts we use to build everything and upload to the repository can be found [Github](https://github.com/iachievedit/package-swift). For Swift 3.0 make sure and look at the `swift-3.0` branch.
