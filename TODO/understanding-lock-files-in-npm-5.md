> * 原文地址：[Understanding lock files in NPM 5](http://jpospisil.com/2017/06/02/understanding-lock-files-in-npm-5.html)
> * 原文作者：[Jiří Pospíšil](https://twitter.com/JiriPospisil)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Understanding lock files in NPM 5

The next major version of NPM brings a number of improvements over the previous versions in terms of speed, security, and a bunch of other [nifty things](//blog.npmjs.org/post/161276872334/npm5-is-now-npmlatest). What stands out from the user’s perspective however is the new lock file. Actually lock *files*. More on that in a second. For the uninitiated, a `package.json` file describes the top level dependencies on other packages using [semver](//semver.org/). Each package might in turn depend on other packages and so on and so forth. A lock file is a snapshot of the entire dependency tree and includes all packages and their resolved versions.

As opposed to the previous version, the lock file now includes an integrity field which uses [Subresource Integrity](https://w3c.github.io/webappsec-subresource-integrity/) to verify that the installed package has not been tempered with or is otherwise invalid. It currently supports SHA-1 for packages published with an older version of NPM and SHA-512 which is used from now on by default.

What the file now *doesn’t* have is the `from` field which together with the sometimes inconsistent `version` has notoriously been a source of pain when looking at the file’s diff during code reviews. It should be much cleaner now.

The file now also contains a version of the lock format specified in `lockfileVersion` and set to `1`. This is to enable future updates of the format without having to guess what particular version the file uses. The previous lock format is still supported and recognized as version `0`.


```
{
  "name": "package-name",
  "version": "1.0.0",
  "lockfileVersion": 1,
  "dependencies": {
    "cacache": {
      "version": "9.2.6",
      "resolved": "https://registry.npmjs.org/cacache/-/cacache-9.2.6.tgz",
      "integrity": "sha512-YK0Z5Np5t755edPL6gfdCeGxtU0rcW/DBhYhYVDckT+7AFkCCtedf2zru5NRbBLFk6e7Agi/RaqTOAfiaipUfg=="
    },
    "duplexify": {
      "version": "3.5.0",
      "resolved": "https://registry.npmjs.org/duplexify/-/duplexify-3.5.0.tgz",
      "integrity": "sha1-GqdzAC4VeEV+nZ1KULDMquvL1gQ=",
      "dependencies": {
        "end-of-stream": {
          "version": "1.0.0",
          "resolved": "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.0.0.tgz",
          "integrity": "sha1-1FlucCc0qT5A6a+GQxnqvZn/Lw4="
        },
```

You might have noticed that the `resolved` field is still present in the file pointing to a specific URI. Note however that NPM is now able to figure out (based on the settings in `.npmrc`) that the machine is configured to use a different registry and if so, it will transparently use it instead. This plays well with the integrity field because it now doesn’t matter from where the package came from as long as it matches the signature.

One more thing worth mentioning is that the lock file precisely describes the physical tree of directories as laid out in the `node_modules` directory. The advantage of that is that even if different developers use a different version of NPM, they should still end up with not only the same versions of dependencies but also with the exact same directory tree. This is different from other package managers such as [Yarn](https://yarnpkg.com/en/). Yarn describes just the dependencies between the individual packages in a [flatten format](https://github.com/yarnpkg/yarn/blob/46750b2bebd487fb2d2011b9c4b7646ec6e2d8a3/yarn.lock) and relies on its current implementation to create the directory structure. This means that if its internal algorithm changes, the structure changes as well. If you want to know more about the differences between Yarn and NPM 5 when it comes to the lock file, head over to [Yarn determinism](https://yarnpkg.com/blog/2017/05/31/determinism/).

## Two lock files

I’ve mentioned that there’s actually more than one lock file now, sort of. NPM will now *automatically* generate a lock file called `package-lock.json` whenever a new dependency is installed or the file doesn’t yet exist. As mentioned at the beginning, the lock file is a snapshot of the current dependency tree and allows for reproducible builds between machines. As such, it’s recommended to add it to your version control.

You might be thinking that the same can already be achieved with `npm shrinkwrap` and its `npm-shrinkwrap.json`. And you are right. The reasoning for creating a new file is to better convey the message that NPM indeed supports locking which apparently has been an issue in the past.

There are however a few differences. First, NPM enforces that `package-lock.json` is never published. Even if you add it explicitly to the package’s `files` property, it will not be a part of the published package. The same doesn’t apply for the `npm-shrinkwrap.json` file however which *can* be a part of a published package and NPM will respect it even for nested dependencies. It’s simple to try it out for yourself by running `npm pack` and seeing what’s inside of the produced archive.

Next, you might be wondering what happens when you run `npm shrinkwrap` in a directory which already contains a `package-lock.json`. The answer is rather simple, NPM will just rename `package-lock.json` to `npm-shrinkwrap.json`. That’s possible because the format of the files is exactly the same.

The most curious will also ask what happens when both of the files are present. In that case, NPM will completely ignore `package-lock.json` and just use `npm-shrinkwrap.json`. The situation should not happen however when manipulating the files just using NPM.

### To summarize:

- NPM will automatically create a `package-lock.json` when installing packages unless there’s already `npm-shrinkwrap.json` in which case it will update it instead (if necessary).

- The new `package-lock.json` is never published and should be added to your version control system.

- Running `npm shrinkwrap` with a `package-lock.json` already present will just rename it to `npm-shrinkwrap.json`.

- When both files are present for some reason, `package-lock.json` will be ignored.

That’s all cool but when do you use the new lock file instead of the good old shrinkwrap or vice versa? It generally depends on the type of package you’re working on.

## When working on a library

If you’re working on a library (as in a package onto which others will depend on), you should use the new lock file. An alternative is to use shrinkwrap but make sure it never gets published with the package (the new lock file is never published automatically). Why not publish the shrinkwrap? It’s because NPM respects shrinkwraps it finds within packages and since a shrinkwrap always points to a specific version of individual packages, you would not take advantage of the fact that NPM can use the same package to satisfy requirements from multiple packages if the [semver](//semver.org) range allows it. In other words, by not forcing NPM to install specific versions, you allow NPM to better reuse packages across the dependency tree and make the result smaller and faster to assemble.

There’s one caveat to this however. When you’re working on your library, you get the exact same dependencies every time because either `package-lock.json` or `npm-shrinkwrap.json` is present in the repository. The same goes for your continuous integration server where you check out the same code. Now imagine your `package.json` specifies a dependency on some package as `^1.0.0` and that also happens to be the version specified in the lock file and installed every time. Everything works. Now what happens if a new version of the dependency is published, accidentally breaks semver and your package breaks because of it?

Unfortunately, you might not be able to notice that until a bug report comes in. Without any lock files in the repository, your build would fail at least on the CI because it would always install the `latest` versions of the dependencies and thus run the tests with the new broken version (provided that the build is run periodically, not just for PRs). With the lock in place however, it will always install the working locked version.

There’s a couple of solutions to this problem however. First, you could sacrifice the exact reproducibility and *not* add the lock file to your version control system. Second, you could make a separate build configuration which would run `npm update` prior running the tests. Third, you simply delete the lock before running the tests in the special build. How to actually deal with the broken dependency once discovered is another topic on its own mainly because semver as implemented by NPM doesn’t have a concept of allowing a wide range but also blacklisting specific versions.

This of course begs the question whether it’s actually worth it to add the lock file into the version control when working on libraries. A thing to keep in mind however is that the lock file contains not only dependencies but also *dev* dependencies. In that sense working on a library is similar to working on an application (see the next section) and having the exact same dev dependencies over time and across multiple machines is an advantage.

## When working on an application

Alright, what about packages used by the end users in the terminal or bundled executables in general? In this case, the package is the final result, the application, and you want to make sure that the end users always get the exact dependencies you had while publishing it. This is where you want to use shrinkwrap and make sure to also publish it with the package so that it’s respected by NPM during install. Remember, you can always see what the package would look like if published using `npm pack`.

Note that pointing to a specific version of a dependency in `package.json` is not good enough because you want to make sure the end users get the *exact* same dependency tree including all of its sub-dependencies. A specific version in `package.json` guarantees the version only at the top level.

What about other types of applications, for example projects you start from within their repository? It doesn’t really matter that much in this case. All that matters is that the correct dependencies are installed and both of the locks can satisfy that. Your choice.

## That’s a wrap

And that about wraps it up for now. Feel free to reach out on Twitter if something’s not right or with some general suggestions. If you’ve found a typo or some other grammar issue, the blog post is available on [GitHub](https://github.com/jiripospisil/jpospisil.com). Any help is appreciated!

If you've enjoyed the article, you should follow [@JiriPospisil](https://twitter.com/JiriPospisil) on Twitter and subscribe via [feed](/feed.xml).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
