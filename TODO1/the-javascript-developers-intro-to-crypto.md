> * 原文地址：[The JavaScript Developer’s Intro to Crypto](https://medium.com/the-challenge/the-javascript-developers-intro-to-crypto-3dcd7839f2e7)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-javascript-developers-intro-to-crypto.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-javascript-developers-intro-to-crypto.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[portandbridge](https://github.com/portandbridge), [Fengziyin](https://github.com/Fengziyin1234)

# 写给 JavaScript 开发者的 Crypto 简介

### 如何在价值互联网（the Internet of Value）上构建 App

![Andrew M Whitman — Bristol Hot Air Balloon Festival 2015 (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/4096/1*05ZhqragwnsDBx-9wK0EJw.jpeg)

在接下来的 2-4 年中，软件开发的世界将会发生很大变化。用户苦恼于个人隐私被侵犯和对其数据管控的无力。与此同时，许多行业都受到低效流程的阻碍，这都是权力、金钱以及控制集中化的结果。

2009 年比特币出现了，在此后的 10 年里，新的互联网基础已经形成：价值互联网。现在可以通过互联网购买、出售、贷款和交易货币，中间没有银行或者中央公司，其费用比以往任何公司都要低。

价值的数字化存储和转移开辟了以前无法实现的新经济模式，例如 [Theta Network](https://www.thetatoken.org/)，它通过向愿意分享视频带宽的观众付费，来构建高性能、分散的视频流平台。目前 Theta 正在用一种名为 TFUEL 的加密货币来奖励观众，这种货币可以用来捐赠给游戏主播，或者在 Sliver.tv 的商店里购买物品。最终，TFUEL 或类似的货币可能会被用于购买游戏内的物品：这已经成为了一个价值数十亿美元的行业。

## 智能合约（Smart Contract） —— 取代中间人

智能合约是一种在分散式架构（例如像 [Ethereum](https://en.wikipedia.org/wiki/Ethereum) 这样的 [blockchain](https://en.wikipedia.org/wiki/Blockchain)）上运行的程序，它能够对数字化资产进行加锁、解锁、发行以及传输。例如，可以在像 Ethereum 这样的网络上发布自己的加密货币。当你这样做时，智能合约会管理这些代币（token）（译者注：可流通的数字权益证明），定义代币的数量，如何发行代币或限制新的供应，以及如何控制代币的转移。

你还可以创建一份表示某幢建筑物的部分所有权，或者一份代表承诺提供计算服务（例如信息存储、带宽或运算能力）的智能合约。后者可用于为那些给 AWS、Google Cloud Platform 或 Microsoft Azure 提供分散版本的人进行经济奖励。有关示例，请参见 [Storj.io](https://storj.io/)和 [iExec](https://iex.ec/)。

智能合约现在开始取代中间人。例如，如果你有一些 ETH（Ethereum 的本地加密货币），[你就可以在今天借钱给自己](https://compound.finance/)，并且当你使用贷款买车或解决临时现金流问题时，你还可以保持你的 ETH 在市场中流通。

## 构建加密应用程序（DApps）

“Crypto” 是 “cryptography” 的缩写，它已经成为“处理区块链、加密货币、分散式应用和分散式分类账技术的行业”的简称。

如果你想构建一个不依赖 Amazon 进行托管，或者 Facebook 的社交图谱，或者 Google 进行用户身份验证的应用程序，只要有社区成员愿意运行（和维护），它就可以成为开源的并且可以持续运行下去，（想想 BitTorrent）你来对了地方。

我们将从 Ethereum 开始，尽管如今，Ethereum 不是唯一的选择。Ethereum 是一种区块链，旨在托管能够支持 DApps（分散式应用）的图灵完备智能合约。

如果你想构建 DApps，但又是第一次接触，那我建议你先学习 HTML、CSS 和 JavaScript。Ethereum 使用虚拟机，而 Ethereum 虚拟机（EVM）最流行的编程语言是 Solidity。

我建议不要从 Solidity 或者 EVM 能做些什么开始考虑你的应用。相反，试着想象一下，当数字资产转移给其他人而无需中间的银行或经纪人时，你可以做些什么。试着想象一下如何在应用中以对用户友好的方式表示这些功能。

如果不在应用中构建钱包，那么和钱包 API 进行交互将会很难处理。例如，在 Ethereum 上，你必须使用 [Web3 API](https://web3js.readthedocs.io/en/1.0/) 来触发需要用户交互的钱包交易。到目前为止，好像一直都是坏消息，因为它要求用户下载 [Metamask 扩展](https://metamask.io/) ，或者支持 Ethereum 的浏览器，如 [Trust Wallet](https://trustwallet.com/) 或 [Coinbase Wallet](https://wallet.coinbase.com/)。Trust Wallet 和Coinbase Wallet 都仅仅只是具有内置钱包和交易批准 UI 的 Web3 感知浏览器。

让用户安装和使用扩展程序或是全新的浏览器非常困难，几乎没有潜在用户会这样做。到目前为止，这已经严重影响了 DApp 行业，并严重限制了 Web3 的用户群体。

最近，一些最受欢迎的 DApps（如 [Sliver.tv](https://www.sliver.tv/)）在 DApp 内部内置了钱包。在这些情况下，你不需要第三方钱包集成。你可以在 Chrome 中使用自己的应用。缺点是它更集中化：用户需要更加信任你的 DApp —— 这使得 DApp 开发人员必须肩负更多的安全责任。

如果每一个 DApp 都想要以原生的方式在 Chrome 中构建自己的集成钱包的话，会很疯狂的。幸运的是，新的解决方案正在兴起。[Fortmatic](https://fortmatic.com/) 是一个 JavaScript 软件开发工具包（SDK），它在 Chrome 中提供 Web3 功能。你的用户将无需下载扩展程序或者特殊浏览器。

让我们来构建一个无需任何扩展或单独下载，可以在 Chrome 中运行的简易 DApp。

## 项目设置

> **注意**：这样的小细节往往会更新得很快。如果它们不工作了，请在下面留言。也许有人可以帮你搞清楚。

1. 打开一个 [终端](https://www.codecademy.com/learn/learn-the-command-line)。确保安装了 Node（我喜欢用 [nvm 安装 Node](https://github.com/nvm-sh/nvm#installation-and-update)）。

2. 创建项目目录并安装一些项目依赖：

```
mkdir hello-eth

cd hello-eth

npm init -y

npm install --save react react-dom next fortmatic web3

npm install --save-dev @babel/core @babel/register \
  @babel/polyfill @babel/preset-env @babel/preset-react \
  @babel/register eslint-config-prettier \
  eslint eslint-plugin-prettier eslint-plugin-react \
  eslint-plugin-react-hooks prettier riteway watch tap-nirvana
```

3. 打开 `package.json` 并按照下面的内容替换 “scripts” 值：

```
{
  "lint": "eslint --fix . && echo 'Lint complete.'",
  "test": "NODE_ENV=test node -r @babel/register -r @babel/polyfill src/index.test.js",
  "watch": "watch 'clear && npm run -s test | tap-nirvana && npm run -s lint' src",
  "dev": "next",
  "build": "next build",
  "start": "next start"
}
```

4. 创建一些目录：

```
mkdir pages
mkdir src
mkdir src/views
```

5. 将这些文件添加到项目根目录下：

`.babelrc`:

```
{
  "env": {
    "development": {
      "presets": ["next/babel"]
    },
    "production": {
      "presets": ["next/babel"]
    },
    "test": {
      "presets": [
        "@babel/env",
        "@babel/react"
      ],
      "plugins": [
        "styled-jsx/babel"
      ]
    }
  }
}
```

`.eslintignore`:

```
node_modules
.next
```

`.eslintrc`:

```
{
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "node": true
  },
  "plugins": [
    "react",
    "react-hooks"
  ],
  "extends": ["eslint:recommended", "plugin:react/recommended", "plugin:prettier/recommended"],
  "parserOptions": {
    "sourceType": "module",
    "ecmaVersion": 2018
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "rules": {
    "linebreak-style": ["error", "unix"],
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn"
  }
}
```

## Hello, World!

现在创建 `src/views/index.js`：

```
import React from 'react';

const Hello = () => <h1>Hello, world!</h1>;

export default Hello;
```

使用 [Next.js](https://nextjs.org/)，你放入 `/pages` 下的任何文件将在 `/<page-name>` 下自动创建一个不带 `.js` 文件扩展名的路由。它还可以做到自动化的服务端渲染、自动化的 bundle 构建和优化，当你使用 Zeit Now 进行部署时，它会做很多很酷的事情来自动优化客户端交付。当你的应用切换到生产模式时，这都是好消息，但我们使用 Next.js 的真正原因是因为它是我最喜欢的辅助 React 应用的方法。

Next.js 具有内置的 `\<style jsx>` CSS 支持，而且你不用知道如何手动连接路由。现在让我们现在来获取 index 的视图路由。你只需创建一个名为 `pages/index.js` 的新文件：

```
import Home from '../src/views';
export default Home;
```
 
只需导入视图，然后再将它导出，仅此而已。我喜欢将真正的组件定义保存在 `src/` 目录树中，这样我就可以轻松地将相关文件放在同一个位置，而不会意外地为它们创建一堆路由。换句话说，`/pages` 仅用于路由。`/src` 用于存放真正的源代码。

## 给我展示一下 Crypto 部分

到目前为止，你刚刚看到的是 JavaScript 和 React 代码。对于 crypto/DApp 开发人员来说，好消息是至少有 75％ 的项目代码（可能更多）都是用 JavaScript 编写的，而 React 是一个很棒的 UI 代码框架。但是，如果你要在价值互联网上进行交易，你可能需要使用一些 crypto API。

在刚开始进行设置时，我们使用 `npm` 安装了 Fortmatic 和 Web3。现在我们将它们导入我们的 index 页面，以便我们可以在代码中使用它们。首先，你需要[设置 Fortmatic 帐户](https://dashboard.fortmatic.com/login)才能获得你的 API 密钥。

你应该能够使用 [GitHub](https://github.com/) 注册，然后立即就可以获取到你的 testnet 密钥。Fortmatic 会自动在 testnet 上发送新用户的 ETH 进行试验。

Fortmatic 是 Ethereum 区块链 API 服务的监管提供商，还提供了非常友好的用户登录体验。用户可以使用电话号码登录你的应用。他们将获得一个安全码 SMS，然后用它来验证你的应用。完成后，你就可以获得用户的钱包地址。

Fortmatic 使用由 Fortmatic 硬件安全模块（HSM）保护的加密锚安全架构来存储用户私钥。

作为想要真正黏住用户的 DApp 开发人员来说，这很有吸引力，因为作为先决条件，将存储密钥的责任和复杂性推给用户并不是一种对用户友好的方式。自己处理它是有风险的。Fortmatic 为我们提供了一个很好的缓冲区。

通过允许用户将这些资产转移到他们自己的私人托管钱包中，你仍然可以允许用户来声明他自己的 Fortmatic 钱包资产保管权。让我们为我们的 `src/views/index.js` 组件添加 Fortmatic 身份验证：

```
import React, { useEffect } from 'react';

// 导入 web3
import Fortmatic from 'fortmatic';
import Web3 from 'web3';

const formatic_api_key = '<your test key here>';

const initializeWeb3 = () => {
  const fm = new Fortmatic(formatic_api_key);
  const web3 = new Web3(fm.getProvider());
  window.web3 = web3;

  // 获取当前用户帐户地址。
  // 如果需要，验证用户身份。
  web3.eth.getAccounts().then(accounts => {
    // 你可以使用钱包地址作为密钥
    // 来存储和检索 DApp 的用户数据。
    console.log(accounts);
  });
};

const Hello = () => {
  // 当组件挂载时，React hook 会被触发；
  useEffect(initializeWeb3, []);

  return <h1>Hello, world!</h1>;
};

export default Hello;
```

一旦用户使用 Fortmatic 登录，你就可以使用 Web3 API。你可以在其上[构建钱包 UI](https://repl.it/@fortmatic/demo-wallet)，让用户以加密方式签署数据，并在 Ethereum 智能合约上[发布调用方法](https://developers.fortmatic.com/docs/generic-contract-call)。

## 扩展 DApps 的技巧

区块链的第一条规则是在区块链你应该尽可能少做事。在区块链上存储数据非常昂贵（请参阅 [IPFS](https://ipfs.io/)）。

如果可以的话，尽量选择批量交易。了解如何使用 [Merkle Trees](https://en.wikipedia.org/wiki/Merkle_tree)锚定[已签名的可验证声明](https://w3c.github.io/vc-data-model/)。查看 [Graph 协议](https://thegraph.com/) 来获取有效的区块链查询方法。

你可能需要建立自己的智能合约以实现你的想法。这个会在以后的文章中细说。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
