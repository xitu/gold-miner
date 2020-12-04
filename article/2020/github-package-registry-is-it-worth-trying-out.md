> * 原文地址：[GitHub Package Registry: Is it Worth Trying Out?](https://blog.bitsrc.io/github-package-registry-is-it-worth-trying-out-62163aa3d518)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/github-package-registry-is-it-worth-trying-out.md](https://github.com/xitu/gold-miner/blob/master/article/2020/github-package-registry-is-it-worth-trying-out.md)
> * 译者：
> * 校对者：

# GitHub Package Registry: Is it Worth Trying Out?

#### Get to know GitHub Package Registry and its Core Features

![Photo by [Nana Smirnova](https://unsplash.com/@nananadolgo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10392/0*5jrNYn-hF3R_LkQi)

GitHub Package Registry was developed and introduced in mid-2019 by Microsoft. With the GitHub and NPM acquisitions, this feature seems to be an excellent move by Microsoft to expand the GitHub ecosystem. At the same time, GitHub uses the following tagline to emphasize this fact.

> # “Your packages, at home with their code” — GitHub

But is this alone worth enough to try it out? And do we really need another package manager in the first place?

The answer to these questions is not that clear, especially when taking into consideration trending JavaScript registries like [Bit](https://bit.dev).

![[Bit](https://bit.dev) components: a “super-set” of node packages](https://cdn-images-1.medium.com/max/3678/0*rv1slOFFspZp5dqn.gif)

Bit components are a super-set of node packages. They can be consumed as standard packages but they also carry their source-code, history, and other configurations that make it possible to maintain them as independent projects. So, if we’re looking to couple a package to its repository, Github Packages is not the only option out there.

Let’s find out more.

## Is it worth trying out?

If you are one of the 40 million using GitHub, accessing it is just one “Tab” away under your GitHub profile or under your GitHub Organization.

![Screenshot of GitHub Package Registry under my profile](https://cdn-images-1.medium.com/max/2538/1*PowgC6YYeQ7J7oN1edD9Vw.png)

> # When I tried it out for the first time, I found it intuitive and easy to start with. I have started with the Free plan, and it seems to be sufficient for a small project with few private packages.

However, you might wonder whether the GitHub Package Manager will standout as a core feature on its own? So far, GitHub has placed it smartly in its core product portfolio. Besides, they have already fulfilled a set of high-impact features for us to get started.

Let’s take a look at some of its features that pushes it to the next level.

#### 1. Supports 5 Languages and Clients

Unlike NPM, focused on NodeJS packages, the GitHub Package Registry supports a range of package types and clients, as shown below.

![Support for package registries, Source: [GitHub](http://Support for package registries)](https://cdn-images-1.medium.com/max/3056/1*CNuP0W1N0Uebuajvx46A1w.png)

We can expect more support tools and clients in upcoming updates as well.

> # [Support for Swift](https://github.blog/2019-06-03-github-package-registry-will-support-swift-packages/) is already in its Beta stage, and we could expect it to go live in a few months.

Since the GitHub package registry supports multiple package formats, it brings convenience for you to host different software packages in one place. This also works perfectly well with Microservices, where the technology could differ from project to project.

#### 2. Workflow Integration coupled with GitHub Actions

Combining GitHub APIs, GitHub Actions, and WebHooks allows you to develop a fully integrated end to end DevOps workflow, including CI/CD pipelines. You can also customize pre and post publishing workflows with the use of GraphQL and WebHooks.

![GitHub Package Management Tasks in GitHub Actions Marketplace](https://cdn-images-1.medium.com/max/2000/1*PECyA1fWltGS1dZo9g7f-w.png)

> # You can already find prebuilt tasks in GitHub Actions to simplify your work with GitHub Package Management.

In a nutshell, with the native integration with GitHub Actions, you can automate the entire package lifecycle and its operations in one place.

#### 3. Access Control for Users and Tools

This allows managing permission across the code repositories and packages in one place. It also simplifies the access control for CI/CD pipelines as well. Besides, GitHub authentication can be used to access both source code and private packages.

> # Since GitHub packages inherit the permissions associated with the repository you don’t need to maintain separate package registry permissions.

You can also choose between hosting your package as public or private depending on the requirements.

#### 4. Code and Package Insights in One Place

Similar to other package managers, the GitHub package registry allows you to view package contents, download statistics, version history to get a better understanding before you download.

> # Since we can see GitHub stars and forks to understand its activity, it works perfectly well to find active packages before using them in our code.

Even with NPM packages, I used to go to GitHub and see how many stars are there, number of contributors and look for the last commit date, which now you can find in one place.

---

## But where should I start if I’m already hosting packages elsewhere?

The good news is you don’t have to, especially for public packages. Suppose your private packages are dependent on any other public package registry like NPM. Those dependencies will still work seamlessly once you move your root packages to GitHub Package Registry. In fact, you only need to change the registry URL and the Access Control Mechanism once you move your NPM packages to GitHub Package Registry.

Let’s go through a quick example to understand how we can use GitHub Package Registry to publish an NPM package and consume it step by step.

#### Step 1: Authenticate to GitHub Package Registry

First, you need to have a GitHub access token to authenticate your identity to the GitHub registry. Either you can use your existing token, or you can create one using [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new). Here I name my token as **githubReg.**

![Screenshot by Author: Creating a new access token](https://cdn-images-1.medium.com/max/4046/1*mBJOGUKYRHObEQvd4c4iZA.png)

You need to set up your .npmrc file, which is the configuration on how the NPM client talks to the NPM registry itself. Open the terminal and run `code .npmr`. It will open a blank file and replace the following line with your access_token.

```
//npm.pkg.github.com/:_authToken=TOKEN
```

Then initialize a new NPM project and open it up with VSCode using `npm init`.

#### Step 2: Publish the Package

Create a local .nmprc file in the root directory of the project and add the following line. Here, replace OWNER ****with the name of the user or the organization.

```
@OWNER:registry=https://npm.pkg.github.com/
```

Create the main JavaScript file and write a small function. Here I made a file called index.js in the root directory to test the package.

```
module.export = () => {
   console.log("hello new one");
}
```

After that, you need to verify your package’s name and add the repository in your project’s package.json. Then push all changes to git.

**Note**: Here you need to create your own repository and add its details to the below file.

```
{
   "name": "@ChameeraD/pkg-git-demo",
   "version": "1.0.0",
   "description": "",
   "main": "index.js",
   "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
   },
   "repository": {
      "url": "git://github.com/ChameeraD/pkg-git-demo.git."
   },
   "publishConfig": {
      "registry":"https://npm.pkg.github.com/"
   },   
   "author": "",
   "license": "ISC"
}
```

Finally, publish your package using `npm publish`.

> **Note:** It is possible to create GitHub packages that use other npm packages as dependencies as well. [eDEX-UI](https://github.com/GitSquared/edex-ui) is a cross-platform terminal emulator and system monitor that looks and feels like a sci-fi computer interface which is one of the tending packages which hosed in the GitHub registry. But if we look into the deep of the package implementations, they have used npm dependencies which are **“electron”, “electron-rebuild”, “node-abi”**, and **“node-json-minify”**.

#### Step 03: Using the Package as a Dependency

You can add your package to any of the projects.

1. Create a local .npmrc file in your project root directory and add the line @**OWNER**:registry=https://npm.pkg.github.com/ similar to what we did it in package creation).
2. Add the package to a project using Yarn or NPM. e.g: Using Yarn yarn add @ChameeraD/pkg-git-demo .
3. Finally, you can import the package into your code and use it.
import demoPkg from ‘@ChameeraD/pkg-git-demo’;
 demoPkg();

![Screenshot by Author: Output log by of the package](https://cdn-images-1.medium.com/max/2196/1*_xmY-6FUmxr8zJG6Znlh0w.png)

Although GitHub Package Manager comes with lots of promises and feature set, it has its limitations.

## GitHub Package Manager Limitations

To keep the list short and focused, I will only highlight those that affect most developers.

#### Only Supports Scoped NPM Packages

Migrating non-scoped packages from npm to the GitHub package registry can get tedious since GitHub only supported scoped packages for npm (e.g., npm install @source/my-package).

If you move any existing packages without scopes, you will need to add the scopes and modify the code’s imports for that to work.

#### Migration Challenges

Migrating from multiple package registries can be tedious because there are differences between technologies ([Docker](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages), [.NET](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages)).

If you already use any other package registry, version issues can occur due to package updates in the transition phase. For example, if you maintain a package both in the npm and GitHub registry you need to maintain its versions as well. So it is better to plan the migrations knowing the dependencies and go for a single package registry.

#### Less Customizable.

It is less customizable, Users are not able to use custom authentication mechanisms, cannot have self-hosted registries. lack of this feature will limit developers working offline and in poor network conditions.

## Conclusion

Publishing a package into GitHub Package Registry is a whole new experience with the simplicity of keeping source code and packages in one place.

With the current focus of supporting many types of packages (already supporting several), it seems that GitHub Package Registry drives towards universally supporting all the package types. Besides, if you use GitHub already for source repositories, using GitHub Package Registry is a no brainer.

Thank you for Reading !!!

---

## Learn More
[**A Better Way to Share Code Between Your Node.js Projects**
**Learn why you’ve probably been sharing code modules the wrong way.**blog.bitsrc.io](https://blog.bitsrc.io/a-better-way-to-share-code-between-your-node-js-projects-af6fbadc3102)
[**NPM Clients That Are Better Than The Original**
**For all of its pros, npm has several flaws. These 3 alternatives try to improve upon them and offer alternatives to…**blog.bitsrc.io](https://blog.bitsrc.io/npm-clients-that-are-better-than-the-original-cd54ed0f5fe7)
[**Meet Bit’s GitHub Integration to Ensure Latest Component Versions**
**Keep your projects synced with automated GitHub pull requests on new component versions.**blog.bitsrc.io](https://blog.bitsrc.io/announcing-auto-github-prs-for-component-version-bumping-74e7768bcd8a)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
