> * 原文地址：[5 Best Practices To Prevent Git Leaks](https://levelup.gitconnected.com/5-best-practices-to-prevent-git-leaks-4997b96c1cbe)
> * 原文作者：[Coder’s Cat](https://medium.com/@coderscat)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-best-practices-to-prevent-git-leaks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-best-practices-to-prevent-git-leaks.md)
> * 译者：
> * 校对者：

# 5 Best Practices To Prevent Git Leaks

![Photo by Clint Patterson on Unsplash](https://cdn-images-1.medium.com/max/4000/0*bskmb4Tr98q5if_y.jpg)

Countless developers are using Git for version control, but many don’t have enough knowledge about how Git works. Some people even use Git and Github as tools for backup files. This leads to information disclosure in Git repositories. [Thousands of new API or cryptographic keys leak via GitHub projects every day.](https://www.zdnet.com/article/over-100000-github-repos-have-leaked-api-or-cryptographic-keys/)

I have been working in the field of information security for three years. About two years ago, our company had a severe security issue triggered by the information leak in a Git repository.

An employee accidentally leaked an AWS key to Github. The attacker used this key to download more sensitive data from our servers. We put a lot of time into fixing this issue, we tried to find out how much data leaked, analyzed the affected systems and related users, and replaced all the leaked keys in systems.

It is a sad story that any company and developer would not want to experience.

I won’t write more details about it. Instead, I hope more people know how to avoid it. Here are my suggestions for you to keep safe from Git leaks.

## Build security awareness

Most junior developers don’t have enough security awareness. Some companies will train new employees, but some companies don’t have systematic training.

As a developer, we need to know which kind of data may introduce security issues. Remember these categories of data can not be checked into Git repository:

1. Any configuration data, including password, API keys, AWS keys, private keys, etc.
2. [Personally Identifiable Information](https://en.wikipedia.org/wiki/Personal_data) (PII). According to GDPR, if a company leaked the users’ PII, the company needs to notify users, relevant departments and there will be more legal troubles.

If you are working for a company, don’t share any source code or data related to the company without permission.

Attackers can easily find some code with a company copyright on GitHub, which was accidentally leaked to Github by employees.

My advice is, try to distinguish between company affairs and personal stuff strictly.

## Use Git ignore

When we create a new project with Git, we must set a **.gitignore** properly. **gitignore** is a Git configuration file that lists the files or directories that will not be checked into the Git repository.

This project’s [gitignore](https://github.com/github/gitignore) is a collection of useful .gitignore templates, with all kinds of programming language, framework, tool or environment.

We need to know the pattern matching rules of **gitignore** and add our own rules based on the templates.

![](https://cdn-images-1.medium.com/max/2000/0*VmEolB6qYNCYr9Wf.png)

## Check commits with Git hooks and CI

No tools could find out all the sensitive data from a Git repository, but a couple of tools and practices can help.

[git-secrets](https://github.com/awslabs/git-secrets) and [talisman](https://github.com/thoughtworks/talisman) are similar tools, they are meant to be installed in local repositories as [pre-commit hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks). Every change will be checked before committed, pre-commit hooks will reject the commit if they detect a prospective commit may contain sensitive information.

[gitleaks](https://github.com/zricethezav/gitleaks) provides another way to find unencrypted secrets and other unwanted data types in git repositories. We could integrate it into automation workflows such as CICD.

## Code review

Code review is a best practice for team working. All the teammates will learn from each other’s source code. Junior developer’s code should be reviewed by developers with more experience.

Most unintended changes can be found out during the code review stage.

[Enabling branch restrictions](https://help.github.com/en/github/administering-a-repository/enabling-branch-restrictions) can enforce branch restrictions so that only certain users can push to a protected branch in repositories. Gitlab has a similar option.

Setting master to a restricted branch helps us to enforce the code review workflow.

![](https://cdn-images-1.medium.com/max/2208/0*RUqDCQlDgym-Jo8x.png)

## Fix it quickly and correctly

With all the above tools and mechanisms, errors still could happen. If we fix it quickly and correctly, the leak may introduce no actual security issue.

If we find some sensitive data leaked in the Git repository, we can not just make another commit to clean up.

![This fix is self-deception](https://cdn-images-1.medium.com/max/2000/0*FsGBhHSlXdeSpTk4.png)

What we need to do is remove all the sensitive data from the entire Git history.

**Remember to backup before any cleanup, and then remove the backup clone after we confirmed everything is OK**.

Use the `--mirror` to clone a bare repository; this is a full copy of the Git database.

```bash
git clone --mirror git://example.com/need-clean-repo.git
```

We need **git filter-branch** to remove data from all branches and commit histories. Suppose we want to remove `./config/passwd` from Git:

```bash
$ git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch ./config/password' \
  --prune-empty --tag-name-filter cat -- --all
```

Remember to add the sensitive file to .gitignore:

```bash
$ echo "./config/password" >> .gitignore
$ git add .gitignore
$ git commit -m "Add password to .gitignore"
```

Then we push all branches to remote:

```bash
$ git push --force --all
$ git push --force --tags
```

Tell our collaborators to rebase:

```bash
$ git rebase
```

[BFG](https://rtyley.github.io/bfg-repo-cleaner/) is a faster and simpler alternative to **git filter-branch** for removing sensitive data. It’s usually 10–720x faster than **git filter-branch**. Except for deleting files, BFG could also be used to replace secrets in files.

BFG will leave the latest commit untouched. It’s designed to protect us from making mistakes. We should explicitly delete the file, commit the deletion, then clean up the history to remove it.

If the leaked Git repository is forked by others, we need to follow the [DMCA Takedown Policy](https://help.github.com/en/github/site-policy/dmca-takedown-policy#c-what-if-i-inadvertently-missed-the-window-to-make-changes) to ask Github to remove the forked repositories.

The whole procedure requires some time to finish, but it’s the only way to remove all the copies.

## Conclusion

Don’t make the same mistake that countless people have made. Try to put some effort to avoid safety accidents.

Use these tools and strategies will help much in avoiding Git leaks.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
