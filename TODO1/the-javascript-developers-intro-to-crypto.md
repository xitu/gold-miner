> * 原文地址：[The JavaScript Developer’s Intro to Crypto](https://medium.com/the-challenge/the-javascript-developers-intro-to-crypto-3dcd7839f2e7)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-javascript-developers-intro-to-crypto.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-javascript-developers-intro-to-crypto.md)
> * 译者：
> * 校对者：

# The JavaScript Developer’s Intro to Crypto

### How to Build Apps on the Internet of Value

![Andrew M Whitman — Bristol Hot Air Balloon Festival 2015 (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/4096/1*05ZhqragwnsDBx-9wK0EJw.jpeg)

Over the next 2–4 years, the world of software development is going to change a lot. App users are expressing frustration about privacy violations and how little control they have over their own data. In the meantime, many industries are held back by process inefficiencies which are the result of centralization of power, money, and control.

Bitcoin disrupted that in 2009, and in the 10 years since, the foundations of a new internet have been forming: the internet of value. It’s now possible to buy, sell, loan, and transact money over the internet with no bank or central company in the middle, with radically lower fees than any company has ever offered before.

The digital storage and transfer of value has opened up new economic models that were not possible before, such as [Theta Network](https://www.thetatoken.org/), which pays watchers to share their video bandwidth, building a high performance, decentralized video streaming platform. Theta is currently rewarding watchers with a cryptocurrency called TFUEL, which can be used to donate earnings to streamers (gamers who stream their live gameplay), or purchase items in a shop on [Sliver.tv](https://www.sliver.tv/win/theta). Eventually, TFUEL or currencies like it might be used to purchase in-game items: already a multi-billion dollar industry.

## Smart Contracts — Replacing the Middle Man

A smart contract is a program that runs on a decentralized architecture (such as a [blockchain](https://en.wikipedia.org/wiki/Blockchain) like [Ethereum](https://en.wikipedia.org/wiki/Ethereum)), which is capable of locking, unlocking, issuing, and transferring digital assets. For instance, it’s possible to issue your own cryptocurrency on top of networks like Ethereum. When you do, a smart contract governs those tokens, defining how many there are, how new supply is issued or limited, and how transfers of tokens are controlled.

You can also create a smart contract that represents fractional ownership in a building, or a smart contract that represents promises to supply computing services, such as information storage, bandwidth, or CPU power. The latter can be used to create economic incentives to supply decentralized versions of AWS, Google Cloud Platform, or Microsoft Azure. See [Storj.io](https://storj.io/) and [iExec](https://iex.ec/) for examples.

Smart contracts are beginning to replace the middleman. For example, if you have some ETH (Ethereum’s native cryptocurrency), [you can lend yourself money today](https://compound.finance/) and keep your ETH in the market while you use the loaned amount to buy a car or solve temporary cash flow issues.

## Building Crypto Apps (DApps)

“Crypto” is short for “cryptography”, but it’s become the short way of saying “the industry dealing with blockchain, cryptocurrencies, decentralized applications, and decentralized ledger technologies”.

If you want to build an app that doesn’t rely on Amazon for hosting, or Facebook for social graph, or Google for user authentication, that can be open-sourced and could continue to operate as long as there are community members willing to run nodes, (think BitTorrent) you’re in the right place.

We’ll start with Ethereum, although these days, Ethereum isn’t the only choice. Ethereum is a blockchain designed to host Turing-complete smart contracts capable of supporting DApps (Decentralized Applications).

My first tip if you’re new to building DApps is that if you want to build DApps, first learn HTML, CSS, and JavaScript. Ethereum uses a virtual machine, and the most popular programming language for the Ethereum Virtual Machine (EVM) is Solidity.

I don’t recommend thinking of your app in terms of Solidity and what you can do with the EVM. Instead, try to imagine what you can do when there are digital assets which can be securely transmitted to other people without a bank or broker in the middle. Try to imagine the most user-friendly way to represent those capabilities in your app.

The one thing that is difficult to get around without building a wallet right into your application is interacting with wallet APIs. For example, on Ethereum, you’d use the [Web3 API](https://web3js.readthedocs.io/en/1.0/) to trigger wallet transactions that require interaction from the user. Up until now, that has been mostly bad news, because it requires users to download the [Metamask extension](https://metamask.io/), or an Ethereum-capable browser such as the [Trust Wallet](https://trustwallet.com/) or [Coinbase Wallet](https://wallet.coinbase.com/). Both Trust Wallet and Coinbase Wallet are really just Web3-aware browsers with built-in wallets and transaction approval UIs.

Getting users to install and use an extension or a whole new browser is really hard, and very close to zero percent of your potential users will do it. That has crippled the DApp industry to date, and has severely limited the Web3 userbase.

Recently, some of the most popular DApps (like [Sliver.tv](https://www.sliver.tv/)) have integrated wallets right inside the DApp. In those cases, you don’t need a 3rd party wallet integration. You can make your app work in Chrome. The downside is that it’s more centralized: users need to place more faith in your DApp — which places more security responsibility on the DApp developer.

It would probably be crazy for every DApp that wants to work natively in Chrome to build its own integrated wallet. Luckily, new solutions are emerging. [Fortmatic](https://fortmatic.com/) is a JavaScript Software Development Kit (SDK) which provides Web3 capabilities inside Chrome. No need for your users to download extensions or special browsers.

Let’s build a simple DApp that works in Chrome without any extensions or separate downloads required.

## Project Setup
> **Note:** Details like this tend to change quickly. If they don’t work for you, leave a comment. Maybe somebody can help you figure it out.

1. Open a [terminal](https://www.codecademy.com/learn/learn-the-command-line). Make sure you have Node installed (I like to [install Node with nvm](https://github.com/nvm-sh/nvm#installation-and-update)).

2. Create your project directory and install some dependencies:

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

3. Open `package.json` and replace the “scripts” value with the following:

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

4. Create some directories:

```
mkdir pages
mkdir src
mkdir src/views
```

5. Add some files to the project root directory.

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

Now create `src/views/index.js`:

```
import React from 'react';

const Hello = () => <h1>Hello, world!</h1>;

export default Hello;
```

With [Next.js](https://nextjs.org/), any file you drop in `/pages` will create a route automatically at `/\<page-name>` minus the `.js` file extension. It also does automatic server-rendering, automatic bundle creation and optimization, and when you deploy with Zeit Now, it will do a lot of cool things to automatically optimize client delivery. This is all good news when it’s time to ship your app to production, but the real reason we’ve used Next.js is because it’s my favorite way to bootstrap a working React app.

Next.js has built-in CSS support with `\<style jsx>` and you don’t need to figure out how to manually wire up your routing. Let’s get our index view routing right now. Just create a new file called `pages/index.js`:

```
import Home from '../src/views';
export default Home;
```

That’s it. Just import the view, and export the same view. I like to keep the actual component definitions in the `src/` directory tree so that I can easily colocate related files in the same spot without accidentally creating a bunch of routes for them. In other words, `/pages` is for routing-only. `/src` is for the real source code.

## Show Me the Crypto

So far you’ve just seen JavaScript and React code. The good news for crypto/DApp developers is that at least 75% of your project code (probably a lot more) will be written in JavaScript, and React is a great framework for UI code. But if you’re going to transact on the internet of value, you’ll probably need to work with some crypto APIs.

At the beginning of the setup, we installed Fortmatic and Web3 with `npm`. Now we’re going to import them into our index page so we can use them. First, you’ll need to [set up a Fortmatic account](https://dashboard.fortmatic.com/login) to get your API key.

You should be able to sign up with [GitHub](https://github.com/) and immediately grab your testnet key. Fortmatic will automatically send new users ETH on testnet to experiment with.

Fortmatic is a custodial provider of Ethereum blockchain API services, including a very user-friendly sign-in experience. Users sign into your app by supplying their phone number. They’ll get a security code SMS, which they’ll use to authenticate with your app. You’ll get the user’s wallet address when that’s done.

Fortmatic stores user private keys using the cryptographic anchor security architecture safeguarded by Fortmatic’s Hardware Security Modules (HSMs).

As a DApp developer looking for real user traction, this is attractive because pushing the responsibility and complexity of key storage onto users as a prerequisite is not a friendly way to onboard users. Handling it yourself is risky. Fortmatic provides a great middle ground.

You can still allow users to claim custody of assets from their Fortmatic wallets by allowing them to transfer those assets to their own privately managed wallets. Let’s add Fortmatic authentication to our `src/views/index.js` component:

```
import React, { useEffect } from 'react';

// import web3 providers
import Fortmatic from 'fortmatic';
import Web3 from 'web3';

const formatic_api_key = '<your test key here>';

const initializeWeb3 = () => {
  const fm = new Fortmatic(formatic_api_key);
  const web3 = new Web3(fm.getProvider());
  window.web3 = web3;

  // Get current user account address.
  // Will authenticate the user if needed.
  web3.eth.getAccounts().then(accounts => {
    // You can use the wallet address as a key
    // to store and retrieve user data for your DApp.
    console.log(accounts);
  });
};

const Hello = () => {
  // React hook fires once, when the component mounts
  useEffect(initializeWeb3, []);

  return <h1>Hello, world!</h1>;
};

export default Hello;
```

Once a user is logged in with Fortmatic, you have the Web3 API at your disposal. You can [build wallet UIs](https://repl.it/@fortmatic/demo-wallet) on top of it, have the users cryptographically sign data, and [issue method calls](https://developers.fortmatic.com/docs/generic-contract-call) on Ethereum smart contracts.

## Tips for Scaling DApps

The first rule of blockchains is you should do as little as possible on the blockchain. Storing data on the blockchain is expensive (See [IPFS](https://ipfs.io/) instead).

Batch transactions if you can. Learn how to anchor [signed verifiable claims](https://w3c.github.io/vc-data-model/) using [Merkle Trees](https://en.wikipedia.org/wiki/Merkle_tree). Check out [The Graph protocol](https://thegraph.com/) for efficient blockchain queries.

You may need to build your own smart contracts to pull off your idea. That’s a lesson for another day.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
