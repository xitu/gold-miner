>* 原文链接 : [Embedding Lua in the Web](http://starlight.paulcuth.me.uk/docs/embedding-lua-in-the-web)
* 原文作者 : [paulcuth](https://github.com/paulcuth)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Starlight enables you to run Lua scripts in a webpage by placing Lua code in `<script>` tags.

### Hello world

Here's a simple example:

[JS Bin on jsbin.com](http://jsbin.com/rovibad/embed?html,console)

As you can see we wrap the Lua code in a `<script>` tag with `type="application/lua"`. This tells the browser not to parse it as JavaScript and also tells Starlight that it should parse and translate the code within.

We're also including the Babel browser runtime because Starlight outputs ES6 and, for the time being at least, most browsers do not fully support ES6\. Hopefully over time the need to include Babel will reduce significantly. See also [Using Starlight with Grunt](http://starlight.paulcuth.me.uk/docs/using-starlight-with-grunt) to discover how to precompile your scripts and negate the need for Babel.

You'll also need to include Starlight itself. We're using the boolean attribute `data-run-script-tags` here to tell Starlight to execute the scripts on page load. Without this attribute the scripts will need to be executed manually.

That's all you need to get started. Notice that the `print()` function will output to the browser's console window. This can be modified in the Starlight configuration.

#### MIME types

Starlight will parse any `<script>` tags with the following `type`s:

*   text/lua
*   text/x-lua
*   application/lua
*   application/x-lua

### Including remote scripts

As with JavaScript, you can also include and execute Lua from remote scripts using the `src` attribute. One difference, however, is that files are loaded over [<attr title="XMLHttpRequest">XHR</attr>](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest), so the remote scripts will need to adhere to [<attr title="Cross-Origin Resource Sharing">CORS</attr>](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS).

[counter-app.lua](http://paulcuth.me.uk/starlight/lua/counter-app.lua) [JS Bin on jsbin.com](http://jsbin.com/mohoci/embed?html,output)

Scripts are loaded and parsed in the order that they appear in the page. You can add a `defer` attribute to defer the loading of the script until after others have loaded, so that your script does not block. The `defer` attribute is ignored on inline script tags.

### Executing Lua programmatically from JavaScript

You can use Starlight to execute arbitrary Lua code from within JavaScript, using `starlight.parser.parse()`.

[JS Bin on jsbin.com](http://jsbin.com/rutoni/embed?html,console,output)

A nice way to use the parser in this manner is to place the Lua code in script tags and execute these on demand. In this case, remember to prevent your Lua scripts from executing on page load, by not adding the `data-run-script-tags` attribute.

[JS Bin on jsbin.com](http://jsbin.com/coheya/embed?html,console,output)

### Modules

You can also turn your script tag into a Lua module by giving it a `data-modname` attribute. This script will be preloaded but not executed and can later be required by any other Lua script. Make sure you define a module in a tag that precedes those that require it, in the order they appear in the page.

[JS Bin on jsbin.com](http://jsbin.com/gadequp/embed?html,console)

The `data-modname` attribute can also be used on remote script tags. When using script tags, all modules need to be explicitly defined within the page; using `require()` with a relative file path will fail unless the required script is defined in the markup. This does not apply when you use Starlight to precompile your Lua to JavaScript, see [Using Starlight with Grunt](http://starlight.paulcuth.me.uk/docs/using-starlight-with-grunt) for more information.

[fibonacci-module.lua](http://paulcuth.me.uk/starlight/lua/fibonacci-module.lua) / [fibonacci-app.lua](http://paulcuth.me.uk/starlight/lua/fibonacci-app.lua) [JS Bin on jsbin.com](http://jsbin.com/xumoka/embed?html,output)

### Configuration

Starlight can be configured by creating a configuration object in JavaScript _before_ including the Starlight browser library.

The configuration object is `window.starlight.config` and can currently be used to override the destination of `stdout` and add variables to the Lua global namespace.

In the following example, we are redirecting the `stdout` to output to a DOM element instead of the browser's console window.

[JS Bin on jsbin.com](http://jsbin.com/silezu/embed?html,output)

To use the configuration object to initialise the Lua global environment, see [Interacting with JavaScript](http://starlight.paulcuth.me.uk/docs/interacting-with-javascript).


