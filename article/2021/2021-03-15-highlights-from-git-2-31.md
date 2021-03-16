> * 原文地址：[Highlights from Git 2.31](https://github.blog/2021-03-15-highlights-from-git-2-31/)
> * 原文作者：[Taylor Blau](https://github.blog/author/ttaylorr/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/2021-03-15-highlights-from-git-2-31.md](https://github.com/xitu/gold-miner/blob/master/article/2021/2021-03-15-highlights-from-git-2-31.md)
> * 译者：
> * 校对者：

![](https://github.blog/wp-content/uploads/2021/03/git-2-31-0-release-banner.jpeg?fit=1200%2C630)

# Highlights from Git 2.31

The open source Git project [just released Git 2.31](https://lore.kernel.org/git/xmqqwnu8z03c.fsf@gitster.g/T/#u) with features and bug fixes from 85 contributors, 23 of them new. Last time [we caught up](https://github.blog/2020-10-19-git-2-29-released/) with you, Git 2.29 had just been released. Two versions later, let’s take a look at the most interesting features and changes that have happened since.

## Introducing `git maintenance`

Picture this: you’re at your terminal, writing commits, pulling from another repository, and pushing up the results when all of the sudden, you’re greeted by this unfriendly message:

Auto packing the repository for optimum performance. You may also
run "git gc" manually. See "git help gc" for more information.

…and, you’re stuck. Now you’ve got to wait for Git to finish running `git gc --auto` before you can get back to work.

What happened here? In the course of normal use, Git writes lots of data: objects, packfiles, references, and the like. Some of those paths are optimized for write performance. For example, it’s much quicker to **write** a [single “loose” object](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects), but it’s faster to read a [packfile](https://git-scm.com/book/en/v2/Git-Internals-Packfiles).

To keep you productive, Git makes a trade-off: in general, it optimizes for the write path while you’re working, pausing every so often to represent its internal data-structures in a way that is more efficient to read in order to keep you productive in the long-run.

Git has its own heuristics about when is a good time to perform this “pause,” but sometimes those heuristics trigger a blocking `git gc` at the worst possible time. You could manage these data-structures yourself, but you might not want to invest the time figuring out when and how to do that.

Starting in Git 2.31, you can get the best of both worlds with **background maintenance**. This cross-platform feature allows Git to keep your repository healthy while not blocking any of your interactions. In particular, this will improve your `git fetch` times by pre-fetching the latest objects from your remotes once an hour.

Getting started with background maintenance couldn’t be easier. Simply navigate your terminal to any repository you want to enable background maintenance on, and run the following:

```bash
$ git maintenance start
```

…and Git will take care of the rest. Besides pre-fetching the latest objects once an hour, Git will make sure that [its own data](https://github.blog/2020-12-17-commits-are-snapshots-not-diffs/) is organized, too. It will update its [`commit-graph` file](https://devblogs.microsoft.com/devops/updates-to-the-git-commit-graph-feature/) once an hour, and pack any loose objects (as well as incrementally repack packed objects) nightly.

Read more about this feature in [the `git maintenance` documentation](https://git-scm.com/docs/git-maintenance) and learn how to customize it with [`maintenance.* config` options](https://git-scm.com/docs/git-config#Documentation/git-config.txt-maintenanceauto). If you have any trouble, you can check the [troubleshooting documentation](https://git-scm.com/docs/git-maintenance#_troubleshooting).

\[[source](https://github.com/git/git/compare/e1cfff676549cdcd702cbac105468723ef2722f4...25914c4fdeefd99b06e134496dfb9bbb58a5c417), [source](https://github.com/git/git/compare/26bb5437f6defed72996b6a2bb1ff9121ec297ff...e841a79a131d8ce491cf04d0ca3e24f139a10b82), [source](https://github.com/git/git/compare/c042c455d4ffb9b5ed0c280301b5661f3efad572...0016b618182f642771dc589cf0090289f9fe1b4f), [source](https://github.com/git/git/compare/4151fdb1c76c1a190ac9241b67223efd19f3e478...3797a0a7b7aa8d0abd1b7ff7b95a40a9739d9278)\]

## On-disk reverse indexes

You may know that Git stores all data as “objects:” commits, trees, and blobs which store the contents of individual files. For efficiency, Git puts many objects into packfiles, which are essentially a concatenated stream of objects (this same stream is also how objects are transferred by `git fetch` and `git push`). In order to efficiently access individual objects, Git generates an index for each packfile. Each of these `.idx` files allows quick conversion of an object id into its byte offset within the packfile.

What happens when you want to go in the other direction? In particular, if all Git knows is what byte it’s looking at in some packfile, how does it go about figuring out which object that byte is part of?

To accomplish this, Git uses an aptly-named **reverse index**: an opaque mapping between locations in a packfile, and the object each location is a part of. Prior to Git 2.31, there was no on-disk format for reverse indexes (like there is for the `.idx` file), and so it had to generate and store the reverse index in memory each time. This roughly boils down to generating an array of object-position pairs, and then sorting that array by position (for the curious, the exact details can be found [here](https://github.com/git/git/blob/v2.31.0/pack-revindex.c#L26-L177)).

But this takes time. In the case of repositories with large packfiles, this can take a lot of time. To better understand the scale, consider an experiment which compares the time it takes to print the size of an object, versus the time it a takes to print that object’s contents. To simply print an object’s contents, Git uses the forward index to locate the desired object in a pack, and then it reassembles and prints out its contents. But to print an object’s **size** in a packfile, Git needs to locate not just the object we want to measure, but the object immediately following it, and then subtract the two to find out how much space it’s using. To find the position of the first byte in the adjacent object, Git needs to use the reverse index.

Comparing the two, it is more than **62 times slower** to print the size of an object than it is to print that entire object’s contents. You can try this at home with [hyperfine](https://github.com/sharkdp/hyperfine) by running:

```bash
$ git rev-parse HEAD >tip
$ hyperfine --warmup=3 \
  'git cat-file --batch <tip' \
  'git cat-file --batch-check="%(objectsize:disk)" <tip'
```

In 2.31, Git gained the ability to serialize the reverse index into a new, on-disk format with the `.rev` extension. After generating an on-disk reverse index and repeating the above experiment, our results now show that it takes roughly the same amount of time to print an object’s contents as it does its size.

Observant readers may ask themselves why Git even needs to bother using a reverse index. After all, if you can print the contents of an object, then surely printing that object’s size is no more difficult than knowing how many bytes you wrote when printing the contents. But, this depends on the size of the object. If it’s enormous, then counting up all of its bytes is much more expensive than simply subtracting.

Reverse indexes can help beyond synthetic experiments like these: when sending objects for a fetch or push, the reverse index is used to send object bytes directly from disk. Having a reverse index computed ahead of time makes this process run faster.

Git doesn’t generate `.rev` files by default yet, but you can experiment with them yourself by running `git config pack.writeReverseIndex true`, and then repacking your repository (with `git repack -Ad`). We have been using these at GitHub for the past couple of months to enable dramatic improvements in many different Git operations.

\[[source](https://github.com/git/git/compare/381dac23491ee3d80e00787449f0f1c70449419c...779412b9d99544ae71eefabb699a109b1638f96c), [source](https://github.com/git/git/compare/2c873f97913994f8478a9078ff8b62e17378a0ed...6885cd7dc573b1750b8d895820b8b2f56285f070)\]

## Tidbits

* We’ve talked on this blog before about the `commit-graph` file. It’s an incredibly useful serialization of common information about commits, like which parents they have, what their root tree is, and so on. (For a more detailed exposition, the blog post series beginning [here](https://devblogs.microsoft.com/devops/supercharging-the-git-commit-graph/) is a great exposition). Commit graphs also store information about a commit’s [**generation number**](https://devblogs.microsoft.com/devops/supercharging-the-git-commit-graph-iii-generations/), which can be used to accelerate many kinds of commit walks. In Git 2.31, a new kind of generation number was used, which can improve performance further in certain situations.These patches were contributed by [Abhishek Kumar](https://abhishekkumar2718.github.io/), a [Google Summer of Code](https://summerofcode.withgoogle.com/) student.
    
    \[[source](https://github.com/git/git/compare/328c10930387d301560f7cbcd3351cc485a13381...5a3b130cad0d5c770f766e3af6d32b41766374c0)\]
    
* In recent versions of Git, it has become easier to change the default name for the main branch in a new repository with [the `init.defaultBranch` configuration](https://git-scm.com/docs/git-config#Documentation/git-config.txt-initdefaultBranch). Git has always tried to check out the branch at the `HEAD` of your remote (i.e., if the remote’s default branch was “`foo`“, then `git clone` would try to checkout `foo` locally), but this hasn’t worked with empty repositories.In Git 2.31, this now works with empty repositories, too. Now if you are cloning a newly-created repository locally to start writing the first patches, your local copy will respect the default branch name set by the remote, even if there aren’t any commits yet. \[[source](https://github.com/git/git/compare/0871fb9af5aa03a56c42a9257589248624d75eb8...4f37d45706514a4b3d0259d26f719678a0cf3521)\]
    
* On the topic of renaming things, Git 2.30 makes it easier to change the name of another default: a repository’s first remote. When `git clone`-ing a repository, the first remote initialized is always named “origin”.Prior to Git 2.30, your options for renaming this were limited to running `git remote rename origin <newname>`. Git 2.30 allows you to configure a different name to be chosen by default, instead of always using “origin”. To give it a try for yourself, set the `clone.defaultRemoteName` configuration. \[[source](https://github.com/git/git/compare/de0a7effc86aadf6177fdcea52b5ae24c7a85911...de9ed3ef3740f8227cc924e845032954d1f1b1b7)\]
    
* When a repository grows large, it can be hard to figure out which branches are responsible. In Git 2.31, `git rev-list` now has a [`--disk-usage`](https://git-scm.com/docs/git-rev-list#Documentation/git-rev-list.txt---disk-usage) option which is both simpler and faster than using the existing tools to sum up object sizes. The [examples section](https://git-scm.com/docs/git-rev-list#_examples) of the `rev-list` manual shows off some uses (and check out the source link below for timings and to see the “old” way of doing it). \[[source](https://github.com/git/git/commit/16950f8384afa5106b1ce57da07a964c2aaef3f7)\]
    
* You may have used Git’s `-G<regex>` option to find commits which modified a line that mentions a particular string (e.g., `git log -G'foo\('` will look for changes that added, removed, or modified calls to the `foo()` function). But you may also want to **ignore** lines matching a certain pattern. Git 2.30 introduces `-I<regex>`, which lets you ignore changes in lines matching a regular expression. For instance, `git log -p -I'//'` would show the patch for each commit, but omit any hunks that only touched comment lines (those containing `//`). \[[source](https://github.com/git/git/commit/296d4a94e7231a1d57356889f51bff57a1a3c5a1)\]
    
* In preparation for replacing the merge backend, rename detection has been substantially optimized. You can read more about these changes from their author in [Optimizing git’s merge machinery, #1](https://medium.com/palantir/optimizing-gits-merge-machinery-1-127ceb0ef2a1), and [Optimizing git’s merge machinery, #2](https://medium.com/palantir/optimizing-gits-merge-machinery-2-d81391b97878).

That’s just a sample of changes from the last couple of releases. For more, check out the release notes for [2.30](https://github.com/git/git/blob/v2.31.0/Documentation/RelNotes/2.30.0.txt) and [2.31](https://github.com/git/git/blob/v2.31.0/Documentation/RelNotes/2.31.0.txt), or [any previous version](https://github.com/git/git/tree/v2.31.0/Documentation/RelNotes) in the [Git repository](https://github.com/git/git).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
