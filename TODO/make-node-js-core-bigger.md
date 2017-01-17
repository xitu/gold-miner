> * 原文地址：[Make Node.js Core Bigger](https://medium.com/node-js-javascript/make-node-js-core-bigger-97ca7ef62b77#.7ofxzzhpt)
* 原文作者：[Mikeal](https://medium.com/@mikeal?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Make Node.js Core Bigger #

In defense of a larger Node.js Core.

Node.js currently has the smallest standard library of any comparable platform. Combined with great ecosystem tooling like [npm](https://npmjs.org/) this approach has been a huge success.

This success has created a culture in Node.js that is militant about small re-usable modules, a large ecosystem, and a small core. There’s even a fairly vocal push to make the *existing* Node.js Core surface area **smaller**.

[**Spotlight #6: "Small Core" - Keeping Node Core Small with Sam Roberts and Thomas Watson**](https://changelog.com/spotlight/6) 

Lost in the enthusiasm for our ecosystem is the role of what Node.js *did* include in its standard library played on *enabling* that ecosystem.

As new technologies emerge there continues to be a need for Node.js Core to set compatibility standards in order for our ecosystem to thrive.

#### Not having require(‘http’) would have been a disaster. ####

When Node.js started all comparable platforms had standards to connect an HTTP “server” to a “framework.”

[CGI](https://www.w3.org/CGI/) (Perl), [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) (Python), and [Rack](https://en.wikipedia.org/wiki/Rack_%28web_server_interface%29) (Ruby) are all essentially the same thing, a way to remove the HTTP parsing from the API most developers will actually write their applications to: their web framework. This is particularly important for platforms with poor concurrency because they rely on external web servers (Apache, Nginx, etc) to manage incoming connections and related parsing.

When Node.js started in 2009 CommonJS had already defined similar standard for JavaScript called [JSGI](http://wiki.commonjs.org/wiki/JSGI). Support for this standard already existed in other JS platforms like Narwhal and there was pressure to implement it in Node.js as well.

Early Node.js contributor and future npm author [isaacs](https://github.com/isaacs) put together a version of JSGI called [EJSGI](https://github.com/isaacs/ejsgi) (Evented-JSGI) that was compatible with Node.js’ async concurrency model; but this wasn’t the route Node.js ended up taking.

Instead, Node.js went **much farther** than other platforms. Node.js essentially prescribed the “framework” layer of API and bundled it with the **entire server implementation**. While on the surface Node.js had a smaller total standard library that its contemporaries, it actually went much farther in what it did define.

### Frameworks can be ecosystem poison. ###

Back in 2009, you could look at Ruby and Python and the multitude of web frameworks available for each and see what the problem was. A diversity of modules is only good for an ecosystem if they are actually compatible with one another. Since frameworks create their own vertical plugin systems they end up with component ecosystems that are incompatible with one another.

Node.js’ decision to define this layer inverted that trend, forcing a high level of compatibility between modules built for HTTP. When frameworks eventually did emerge they extended the standard API rather than creating entirely incompatible APIs of their own. This meant that most of the modules built for theses frameworks were compatible with one another and that modules written for the “standard” HTTP API worked with every framework.

A lot of attention is paid to the **size** of the Node.js ecosystem because it’s the largest in the world. Lost in our admiration over its size is the fact that those modules have the **highest level of compatibility** with one another compared to other platforms. That compatibility is all the result of standardized patterns defined by Node.js Core like Streams, Modules, error first callbacks, and to lesser recognized APIs like require(‘http’).

### Standards belong in Core. ###

Maintaining the reference implementations of standards is a burden, there’s no doubt about that. Node.js Core’s stream library will always lag behind the one in npm. *But that doesn’t mean that it doesn’t belong in Core.*

In order for standards to actually reach a critical mass of adoption in the ecosystem, in order for them to truly be relied upon, they have to be included in Core. There are great standards outside of Core in the Node.js ecosystem but none with enough adoption that they can be taken for granted.

[Abstract Blob Store](https://github.com/maxogden/abstract-blob-store) is a fantastic standard, one that I try to use whenever possible. While many influential Node.js developers conform to this standard it is nowhere near the point of adoption that it can always be relied upon. Several cloud services still don’t have an implementation and it’s nowhere near the point where service providers conform to it by default, in contrast to the standards defined by Node.js Core.

The reason we try to keep things out of Core is to encourage innovation in the ecosystem. Standardization is a process of ***discouraging*** a particular type of innovation that limits compatibility. Standardization requires that we de-value and discourage un-compliant innovation. Including these standards in Core discourages competitive standards in the ecosystem **and that’s exactly what we want**.

In the future we’ll want to add standard APIs for technologies like HTTP/2 because we’ll want to replicate the highly compatible ecosystem for HTTP/2 that we have for HTTP/1.1.
