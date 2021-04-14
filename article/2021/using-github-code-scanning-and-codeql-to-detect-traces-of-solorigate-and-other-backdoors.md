> * 原文地址：[Using GitHub code scanning and CodeQL to detect traces of Solorigate and other backdoors](https://github.blog/2021-03-16-using-github-code-scanning-and-codeql-to-detect-traces-of-solorigate-and-other-backdoors/)
> * 原文作者：[Bas van Schaik](https://github.blog/author/sjgithub/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-github-code-scanning-and-codeql-to-detect-traces-of-solorigate-and-other-backdoors.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-github-code-scanning-and-codeql-to-detect-traces-of-solorigate-and-other-backdoors.md)
> * 译者：
> * 校对者：

# Using GitHub code scanning and CodeQL to detect traces of Solorigate and other backdoors

Last month, a member of the CodeQL security community contributed [multiple CodeQL queries](https://github.com/github/codeql/pull/5083) for C# codebases that can help organizations assess whether they are affected by the SolarWinds nation-state attack on various parts of critical network infrastructure around the world. This attack is also referred to as [Solorigate](http://aka.ms/solorigate) (by Microsoft), or Sunburst (by FireEye). In this blog post, we’ll explain how GitHub Advanced Security customers can use these CodeQL queries to establish whether their build infrastructure is infected with the malware.

## What happened?

Early December 2020, a security consultancy firm, FireEye, published details of a nation-state attack on SolarWinds, a company that provides network monitoring tools to various organisations, including the US government. As part of the attack, the hackers succeeded in backdooring SolarWinds’ Orion network monitoring product, which was shipped to a large number of their customers. The attackers subsequently gained access to networks in which the Orion product was deployed.

Over the past few years, Microsoft has been using CodeQL to investigate vulnerabilities and data breaches. The CodeQL query contributions were a major element in their response against this attack, as well as [past](https://msrc-blog.microsoft.com/2018/08/16/vulnerability-hunting-with-semmle-ql-part-1/) [investigations](https://msrc-blog.microsoft.com/2019/03/19/vulnerability-hunting-with-semmle-ql-part-2/).

## What is build hijacking?

The malware spreads by backdooring *build systems* in order to inject malicious code into product releases, and in turn compromise the users of a shipped release. In particular, it monitors for invocations of `msbuild.exe` ([Microsoft Build Engine](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild)) processes. By giving itself *debugging privileges*, it injects additional malicious code into the build process. This means that while the codebases themselves do not contain any malicious commits or other traces of the malware, the products that are built from those codebases *do* contain the malware. This process of “build hijacking” is explained in more detail in [this technical analysis from Crowdstrike](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/).

## CodeQL security analysis

GitHub CodeQL is a semantic code analysis engine that uses *queries* to analyze source code and find unwanted patterns. For example, CodeQL can track data from an untrusted source (e.g., an HTTP request) that ends up in a potentially dangerous place (e.g., a string concatenation inside a SQL statement resulting in a SQL injection vulnerability).

CodeQL queries can be run on source code databases that CodeQL generates during the build process (for compiled languages). To do so, CodeQL closely observes the build process and subsequently extracts the relevant parts of the source code that is used to build a binary. The output of the extraction process is a structured representation of the source code in relational form: a CodeQL database.

## Using CodeQL to detect traces of Solorigate

If a build server is backdoored with the build hijacking component of the Solorigate malware campaign, the malware will inject additional source code at compilation time. If CodeQL is observing the build process on the infected server, it will extract the injected malicious source code together with the genuine source code. The resulting CodeQL database will therefore contain traces of the malicious Solorigate source code. Note that if your CodeQL database is generated on a machine that is *not* infected, the database will not contain any injected source code.

![Diagram showing code scanning workflow described in blog post](https://github.blog/wp-content/uploads/2021/03/Screen-Shot-2021-03-10-at-4.41.07-PM.png?w=1024&resize=1024%2C589)

The CodeQL queries that were [contributed by the Microsoft team](https://github.com/github/codeql/pull/5083) will detect patterns of malicious C# code injected by the malware. The best way to run these queries is by manually creating a CodeQL database on the potentially-affected server(s), and analyzing that database with the CodeQL extension for Visual Studio Code.

Alternatively, you can generate the CodeQL database and run the queries through a CI/CD pipeline. This could detect build injection on the systems that run your CI/CD jobs (and may be used to build your release artifacts).

### Running the CodeQL queries using Visual Studio Code

1. Install the [VS Code plugin for CodeQL](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/), and follow the [Quick start guide](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql#quick-start-installing-and-configuring-the-extension-1) to set up the [starter workspace](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql#cloning-the-codeql-starter-workspace).
2. [Generate a CodeQL database](https://codeql.github.com/docs/codeql-cli/creating-codeql-databases/) by building your C# source code on a potentially-infected build server.
3. Transfer the CodeQL database to your machine.  
   **Note:** the CodeQL database itself does not contain any (potentially dangerous) compilation artifacts or infected executables. It contains (1) a plaintext copy of the source code that was compiled, and (2) a relations representation of that code.
4. [Load the potentially-affected CodeQL database into VS Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/analyzing-your-projects/).
5. Navigate to `**ql/csharp/ql/src/codeql-suites**`, where you’ll find the **`solorigate.qls`** CodeQL query suite file. Right-click on the file, and select **CodeQL: Run Queries in Selected Files**.

![UI screenshot that shows how to run a CodeQL query how to ](https://github.blog/wp-content/uploads/2021/03/code-scanning-and-codeql-detect-solorigate-fig-2.png?w=512&resize=512%2C72)

Repeat steps 2-5 for every codebase that is potentially affected.

### Running the CodeQL queries in GitHub Code Scanning

In order to run the additional CodeQL queries on a C# codebase in GitHub Code Scanning, create a file `.github/codeql/solorigate.qls` in the repository you would like to analyze:

```yaml
- import: codeql-suites/solorigate.qls
from: codeql-csharp
```

Next, set up a default CodeQL workflow (or edit an existing workflow) and amend the “Initialize CodeQL” section of the template as follows:

```yaml
- name: Initialize CodeQL
uses: github/codeql-action/init@v1
with:
languages: csharp
queries: ./.github/codeql/solorigate.qls
```

If your code requires a special build command to compile, please refer to the [documentation on customizing the CodeQL Code Scanning analysis](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-the-codeql-workflow-for-compiled-languages).

With the above configuration, the additional CodeQL queries will be run. If CodeQL detects any malware indicators (Solorigate or otherwise) in your source code, it will produce an [alert in the GitHub Code Scanning web interface](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/managing-code-scanning-alerts-for-your-repository).

![Screenshot of code scanning alert](https://github.blog/wp-content/uploads/2021/03/code-scanning-and-codeql-detect-solorigate-fig-3.png?w=512&resize=512%2C140)

For more information and configuration examples, please refer to the [documentation for running custom CodeQL queries in GitHub Code Scanning](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-codeql-code-scanning-in-your-ci-system#running-additional-queries).

## Next steps

If CodeQL flags up suspicious elements in a product or codebase, you should conduct a careful manual code review of the affected area. In particular, we suggest that you compare the code that was seen by CodeQL to the original source code.

The queries contributed by Microsoft’s Solorigate response team serve as a heuristic for detecting backdoors, like the one involved in the Solorigate attack. A negative result does not necessarily rule out that a system or network is compromised. Analyzing codebases using CodeQL should be considered just one part in a mosaic of techniques to audit for compromise. For more information on the attack and advice on other auditing techniques, please refer to the [Microsoft Solorigate Resource Center](https://aka.ms/solorigate).

If you have any questions related to CodeQL and Solorigate, please contact your GitHub Advanced Security representative. If you are not currently a GitHub customer, please [contact us through this form](https://enterprise.github.com/contact?utm_source=github&utm_medium=site&utm_campaign=adv-security&ref_page=/features/security&ref_cta=Contact%20Sales&ref_loc=hero), and we’ll be happy to assist further.

## Further reading

If you’d like to know more about the technical background of the Solorigate queries, please refer to [this post on the Microsoft Blog](https://www.microsoft.com/security/blog/2021/02/25/microsoft-open-sources-codeql-queries-used-to-hunt-for-solorigate-activity/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
